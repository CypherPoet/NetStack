import Foundation


public struct FileResponse: NetworkResponding {
    public let request: URLRequest
    public let response: URLResponse
    public let body: Data


    // MARK: - Init
    public init(
        request: URLRequest,
        response: URLResponse,
        body: Data
    ) {
        self.request = request
        self.response = response
        self.body = body
    }
}



