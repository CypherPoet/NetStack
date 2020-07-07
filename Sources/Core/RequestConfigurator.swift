import Foundation


public typealias HTTPHeaders = [String: String]


public enum RequestConfigurator {
    
    public static func configure(
        headers: HTTPHeaders,
        for request: inout URLRequest
    ) {
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
 
