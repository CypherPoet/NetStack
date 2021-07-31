import Foundation


public protocol FileDataFetching {
    var urlSession: URLSession { get }

    init(urlSession: URLSession)
    
    func perform(_ request: URLRequest) async throws -> FileResponse
}
