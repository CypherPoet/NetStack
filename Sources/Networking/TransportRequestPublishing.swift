import Foundation
import Combine


public protocol TransportRequestPublishing: SessionDataTaskPublishing {

    var subscriptionQueue: DispatchQueue { get }


    /// Executes a data task for a request, then attempts to map data from the response.
    func perform(
        _ request: URLRequest,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<Data, NetStackError>
}



// MARK: - Default Implementation
extension TransportRequestPublishing {

    var subscriptionQueue: DispatchQueue { .global() }


    public func perform(
        _ request: URLRequest,
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<Data, NetStackError> {
        dataTaskPublisher(for: request)
            .subscribe(on: subscriptionQueue)
            .retry(allowedRetries)
            .mapError( { NetStackError.requestFailed(error: $0) })
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetStackError.missingResponse
                }

                if case .failure(let foundError) = NetStackError.parseFrom(data, and: httpResponse) {
                    throw foundError
                }

                return data
            }
            .mapError( { $0 as? NetStackError ?? .generic(error: $0) })
            .eraseToAnyPublisher()
    }
}
