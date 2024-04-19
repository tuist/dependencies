import Foundation
import XCTest

@testable import Dependencies

final class ContextTests: XCTestCase {
    actor ProcessRunner {}
    
    func test_register() async {
        let dependencies = Dependencies()
        // let processRunner = ProcessRunner()
        // await context.register(processRunner)
        // let got = await context[ProcessRunner.self]
        
        // XCTAssertIdentical(got, processRunner)
    }
}
