import Foundation
import Combine


public protocol FileRequestPublishing {
    func perform(_ request: URLRequest) -> AnyPublisher<FileResponse, FileLoadingError>
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
    /// the `DataTaskResponse` into a `FileResponse` response.
    public func perform(_ request: URLRequest) -> AnyPublisher<FileResponse, FileLoadingError> {
        dataTasker.response(for: request)
            .subscribe(on: subscriptionQueue)
            .mapError { urlError in
                FileLoadingError.parse(from: urlError, returnedFor: request)
            }
            .map { (data: Data, response: URLResponse) in
                FileResponse(
                    request: request,
                    response: response,
                    body: data
                )
            }
            .eraseToAnyPublisher()
    }
}
