import Foundation


extension NetworkError {
    
    public static func parse(
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

        return .init(
            code: errorCode,
            request: request,
            response: networkResponse,
            underlyingError: nil
        )
    }


    public static func parse(
        from urlError: URLError,
        returnedFor request: URLRequest
    ) -> NetworkError {
        .init(
            code: NetworkError.Code(urlError: urlError),
            request: request,
            response: nil,
            underlyingError: urlError
        )
    }
}
