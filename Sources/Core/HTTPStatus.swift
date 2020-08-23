import Foundation


public struct HTTPStatus {
    public let rawValue: Int
}

extension HTTPStatus: Hashable {}


extension HTTPStatus {

    /// See: [100 Continue](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/100)
    public static let `continue` = HTTPStatus(rawValue: 100)

    /// See: [200 OK](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/200)
    public static let ok = HTTPStatus(rawValue: 200)

    /// See: [201 Created](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/201)
    public static let created = HTTPStatus(rawValue: 201)

    /// See: [301 Moved Permanently](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/301)
    public static let movedPermanently = HTTPStatus(rawValue: 301)

    /// See: [400 Bad Request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400)
    public static let badRequest = HTTPStatus(rawValue: 400)

    /// See: [404 Not Found](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404)
    public static let notFound = HTTPStatus(rawValue: 404)
}
