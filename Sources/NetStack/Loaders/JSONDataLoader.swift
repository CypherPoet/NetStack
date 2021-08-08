import Foundation


public struct JSONDataLoader {
    public let urlSession: URLSession

    
    // MARK: - Init
    public init(
        urlSession: URLSession = URLSession.shared
    ) {
        self.urlSession = urlSession
    }
}


extension JSONDataLoader: JSONDataLoading {
    
    public func fetch(
        fromFileNamed fileName: String,
        in bundle: Bundle = .main
    ) async throws -> Data {
        guard let url = bundle.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            throw Error.fileNotFound(fileName: fileName)
        }
        
        do {
            let (data, _) = try await urlSession.data(from: url)
            
            return data
        } catch {
            throw Error.networkError(error)
        }
    }
}


extension JSONDataLoader {
    
    public enum Error: Swift.Error {
        case fileNotFound(fileName: String)
        case networkError(Swift.Error)
    }
}
