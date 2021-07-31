import Foundation
import NetStack
import NetStackTestUtils


extension JSONDataLoader {
    
    enum MockDataURLResponder: MockURLResponding {
        typealias ResponseError = Never
        
        static let responseData = "Response Data".data(using: .utf8)!

        static func respond(to request: URLRequest) async throws -> Data {
            responseData
        }
    }
}
