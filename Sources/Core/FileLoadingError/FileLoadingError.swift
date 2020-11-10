import Foundation


public struct FileLoadingError {

    /// The high-level classification of this error.
    public let code: Code

    /// The `URLRequest` that resulted in this error.
    public let request: URLRequest

    /// Any `FileResponse` (partial or otherwise) that we might have.
    public let response: FileResponse?

    /// Used to store more information about the responsible error.
    public let underlyingError: Error?


    public init(
        code: FileLoadingError.Code,
        request: URLRequest,
        response: FileResponse? = nil,
        underlyingError: Error? = nil
    ) {
        self.code = code
        self.request = request
        self.response = response
        self.underlyingError = underlyingError
    }
}

extension FileLoadingError: Error {}


// MARK: - Identifiable
extension FileLoadingError: Identifiable {
    public var id: Int { code.rawValue }
}
