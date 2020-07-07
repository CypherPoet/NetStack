import Foundation


public protocol SessionDataTaskPublishing: class {
    var session: URLSession { get }

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher
}


// MARK: - Default Implementation
extension SessionDataTaskPublishing {

    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        session.dataTaskPublisher(for: request)
    }
}
