import Foundation


public protocol SessionDataTaskPublishing: class {
    var session: URLSession { get }

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}


// MARK: - Default Implementation
extension SessionDataTaskPublishing {

    public var session: URLSession { .shared }

    public func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        session.dataTaskPublisher(for: request)
    }
}
