import Foundation
import NetStack
import NetStackTestUtils
import Combine


extension FileRequestPublisher {
    
    enum MockDataURLResponder: MockURLResponding {
        static let responseData = "Response Data".data(using: .utf8)!
        
        static func respond(to request: URLRequest) -> AnyPublisher<Data, Never> {
            Just(responseData)
                .eraseToAnyPublisher()
        }
    }
    
    enum MockErrorURLResponder: MockURLResponding {
        static let errorResponse = URLError(.badURL)
        
        static func respond(to request: URLRequest) -> AnyPublisher<Data, URLError> {
            Fail(error: errorResponse)
                .eraseToAnyPublisher()
        }
    }
}
