import Foundation


public struct HTTPStatus {
    public let rawValue: Int
}

extension HTTPStatus: Hashable {}


extension HTTPStatus {
    public static let created = HTTPStatus(rawValue: 201)
}
