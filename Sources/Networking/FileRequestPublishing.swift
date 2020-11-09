import Foundation
import Combine


public protocol FileRequestPublishing {
    func perform(_ request: URLRequest) -> AnyPublisher<FileResponse, NetworkError>
}


public class FileRequestPublisher: FileRequestPublishing {
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
    public func perform(_ request: URLRequest) -> AnyPublisher<FileResponse, NetworkError> {
        dataTasker.response(for: request)
            .subscribe(on: subscriptionQueue)
            .mapError {
                NetworkError.parse(from: $0, returnedFor: request)
            }
            .tryMap { (data: Data, response: URLResponse) in
                return FileResponse(
                    request: request,
                    response: response,
                    body: data
                )
            }
            // TODO: Create and use a `FileError` here
            .mapError { error in
                if let network = error as? NetworkError {
                    return network
                } else {
                    return NetworkError(
                        code: .unknown,
                        request: request,
                        response: nil,
                        underlyingError: error
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}


