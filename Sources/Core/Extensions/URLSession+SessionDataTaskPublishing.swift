import Foundation
import Combine


extension URLSession: SessionDataTaskPublishing {

    public func response(
        for request: URLRequest
    ) -> AnyPublisher<DataTaskResponse, DataTaskFailure> {
        dataTaskPublisher(for: request).eraseToAnyPublisher()
    }
}

