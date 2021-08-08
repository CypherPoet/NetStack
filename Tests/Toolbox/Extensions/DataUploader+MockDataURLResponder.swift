import Foundation
import NetStack
import NetStackTestUtils


extension ModelTransporter {
    
    enum MockDataURLResponder: MockURLResponding {
        typealias ResponseError = Error
        
        static let responseModel = TestConstants.SampleModels.player
        
        static func respond(to request: URLRequest) async throws -> Data {
            return try JSONEncoder().encode(responseModel)
        }
    }
    
    
    enum MockErrorURLResponder: MockURLResponding {
        typealias ResponseError = URLError
        
        static let errorResponse = URLError(.badURL)
        
        static func respond(to request: URLRequest) async throws -> Data {
            throw errorResponse
        }
    }
}
