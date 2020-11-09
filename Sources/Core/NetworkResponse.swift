import Foundation

public protocol NetworkResponding {
    associatedtype Response
    
    var request: URLRequest  { get }
    var response: Response { get }
    var body: Data?  { get }
}


public struct NetworkResponse: NetworkResponding {
    public let request: URLRequest
    public let response: HTTPURLResponse
    public let body: Data?


    // MARK: - Init
    public init(
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





public struct FileResponse: NetworkResponding {
    public let request: URLRequest
    public let response: URLResponse
    public let body: Data?


    // MARK: - Init
    public init(
        request: URLRequest,
        response: URLResponse,
        body: Data?
    ) {
        self.request = request
        self.response = response
        self.body = body
    }
}




//
//public struct NetworkResponse {
//    public let request: URLRequest
//    private let response: HTTPURLResponse
//    public let body: Data?
//
//
//    // MARK: - Init
//    public init(
//        request: URLRequest,
//        response: HTTPURLResponse,
//        body: Data?
//    ) {
//        self.request = request
//        self.response = response
//        self.body = body
//    }
//}
//
//
//// MARK: - Computeds
//extension NetworkResponse {
//
//    public var status: HTTPStatus {
//        HTTPStatus(rawValue: response.statusCode)
//    }
//
//    public var message: String {
//        HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
//    }
//
//    public var headers: [AnyHashable: Any] { response.allHeaderFields }
//}
