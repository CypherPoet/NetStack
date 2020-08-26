import Foundation


public protocol SessionDataTaskPublishing: class {
    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}


extension URLSession: SessionDataTaskPublishing {}
