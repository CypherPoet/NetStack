import Foundation


public struct HTTPContentType {
    public let rawValue: String
}

extension HTTPContentType: Hashable {}


extension HTTPContentType {
    public static let json = HTTPContentType(rawValue: "application/json; charset=utf-8")
    public static let formURLEncoded = HTTPContentType(rawValue: "application/x-www-form-urlencoded; charset=utf-8")
}


