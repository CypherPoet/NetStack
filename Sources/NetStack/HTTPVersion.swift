import Foundation


/**
 * Convenience type to interface with `CoreFoundation`s' HTTP version
 * keys and their corresponding `CFString` values
 */
public struct HTTPVersion {
    public let rawValue: String

    // MARK: - Init
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension HTTPVersion: Hashable {}


extension HTTPVersion {
    public static let V1_0 = HTTPVersion(rawValue: String(kCFHTTPVersion1_0))
    public static let V1_1 = HTTPVersion(rawValue: String(kCFHTTPVersion1_1))
    public static let V2_0 = HTTPVersion(rawValue: String(kCFHTTPVersion2_0))
    public static let V3_0 = HTTPVersion(rawValue: String(kCFHTTPVersion3_0))
}
