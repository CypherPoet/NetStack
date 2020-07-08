import Foundation


public struct NetworkResponse {
    public let request: URLRequest
    private let response: HTTPURLResponse
    public let body: Data?


    // MARK: - Init
    internal init(
        request: URLRequest,
        response: HTTPURLResponse,
        body: Data?
    ) {
        self.request = request
        self.response = response
        self.body = body
    }
}


// MARK: - Computeds
extension NetworkResponse {

    public var status: HTTPStatus {
        HTTPStatus(rawValue: response.statusCode)
    }

    public var message: String {
        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
    }

    public var headers: [AnyHashable: Any] { response.allHeaderFields }
}
