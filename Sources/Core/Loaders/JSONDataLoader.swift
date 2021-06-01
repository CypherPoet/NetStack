import Foundation
import Combine


public enum JSONDataLoaderError: Error {
    case fileNotFound(fileName: String)
    case networkError(Error)
}


public struct JSONDataLoader {
    private let requestPublisher: FileRequestPublisher
    
    
    public init(
        subscriptionQueue: DispatchQueue = .global(),
        dataTasker: SessionDataTaskPublishing = URLSession.shared
    ) {
        self.requestPublisher = FileRequestPublisher(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }
    
    
    public func load(
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
            .mapError { error in
                .networkError(error)
            }
            .eraseToAnyPublisher()
    }
}

