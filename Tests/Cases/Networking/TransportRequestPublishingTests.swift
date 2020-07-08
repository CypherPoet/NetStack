import XCTest
import Combine
@testable import NetStack


private final class BareMockRequestPublisher: TransportRequestPublishing {}


private final class CustomizedMockRequestPublisher: TransportRequestPublishing {
    var subscriptionQueue: DispatchQueue

    init(subscriptionQueue: DispatchQueue) {
        self.subscriptionQueue = subscriptionQueue
    }
}


private enum TestData {
    static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")
    static let successRequestEndpoint = Endpoint(host: "reqres.in", path: "/api/unknown")
    static let notFoundRequestEndpoint = Endpoint(host: "reqres.in", path: "/api/unknown/23")
}


final class TransportRequestPublishingTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    private var sut: TransportRequestPublishing!


    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = BareMockRequestPublisher()
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func makeCustomizedRequestPublisher(
        subscriptionQueue: DispatchQueue
    ) -> TransportRequestPublishing {
        CustomizedMockRequestPublisher(subscriptionQueue: subscriptionQueue)
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


// MARK: - Init
extension TransportRequestPublishingTests {

    func testBareRequestPublisher_whenCreated_setsDefaultSubscriptionQueue() {
        let expected = DispatchQueue.global()
        let actual = sut.subscriptionQueue

        XCTAssertEqual(actual, expected)
    }

    func testCustomizedRequestPublisher_whenCreated_setsCustomSubscriptionQueue() {
        let expectedQueue = TestData.customSubscriptionQueue

        sut = makeCustomizedRequestPublisher(
            subscriptionQueue: expectedQueue
        )

        XCTAssertEqual(sut.subscriptionQueue, expectedQueue)
    }
}


// MARK: - Performing Requests
extension TransportRequestPublishingTests {

    func testRequestPublisher_perform_givenSuccess_publishesNetworkResponse() {
        let request = URLRequest(url: TestData.successRequestEndpoint.url!)
        let receivedResponse = expectation(description: "Received response after performing request")

        sut.perform(request)
            .sink(
                receiveCompletion: handleCompletionWithNetStackError,
                receiveValue: { response in
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }


    func testRequestPublisher_perform_givenSuccessfulGETForData_publishesNetworkResponseWithBody() throws {
        let request = URLRequest(url: TestData.successRequestEndpoint.url!)
        let receivedResponse = expectation(description: "Received response after performing request")

        sut.perform(request)
            .sink(
                receiveCompletion: handleCompletionWithNetStackError,
                receiveValue: { response in
                    XCTAssertNotNil(response.body)
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }


    func testRequestPublisher_perform_givenFailingGETForData_publishesNetworkResponseWithBody() throws {
        let request = URLRequest(url: TestData.notFoundRequestEndpoint.url!)
        let receivedCompletionWithError = expectation(description: "Received completion with error after performing request")

        sut.perform(request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertEqual(error.code, .notFound)
                        receivedCompletionWithError.fulfill()
                    case .finished:
                        break
                    }
                },
                receiveValue: { value in
                    XCTFail("Unexpected value received: \(value)")
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }
}

