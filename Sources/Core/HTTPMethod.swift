import Foundation


public struct HTTPMethod {
    public let rawValue: String

    // MARK: - Init
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HTTPMethod: Hashable {}


extension HTTPMethod {
    public static let get = HTTPMethod(rawValue: "GET")
    public static let post = HTTPMethod(rawValue: "POST")
    public static let put = HTTPMethod(rawValue: "PUT")
    public static let patch = HTTPMethod(rawValue: "PATCH")
    public static let delete = HTTPMethod(rawValue: "DELETE")
}
