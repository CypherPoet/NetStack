import Foundation


public struct FileDataFetcher: FileDataFetching {
    public var urlSession: URLSession

    
    // MARK: - Init
    public init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }
    
    
    /// Performs a data task for a `URLRequest`, then attempts to the returned result into a
    /// ``FileResponse``.
    ///
    /// - Throws: ``FileDataFetchingError``
    public func perform(_ request: URLRequest) async throws -> FileResponse {
        do {
            let (data, urlResponse) = try await urlSession.data(for: request)
            
            return FileResponse(
                request: request,
                response: urlResponse,
                body: data
            )
        } catch let (urlError as URLError) {
            throw FileDataFetchingError.parse(from: urlError, returnedFor: request)
        }
    }
}
