import Foundation


public struct DataUploader {
    public var urlSession: URLSession

    
    // MARK: - Init
    public init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }
}



extension DataUploader: DataUploading {
    
    /// Performs a task to upload `Data` to a `URL`,  then attempts to the return a  ``NetworkResponse``
    /// representing the completed operation.
    ///
    /// - Throws: ``NetworkError``
    public func upload(
        _ data: Data,
        to url: URL,
        usingMethod httpMethod: HTTPMethod = .post
    ) async throws -> NetworkResponse {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = httpMethod.rawValue
        
        return try await perform(upload: urlRequest, with: data)
    }
    
    
    public func perform(
        upload request: URLRequest,
        with data: Data
    ) async throws -> NetworkResponse {
        do {
            let (responseData, urlResponse) = try await urlSession.upload(
                for: request,
                from: data
            )

            if let parsedError = NetworkError.parse(
                from: responseData,
                and: urlResponse,
                returnedFor: request
            ) {
                throw parsedError
            }
            
            return NetworkResponse(
                request: request,
                response: urlResponse as! HTTPURLResponse,
                body: responseData
            )
        } catch (let urlError as URLError) {
            throw NetworkError.parse(from: urlError, returnedFor: request)
        }

    }
}
