import Foundation


public protocol DataUploading {
    var urlSession: URLSession { get }
    
    
    init(urlSession: URLSession)
    
    
    func upload(
        _ data: Data,
        to url: URL,
        usingMethod httpMethod: HTTPMethod
    ) async throws -> NetworkResponse
    
    
    func perform(
        upload request: URLRequest,
        with data: Data
    ) async throws -> NetworkResponse
}

