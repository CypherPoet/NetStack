import Foundation
import Combine


public protocol TransportRequestPublishing {
    func perform(_ request: URLRequest) -> AnyPublisher<NetworkResponse, NetStackError>
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
    public func perform(_ request: URLRequest) -> AnyPublisher<NetworkResponse, NetStackError> {
        dataTasker.response(for: request)
            .subscribe(on: subscriptionQueue)
            .mapError {
                NetStackError.parse(from: $0, returnedFor: request)
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
                    return NetworkResponse(
                        request: request,
                        response: httpURLResponse,
                        body: data
                    )
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

