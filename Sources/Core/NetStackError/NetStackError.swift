import Foundation


public struct NetStackError {
    /// The high-level classification of this error.
    public let code: Code

    /// The `URLRequest` that resulted in this error.
    public let request: URLRequest

    /// Any `NetworkResponse` (partial or otherwise) that we might have.
    public let response: NetworkResponse?

    /// Used to store more information about the responsible error.
    public let underlyingError: Error?
}

extension NetStackError: Error {}


// MARK: - Identifiable
extension NetStackError: Identifiable {
    public var id: Int { code.rawValue }
}
