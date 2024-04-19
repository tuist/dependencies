import Foundation
import SwiftUI

// struct ContextKey<T>: Hashable {
//     let type: T.Type
    
//     init(_ type: T.Type) {
//         self.type = type
//     }
//     static func == (lhs: ContextKey, rhs: ContextKey) -> Bool {
//         return String(describing: lhs.type) == String(describing: rhs.type)
//     }
    
//     func hash(into hasher: inout Hasher) {
//         hasher.combine(String(describing: type))
//     }
// }

// actor Context {
//     private var dependencies: [ContextKey<Any>: Any] = [:]
    
//     public init() {}
  
//     public func register<V: Actor>(_ dependency: V) {
//         dependencies[ContextKey(V.self as! (any Any).Type)] = dependency
//     }
    
//     public subscript<V: Actor>(_ type: V.Type) -> V {
//         let value = dependencies[ContextKey(V.self as! (any Any).Type)]
//         if let castedValue = value as? V {
//             return castedValue
//         } else {
//             fatalError("Nooo")
//         }
//     }
// }
