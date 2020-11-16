import Foundation
import NetStack
import NetStackTestUtils
import Combine


extension JSONDataLoader {
    
    enum MockDataURLResponder: MockURLResponding {
        static let responseData = "Response Data".data(using: .utf8)!
        
        static func respond(to request: URLRequest) -> AnyPublisher<Data, Never> {
            Just(responseData)
                .eraseToAnyPublisher()
        }
    }
}
