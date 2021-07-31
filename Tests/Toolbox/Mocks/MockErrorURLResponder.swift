import Foundation
import NetStackTestUtils


public enum MockErrorURLResponder: MockURLResponding {
    public typealias ResponseError = URLError
    
    public static let errorResponse = URLError(.badServerResponse)
    
    public static func respond(to request: URLRequest) async throws -> Data {
        throw errorResponse
    }
}
