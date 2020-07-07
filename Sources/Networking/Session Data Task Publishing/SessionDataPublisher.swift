import Foundation


class SessionDataPublisher: SessionDataTaskPublishing {
    var session: URLSession


    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
}
