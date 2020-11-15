import Foundation
import Combine


public enum JSONDataLoaderError: Error {
    case fileNotFound(fileName: String)
    case networkError(Error)
}


public enum JSONDataLoader {
    static let requestPublisher = FileRequestPublisher()
    
    
    public static func load(
        fromFileNamed fileName: String,
        in bundle: Bundle = .main
    ) -> AnyPublisher<Data, JSONDataLoaderError> {
        guard let url = bundle.url(
            forResource: fileName,
            withExtension: "json"
        ) else {
            return Fail(
                error: .fileNotFound(fileName: fileName)
            ).eraseToAnyPublisher()
        }
        
        return requestPublisher
            .perform(URLRequest(url: url))
            .compactMap(\.body)
            .mapError { networkError in
                .networkError(networkError)
            }
            .eraseToAnyPublisher()
    }
}


extension JSONDataLoader {
    
}
