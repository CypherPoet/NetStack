import Foundation
import Combine
@testable import NetStack



final class MockDataTasker: SessionDataTaskPublishing {
    var session: URLSession


    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }


    func dataTaskPublisher(for request: URLRequest) -> URLSession.DataTaskPublisher {
        URLSession.DataTaskPublisher(request: request, session: session)
    }
}
