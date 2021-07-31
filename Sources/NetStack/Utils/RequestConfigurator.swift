import Foundation


public enum RequestConfigurator {
    public typealias HTTPHeaders = [HTTPHeaderField: String]

    public static func configure(
        _ request: inout URLRequest,
        withHeaders headers: HTTPHeaders = [:],
        method: HTTPMethod = .get,
        body: Data? = nil
    ) {
        for (headerField, value) in headers {
            request.setValue(value, forHTTPHeaderField: headerField.rawValue)
        }

        request.httpMethod = method.rawValue
        request.httpBody = body
    }
}
 


extension RequestConfigurator {

    /// Common sets of `HTTPHeaders`
    public enum DefaultHeaders {
        
        public static let postJSON: HTTPHeaders = [
            .accept: HTTPContentType.json.rawValue,
            .contentType: HTTPContentType.json.rawValue,
        ]
    }
}
