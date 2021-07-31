import Foundation


extension FileDataFetchingError {
    
    public static func parse(
        from urlError: URLError,
        returnedFor request: URLRequest
    ) -> FileDataFetchingError {
        .init(
            code: FileDataFetchingError.Code(urlError: urlError),
            request: request,
            response: nil,
            underlyingError: urlError
        )
    }
}
