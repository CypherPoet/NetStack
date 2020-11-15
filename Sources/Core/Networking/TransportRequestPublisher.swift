import Foundation
import Combine


public protocol TransportRequestPublishing {
    func perform(_ request: URLRequest) -> AnyPublisher<NetworkResponse, NetworkError>
}


public class TransportRequestPublisher: TransportRequestPublishing {
    public var subscriptionQueue: DispatchQueue
    public var dataTasker: SessionDataTaskPublishing


    public init(
        subscriptionQueue: DispatchQueue = .global(),
        dataTasker: SessionDataTaskPublishing = URLSession.shared
    ) {
        self.subscriptionQueue = subscriptionQueue
        self.dataTasker = dataTasker
    }


    /// Executes a data task for a request, then attempts to map data from
    /// the `DataTaskResponse` into a `NetworkResponse` response.
    public func perform(_ request: URLRequest) -> AnyPublisher<NetworkResponse, NetworkError> {
        dataTasker.response(for: request)
            .subscribe(on: subscriptionQueue)
            .mapError { urlError in
                NetworkError.parse(from: urlError, returnedFor: request)
            }
            .flatMap { (data: Data, response: URLResponse) -> AnyPublisher<NetworkResponse, NetworkError> in
                guard let httpURLResponse = response as? HTTPURLResponse else {
                    return Fail(error: NetworkError(
                        code: .invalidResponse,
                        request: request,
                        response: nil,
                        underlyingError: nil
                    ))
                    .eraseToAnyPublisher()
                }

                if let parsedError = NetworkError.parse(
                    from: data,
                    and: httpURLResponse,
                    returnedFor: request
                ) {
                    return Fail(error: parsedError)
                        .eraseToAnyPublisher()
                } else {
                    return Just(NetworkResponse(
                        request: request,
                        response: httpURLResponse,
                        body: data
                    ))
                    .setFailureType(to: NetworkError.self)
                    .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}

