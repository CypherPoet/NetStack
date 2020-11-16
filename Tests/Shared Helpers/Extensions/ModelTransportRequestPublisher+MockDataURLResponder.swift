import Foundation
import NetStack
import NetStackTestUtils
import Combine


extension ModelTransportRequestPublisher {
    
    enum MockDataURLResponder: MockURLResponding {
        static let responseModel = TestConstants.SampleModels.player
        
        static func respond(to request: URLRequest) -> AnyPublisher<Data, Error> {
            Just(responseModel)
                .encode(encoder: JSONEncoder())
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
