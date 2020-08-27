import Foundation
import Combine
@testable import NetStack



final class MockDataTasker {
    var responseData: Data
    var responseStatus: HTTPStatus

    init(
        responseData: Data = Data(),
        responseStatus: HTTPStatus = .ok
    ) {
        self.responseData = responseData
        self.responseStatus = responseStatus
    }
}


extension MockDataTasker: SessionDataTaskPublishing {

    func response(for request: URLRequest) -> AnyPublisher<DataTaskResponse, DataTaskFailure> {
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: responseStatus.rawValue,
            httpVersion: String(kCFHTTPVersion1_1),
            headerFields: [String : String]()
        )!

        let data = responseData


        return Just((data: data, response: response))
            .setFailureType(to: DataTaskFailure.self)
            .eraseToAnyPublisher()
    }
}
