import Foundation


public struct NetworkDataTransporter: NetworkDataTransporting {
    public var urlSession: URLSession

    
    // MARK: - Init
    public init(
        urlSession: URLSession = .shared
    ) {
        self.urlSession = urlSession
    }
    
    
    /// Performs a data task for a `URLRequest`, then attempts to the returned result into a
    /// ``NetworkResponse``.
    ///
    /// - Throws: ``NetworkError``
    public func perform(_ request: URLRequest) async throws -> NetworkResponse {
        do {
            let (responseData, urlResponse) = try await urlSession.data(for: request)
            
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
