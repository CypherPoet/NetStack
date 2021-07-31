import Foundation


public protocol NetworkDataTransporting {
    var urlSession: URLSession { get }

    init(urlSession: URLSession)
    
    func perform(_ request: URLRequest) async throws -> NetworkResponse
}
