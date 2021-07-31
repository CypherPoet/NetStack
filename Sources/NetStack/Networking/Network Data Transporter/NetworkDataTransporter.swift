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
            let (data, urlResponse) = try await urlSession.data(for: request)
            
            guard let httpURLResponse = urlResponse as? HTTPURLResponse else {
                throw NetworkError(
                    code: .invalidResponse,
                    request: request,
                    response: nil,
                    underlyingError: nil
                )
            }

            if let parsedError = NetworkError.parse(
                from: data,
                and: httpURLResponse,
                returnedFor: request
            ) {
                throw parsedError
            }
            
            return NetworkResponse(
                request: request,
                response: httpURLResponse,
                body: data
            )
        } catch (let urlError as URLError) {
            throw NetworkError.parse(from: urlError, returnedFor: request)
        }
    }
    
}
