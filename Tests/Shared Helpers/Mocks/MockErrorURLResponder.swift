import Foundation
import NetStackTestUtils
import Combine


public enum MockErrorURLResponder: MockURLResponding {
    public static let errorResponse = URLError(.badServerResponse)
    
    public static func respond(to request: URLRequest) -> AnyPublisher<Data, URLError> {
        Fail(error: errorResponse)
            .eraseToAnyPublisher()
    }
}
