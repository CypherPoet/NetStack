import Foundation
import Combine


public protocol SessionDataTaskPublishing: class {
    typealias DataTaskResponse = URLSession.DataTaskPublisher.Output
    typealias DataTaskFailure = URLSession.DataTaskPublisher.Failure

    func response(for request: URLRequest) -> AnyPublisher<DataTaskResponse, DataTaskFailure>
}
