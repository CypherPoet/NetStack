import Foundation


public struct HTTPHeaderField {
    public let rawValue: String
}

extension HTTPHeaderField: Hashable {}


extension HTTPHeaderField {
    public static let accept = HTTPHeaderField(rawValue: "Accept")
    public static let contentType = HTTPHeaderField(rawValue: "Content-Type")
    public static let cacheControl = HTTPHeaderField(rawValue: "Cache-Control")
}
