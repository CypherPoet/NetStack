import XCTest
import Combine
@testable import NetStack


private enum TestData {
    static let player = Player(name: "Gandalf", xp: 100.32, level: 10)
    static let endpointURL = URL(string: "https://www.example.com")!
}


final class ModelTransportRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    private var sut: ModelTransportRequestPublisher!


    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = makeSUT(
            requestPublisher: MockRequestPublisher()
        )
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT(
        requestPublisher: TransportRequestPublishing
    ) -> ModelTransportRequestPublisher {
        .init(requestPublisher: requestPublisher)
    }


    func makeSUTFromDefaults() -> ModelTransportRequestPublisher {
        .init()
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
extension ModelTransportRequestPublisherTests {

    func test_EncodeDataForModel_CreatesEncodedData() {
        let player = TestData.player
        let dataWasEncoded = expectation(description: "Model data was encoded")

        sut
            .encode(dataFor: player)
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


    func test_EncodeDataForModelIntoBodyOfRequest_EncodesDataAndSetsItOnARequestBody() {
        let player = TestData.player
        let requestWasConfigured = expectation(description: "Model data was encoded and set on request body")

        let request = URLRequest(url: TestData.endpointURL)

        sut
            .encode(dataFor: player, intoBodyOf: request)
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


    func test_SendEncodedDataForModelInBodyOfRequest_EncodesDataAndPerformsAPost() throws {
        let postSucceeded = expectation(description: "Post of data payload should succeed.")
        let player = TestData.player
        let playerResponseData = try JSONEncoder().encode(player)

        var request = URLRequest(url: TestData.endpointURL)

        RequestConfigurator.configure(
            &request,
            withHeaders: RequestConfigurator.DefaultHeaders.postJSON,
            method: .post
        )

        let mockRequestPublisher = MockRequestPublisher(
            responseData: playerResponseData,
            responseStatus: HTTPStatus.created
        )

        sut = makeSUT(requestPublisher: mockRequestPublisher)
        sut
            .send(
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
