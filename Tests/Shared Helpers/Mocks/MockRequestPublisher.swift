import Foundation
import Combine
@testable import NetStack


final class MockRequestPublisher: TransportRequestPublishing {
    var subscriptionQueue: DispatchQueue
    var dataTasker: SessionDataTaskPublishing
    var responseData: Data?
    var responseStatus: HTTPStatus

    var error: NetStackError?


    init(
        subscriptionQueue: DispatchQueue = .init(
            label: "Mock Request Publisher Subscription Queue",
            qos: .unspecified, attributes: []
        ),
        dataTasker: SessionDataTaskPublishing = URLSession.shared,
        responseData: Data? = nil,
        responseStatus: HTTPStatus = .ok,
        responseError: NetStackError? = nil
    ) {
        self.subscriptionQueue = subscriptionQueue
        self.dataTasker = dataTasker
        self.responseData = responseData
        self.responseStatus = responseStatus
        self.error = responseError
    }


    func perform(
        _ request: URLRequest,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<NetworkResponse, NetStackError> {
        if let error = error {
            return Fail(error: error).eraseToAnyPublisher()
        } else {
            let response = makeResponse(for: request)

            return Just(response)
                .setFailureType(to: NetStackError.self)
                .eraseToAnyPublisher()
        }
    }


    func makeResponse(for request: URLRequest) -> NetworkResponse {
        NetworkResponse(
            request: request,
            response: HTTPURLResponse(
                url: request.url!,
                statusCode: responseStatus.rawValue,
                httpVersion: String(kCFHTTPVersion1_1),
                headerFields: [String : String]()
            )!,
            body: responseData
        )
    }
}
