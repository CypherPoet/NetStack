import Foundation


public struct HTTPContentType {
    public let rawValue: String

    // MARK: - Init
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HTTPContentType: Hashable {}


extension HTTPContentType {
    public static let json = HTTPContentType(rawValue: "application/json; charset=utf-8")
    public static let formURLEncoded = HTTPContentType(rawValue: "application/x-www-form-urlencoded; charset=utf-8")
}


