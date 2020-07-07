import Foundation


public struct Endpoint {
    public var host: String
    public var path: String
    public var scheme: String
    public var queryItems: [URLQueryItem]?
    

    public init(
        host: String,
        path: String,
        scheme: String = "https",
        queryItems: [URLQueryItem]? = nil
    ) {
        self.host = host
        self.path = path
        self.scheme = scheme
        self.queryItems = queryItems
    }
}


// MARK: - Computeds
extension Endpoint {
    
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.scheme = scheme
        urlComponents.queryItems = queryItems

        return urlComponents
    }


    public var url: URL? { urlComponents.url }
}
