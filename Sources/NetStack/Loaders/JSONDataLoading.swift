import Foundation


public protocol JSONDataLoading {
    var urlSession: URLSession { get }
    
    init(urlSession: URLSession)
    
    func fetch(
        fromFileNamed fileName: String,
        in bundle: Bundle
    ) async throws -> Data
}
