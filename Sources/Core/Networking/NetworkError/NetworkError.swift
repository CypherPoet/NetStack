import Foundation


public struct NetworkError {

    /// The high-level classification of this error.
    public let code: Code

    /// The `URLRequest` that resulted in this error.
    public let request: URLRequest

    /// Any `NetworkResponse` (partial or otherwise) that we might have.
    public let response: NetworkResponse?

    /// Used to store more information about the responsible error.
    public let underlyingError: Error?


    public init(
        code: NetworkError.Code,
        request: URLRequest,
        response: NetworkResponse? = nil,
        underlyingError: Error? = nil
    ) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
}

extension NetworkError: Error {}


// MARK: - Identifiable
extension NetworkError: Identifiable {
    public var id: Int { code.rawValue }
}

// MARK: - Equatable
extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        lhs.code == rhs.code
    }
}
