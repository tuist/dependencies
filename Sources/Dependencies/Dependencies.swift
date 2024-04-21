import Foundation
import SwiftUI

public enum DependencyType {
    case multi
    case single
}

private extension DependencyType {
    func factory<T>(factory: @escaping (DependenciesResolver) async throws -> T) ->  DependencyFactory {
        switch self {
        case .multi:
            return .multi(factory)
        case .single:
            return .single(factory)
        }
    }
}

enum DependencyFactory {
    case single((DependenciesResolver) async throws -> Any)
    case multi((DependenciesResolver) async throws -> Any)
}

public enum DependenciesError: Error, CustomStringConvertible {
    case alreadyRegisteredDependency(Any.Type)
    case dependencyNotFound(Any.Type)
    case circularDependency([String])
    
    public var description: String {
        switch self {
        case let .alreadyRegisteredDependency(type):
            return "The dependency \(String(describing: type)) has already been registered"
        case let .dependencyNotFound(type):
            return "The dependency \(String(describing: type)) is not registered"
        case let .circularDependency(dependencyChain):
            return "We found a circular dependency: \(dependencyChain.map({ String(describing: $0) }).joined(separator: " > "))"
        }
    }
}

public actor DependenciesResolver {
    let dependencies: Dependencies
    let dependencyChain: [String]
    
    init(dependencies: Dependencies, dependencyChain: [String]) {
        self.dependencies = dependencies
        self.dependencyChain = dependencyChain
    }
    
    public func resolve<T>(_ type: T.Type) async throws -> T {
        var dependencyChain = dependencyChain
        dependencyChain.append(String(describing: type))
        if let _ = dependencyChain.anyDuplicate() {
            throw DependenciesError.circularDependency(dependencyChain)
        }
        return try await self.dependencies.dependency(type, dependencyChain: dependencyChain)
    }
}

public actor Dependencies {
    
    /**
     This dictionary contains the factory functions to create an instance of a given dependency. The factory functions
     are indexed by an object identifier obtained by the type of dependency.
     The instantiation of the dependencies happens lazily when `dependency` is invoked, ensuring that the type (`.multi` or `.single`)
     is respected.
     */
    private var factories: [ObjectIdentifier: DependencyFactory] = [:]
    private var singleDependencies: [ObjectIdentifier: Any] = [:]
    
    public func register<T>(_ type: DependencyType = .single, _ factory: @escaping (DependenciesResolver) async throws -> T) throws {
        let identifier = ObjectIdentifier(T.self)

        if factories[identifier] != nil {
            throw DependenciesError.alreadyRegisteredDependency(T.self)
        }
        
        factories[identifier] = type.factory(factory: factory)
    }
    
    public func dependency<T>(_ type: T.Type) async throws -> T {
        try await dependency(T.self, dependencyChain: [])
    }
    
    fileprivate func dependency<T>(_ type: T.Type, dependencyChain: [String]) async throws -> T {
        let identifier = ObjectIdentifier(T.self)

        guard let factory = factories[identifier] else {
            throw DependenciesError.dependencyNotFound(T.self)
        }
        
        let resolver = DependenciesResolver(dependencies: self, dependencyChain: dependencyChain)
              
        switch factory {
        case let .multi(instantiate):
            return try await instantiate(resolver) as! T
        case let .single(instantiate):
            if let singleDependency = singleDependencies[identifier] {
                return singleDependency as! T
            }
            let singleDependency = try await instantiate(resolver)
            singleDependencies[identifier] = singleDependency
            return singleDependency as! T
        }
    }
}

private extension Array where Element: Hashable {
    func anyDuplicate() -> Element? {
        var seen = Set<Element>()
        for value in self {
            if seen.contains(value) {
                return value
            }
            seen.insert(value)
        }
        return nil
    }
}
