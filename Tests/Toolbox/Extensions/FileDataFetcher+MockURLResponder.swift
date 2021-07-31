import Foundation
import NetStack
import NetStackTestUtils


extension FileDataFetcher {
    
    enum MockDataURLResponder: MockURLResponding {
        typealias ResponseError = FileDataFetchingError
        
        static let responseData = "Response Data".data(using: .utf8)!
        
        static func respond(to request: URLRequest) async throws -> Data {
            responseData
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
