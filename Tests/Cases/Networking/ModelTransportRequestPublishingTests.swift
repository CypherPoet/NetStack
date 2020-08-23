import XCTest
import Combine
@testable import NetStack


private final class PlayerModelTransport: ModelTransportRequestPublishing {
//    var subscriptionQueue: DispatchQueue
//    var session: URLSession
//
//    init(
//        session: URLSession = .shared
//    ) {
//        self.session = session
//    }
}

private final class PlayerModelTransportWithInit: ModelTransportRequestPublishing {
    var session: URLSession
    var subscriptionQueue: DispatchQueue


    internal init(
        session: URLSession = .shared,
        subscriptionQueue: DispatchQueue = .init(label: "Custom Subscription Queue", qos: .unspecified, attributes: [])
    ) {
        self.session = session
        self.subscriptionQueue = subscriptionQueue
    }
}


private enum TestData {
    static let player = Player(name: "Gandalf", xp: 100.32, level: 10)
    static let playerEndpoint = Endpoint(host: "reqres.in", path: "/api/players")
    static let endpointURL = playerEndpoint.url!
}


final class ModelTransportRequestPublishingTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    private var sut: ModelTransportRequestPublishing!


    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = PlayerModelTransport()
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func handleCompletionWithNetStackError(completion: Subscribers.Completion<NetStackError>) {
        switch completion {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .finished:
            break
        }
    }
}


// MARK: - Core Functionality
extension ModelTransportRequestPublishingTests {

    func test_encodeDataForModel_createsEncodedData() {
        let player = TestData.player
        let dataWasEncoded = expectation(description: "Model data was encoded")

        sut.encode(dataFor: player)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    case .finished:
                        break
                    }
                },
                receiveValue: { _ in
                    dataWasEncoded.fulfill()
                }
            )
            .store(in: &subscriptions)

            waitForExpectations(timeout: 1.0)
    }


    func test_encodeDataForModelIntoBodyOfRequest_encodesDataAndSetsItOnARequestBody() {
        let player = TestData.player
        let requestWasConfigured = expectation(description: "Model data was encoded and set on request body")

        let request = URLRequest(url: TestData.endpointURL)

        sut.encode(dataFor: player, intoBodyOf: request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTFail(error.localizedDescription)
                    case .finished:
                        break
                    }
                },
                receiveValue: { request in
                    let body = try! XCTUnwrap(request.httpBody)

                    XCTAssertFalse(body.isEmpty)
                    requestWasConfigured.fulfill()
                }
            )
            .store(in: &subscriptions)

            waitForExpectations(timeout: 1.0)
    }


    func test_sendEncodedDataForModelInBodyOfRequest_encodesDataAndPerformsAPost() {
        let postSucceeded = expectation(description: "Post of data payload should succeed")
        let player = TestData.player

        var request = URLRequest(url: TestData.endpointURL)

        RequestConfigurator.configure(
            &request,
            withHeaders: RequestConfigurator.DefaultHeaders.postJSON,
            method: .post
        )

        sut.send(
            dataFor: player,
            inBodyOf: request
        )
        .sink(
            receiveCompletion: handleCompletionWithNetStackError,
            receiveValue: { savedPlayer in
                XCTAssertEqual(savedPlayer.name, player.name)
                postSucceeded.fulfill()
            }
        )
        .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }
}

