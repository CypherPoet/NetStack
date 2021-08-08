import Foundation


// MARK: -  Public Methods
extension NetworkError {
    
    public static func parse(
        from data: Data,
        and urlResponse: URLResponse,
        returnedFor request: URLRequest
    ) -> NetworkError?  {
        guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
            return NetworkError(
                code: .invalidResponse,
                request: request,
                response: nil,
                underlyingError: nil
            )
        }
        
        return parse(from: data, and: httpURLResponse, returnedFor: request)
    }
    
    
    public static func parse(
        from urlError: URLError,
        returnedFor request: URLRequest
    ) -> NetworkError {
        NetworkError(
            code: NetworkError.Code(urlError: urlError),
            request: request,
            response: nil,
            underlyingError: urlError
        )
    }
}


// MARK: -  Private Helpers
extension NetworkError {
    
    private static func parse(
        from data: Data,
        and httpURLResponse: HTTPURLResponse,
        returnedFor request: URLRequest
    ) -> NetworkError?  {
        guard let errorCode = NetworkError.Code(httpURLResponse: httpURLResponse) else {
            return nil
        }

        let networkResponse = NetworkResponse(
            request: request,
            response: httpURLResponse,
            body: data
        )

        return NetworkError(
            code: errorCode,
            request: request,
            response: networkResponse,
            underlyingError: nil
        )
    }
}
