import Foundation
import NetStack
import Combine


public protocol MockURLResponding {
    associatedtype ResponseError: Error
    
    static func respond(to request: URLRequest) -> AnyPublisher<Data, ResponseError>
}
