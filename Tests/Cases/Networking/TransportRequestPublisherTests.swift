import XCTest
import Combine
@testable import NetStack


private enum TestData {
    static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")
    static let successRequestEndpoint = Endpoint(host: "reqres.in", path: "/api/unknown")
    static let notFoundRequestEndpoint = Endpoint(host: "reqres.in", path: "/api/unknown/23")
    static let badURL = URL(string: "nope")!

    static let mockDataTasker = MockDataTasker()
}


final class TransportRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    private var sut: TransportRequestPublisher!


    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = makeSUT(
            subscriptionQueue: TestData.customSubscriptionQueue,
            dataTasker: TestData.mockDataTasker
        )
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT(
        subscriptionQueue: DispatchQueue,
        dataTasker: SessionDataTaskPublishing
    ) -> TransportRequestPublisher {
        .init(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }


    func makeSUTFromDefaults() -> TransportRequestPublisher {
        .init()
    }


    func failOnCompletionWithNetStackError(completion: Subscribers.Completion<NetStackError>) {
        switch completion {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .finished:
            break
        }
    }
}


// MARK: - Init
extension TransportRequestPublisherTests {

    func test_WhenCreated_WithDefaults_SetsSubscriptionQueueToGlobalQueue() {
        sut = makeSUTFromDefaults()

        let expected = DispatchQueue.global()
        let actual = sut.subscriptionQueue

        XCTAssertEqual(actual, expected)
    }


    func test_WhenCreated_WithDefaults_SetsDataTaskerToSharedURLSession() {
        sut = makeSUTFromDefaults()

        let expected = URLSession.shared as SessionDataTaskPublishing
        let actual = sut.dataTasker

        XCTAssertTrue(actual === expected)
    }


    func test_WhenCreated_WithSubscriptionQueue_SetsSubscriptionQueue() {
        let expected = TestData.customSubscriptionQueue
        let actual = sut.subscriptionQueue

        XCTAssertEqual(actual, expected)
    }


    func test_WhenCreated_WithDataTasker_SetsDataTasker() {
        let expected = TestData.mockDataTasker
        let actual = sut.dataTasker

        XCTAssertTrue(actual === expected)
    }
}


// MARK: - Performing Successful Requests
extension TransportRequestPublisherTests {

    func test_Perform_GivenSuccess_PublishesNetworkResponse() {
        let request = URLRequest(url: TestData.successRequestEndpoint.url!)
        let receivedResponse = expectation(description: "Received response after performing a successful request.")

        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithNetStackError,
                receiveValue: { response in
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }


    func test_Perform_GivenSuccessfulGETForData_PublishesNetworkResponseWithBody() throws {
        let request = URLRequest(url: TestData.successRequestEndpoint.url!)
        let receivedResponse = expectation(description: "Received response after performing a successful request")

        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithNetStackError,
                receiveValue: { response in
                    XCTAssertNotNil(response.body)
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }
}


// MARK: - Error Handling
extension TransportRequestPublisherTests {

    func test_Perform_GivenFailingGETForData_PublishesNetworkResponseWithBody() throws {
        let request = URLRequest(url: TestData.badURL)
        let receivedCompletionWithError = expectation(description: "Received completion with error after performing request.")

        sut
            .perform(request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertEqual(error.code, .badURL)
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

