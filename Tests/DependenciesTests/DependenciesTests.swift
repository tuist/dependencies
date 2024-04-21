import Foundation
import XCTest

@testable import Dependencies

final class ContextTests: XCTestCase {
    func test_register_throwsAnError_when_theSameDependencyIsRegisteredMoreThanOnce() async throws {
        // Given
        let dependencies = Dependencies()
        try await dependencies.register(.single) { _ in StructA()}
        
        // When
        var thrownError: DependenciesError?
        do {
            try await dependencies.register(.single) { _ in StructA() }
        } catch {
            thrownError = error as? DependenciesError
        }
        
        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError?.description, "The dependency StructA has already been registered")
    }
    
    func test_register_throwsAnError_when_aCircularDependencyIsDetected() async throws {
        // Given
        let dependencies = Dependencies()
        try await dependencies.register(.single) { resolver in
            return CircularA(b: try await resolver.resolve(CircularB.self))
        }
        try await dependencies.register(.single) { resolver in
            return CircularB(a: try await resolver.resolve(CircularA.self))
        }
        
        // When
        var thrownError: DependenciesError?
        do {
            _ = try await dependencies.dependency(CircularA.self)
        } catch {
            thrownError = error as? DependenciesError
        }
        
        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError?.description, "We found a circular dependency: CircularB > CircularA > CircularB")
    }
    
    func test_dependency_throwsAnError_when_aDependencyIsNotRegistered() async throws {
        // Given
        let dependencies = Dependencies()
        
        // When
        var thrownError: DependenciesError?
        do {
            _ = try await dependencies.dependency(ClassA.self)
        } catch {
            thrownError = error as? DependenciesError
        }
        
        // Then
        XCTAssertNotNil(thrownError)
        XCTAssertEqual(thrownError?.description, "The dependency ClassA is not registered")
    }
    
    func test_dependency_returnsTheSameInstance_whenSingle() async throws {
        // Given
        let dependencies = Dependencies()
        try await dependencies.register(.single) { _ in ClassA()}
        
        // When
        let first = try await dependencies.dependency(ClassA.self)
        let second = try await dependencies.dependency(ClassA.self)

        // Then
        XCTAssertIdentical(first, second)
    }
    
    func test_dependency_returnsMultipleInstances_whenMulti() async throws {
        // Given
        let dependencies = Dependencies()
        try await dependencies.register(.multi) { _ in ClassA()}
        
        // When
        let first = try await dependencies.dependency(ClassA.self)
        let second = try await dependencies.dependency(ClassA.self)

        // Then
        XCTAssertNotIdentical(first, second)
    }
}


private struct StructA {}

private struct StructB {
    let a: StructA
}

private struct StructC {
    let a: StructA
    let b: StructB
}

private class CircularA {
    var b: CircularB
    init(b: CircularB) {
        self.b = b
    }
}

private class CircularB {
    var a: CircularA
    init(a: CircularA) {
        self.a = a
    }
}

private class ClassA {}
