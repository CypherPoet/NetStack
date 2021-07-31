import Foundation
import NetStack


public protocol MockURLResponding {
    associatedtype ResponseError: Error
    
    static func respond(to request: URLRequest) async throws -> Data
}


