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
}
