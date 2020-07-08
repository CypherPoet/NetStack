import Foundation


public struct NetStackError: Error {

    /// The high-level classification of this error.
    public let code: Code

    /// The `URLRequest` that resulted in this error.
    public let request: URLRequest

    /// Any `NetworkResponse` (partial or otherwise) that we might have.
    public let response: NetworkResponse?

    /// Used to store more information about the responsible error.
    public let underlyingError: Error?
}


// MARK: - Identifiable
extension NetStackError: Identifiable {
    public var id: Int { code.rawValue }
}


// MARK: - Init from `HTTPURLResponse`
extension NetStackError.Code {

    init?(httpURLResponse: HTTPURLResponse) {
        switch httpURLResponse.statusCode {
        case 200 ..< 300:
            return nil
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorizedRequest
        case 402:
            self = .paymentRequired
        case 404:
            self = .notFound
        case 429:
            self = .tooManyRequests
        case 503:
            self = .serverIsBusy
        case 500 ..< 600:
            self = .severSideFailure
        default:
            self = .unknown
        }
    }
}
