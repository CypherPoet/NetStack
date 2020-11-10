import Foundation


extension FileLoadingError {
    
    public static func parse(
        from urlError: URLError,
        returnedFor request: URLRequest
    ) -> FileLoadingError {
        .init(
            code: FileLoadingError.Code(urlError: urlError),
            request: request,
            response: nil,
            underlyingError: urlError
        )
    }
}
