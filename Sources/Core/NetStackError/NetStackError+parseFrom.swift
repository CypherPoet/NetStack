import Foundation


extension NetStackError {
    
    public static func parse(
        from data: Data,
        and httpURLResponse: HTTPURLResponse,
        returnedFor request: URLRequest
    ) -> NetStackError?  {
        guard let errorCode = NetStackError.Code(httpURLResponse: httpURLResponse) else {
            return nil
        }

        let networkResponse = NetworkResponse(request: request, response: httpURLResponse, body: data)

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
    ) -> NetStackError {

        guard let code = NetStackError.Code(urlError: urlError) else {
            return NetStackError(
                code: .unknownFailureOnLaunch,
                request: request,
                response: nil,
                underlyingError: urlError
            )
        }

        return .init(
            code: code,
            request: request,
            response: nil,
            underlyingError: urlError
        )
    }
}
