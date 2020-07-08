import Foundation
import Combine


public protocol TransportRequestPublishing: SessionDataTaskPublishing {

    var subscriptionQueue: DispatchQueue { get }

    /// Executes a data task for a request, then attempts to map data from the response.
    func perform(
        _ request: URLRequest,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<NetworkResponse, NetStackError>
}


// MARK: - Default Implementation
extension TransportRequestPublishing {

    public var subscriptionQueue: DispatchQueue { .global() }

    public func perform(
        _ request: URLRequest,
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<NetworkResponse, NetStackError> {
        dataTaskPublisher(for: request)
            .retry(allowedRetries)
            .subscribe(on: subscriptionQueue)
            .mapError { error in
                NetStackError(
                    code: .requestFailedOnLaunch,
                    request: request,
                    response: nil,
                    underlyingError: error
                )
            }
            .tryMap { (data: Data, response: URLResponse) in
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    throw NetStackError(
                        code: .invalidResponse,
                        request: request,
                        response: nil,
                        underlyingError: nil
                    )
                }

                if let parsedError = NetStackError.parse(
                    from: data,
                    and: httpURLResponse,
                    returnedFor: request
                ) {
                    throw parsedError
                } else {
                    return NetworkResponse(request: request, response: httpURLResponse, body: data)
                }
            }
            .mapError { error in
                if let netStackError = error as? NetStackError {
                    return netStackError
                } else {
                    return NetStackError(code: .unknown, request: request, response: nil, underlyingError: error)
                }
            }
            .eraseToAnyPublisher()
    }
}
