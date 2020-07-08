import Foundation


public enum RequestConfigurator {
    public typealias HTTPHeaders = [HTTPHeaderField: String]
    
    public static func configure(
        headers: HTTPHeaders = [:],
        method: HTTPMethod = .get,
        for request: inout URLRequest
    ) {
        for (headerField, value) in headers {
            request.setValue(value, forHTTPHeaderField: headerField.rawValue)
        }

        request.httpMethod = method.rawValue
    }
}
 
