import XCTest
import Combine
@testable import NetStack


private struct Player: Codable {
    var name: String
    var xp: Double
    var level: Int
}



private final class PlayerModelTransport: ModelTransportRequestPublishing {
    var session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
}


final class ModelTransportRequestPublishingTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()


    private enum TestData {
        static let player = Player(name: "Gandalf", xp: 100.32, level: 10)
        static let playerEndpoint = Endpoint(host: "reqres.in", path: "/api/players")
        static let endpointURL = playerEndpoint.url!
    }


    func testPostingNewPlayer() {
        let expectation = self.expectation(description: "Post of data payload should succeed")
        let transportClient = PlayerModelTransport()
        let player = TestData.player

        var request = URLRequest(url: TestData.endpointURL)

        request.httpMethod = HTTPMethod.post.rawValue

        RequestConfigurator.configure(
            headers: [
                HTTPHeaderField.accept: HTTPContentType.json,
                HTTPHeaderField.contentType: HTTPContentType.json,
            ],
            for: &request
        )

        transportClient.encode(
            dataFor: player,
            sendingInBodyOf: request
        )
        .sink(
            receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTFail(error.errorDescription ?? "")
                case .finished:
                    break
                }
            },
            receiveValue: { savedPlayer in
                XCTAssertEqual(savedPlayer.name, player.name)
                expectation.fulfill()
            }
        )
        .store(in: &subscriptions)

        waitForExpectations(timeout: 2.0)
    }
}

