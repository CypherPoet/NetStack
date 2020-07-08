import Foundation


public struct HTTPContentType {
    public let rawValue: String
}

extension HTTPContentType: Hashable {}


extension HTTPContentType {
    public static let json = HTTPContentType(rawValue: "application/json")
}


