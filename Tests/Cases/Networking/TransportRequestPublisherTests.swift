import XCTest
import Combine
@testable import NetStack


final class TransportRequestPublisherTests: XCTestCase {
    
    private enum TestData {
        static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")
        static let endpointURL = URL(string: "https://www.example.com")!
        static let mockDataTasker = MockDataTasker()
    }

    
    private var subscriptions = Set<AnyCancellable>()

    private var sut: TransportRequestPublisher!


    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT(
        subscriptionQueue: DispatchQueue = TestData.customSubscriptionQueue,
        dataTasker: SessionDataTaskPublishing = TestData.mockDataTasker
    ) -> TransportRequestPublisher {
        TransportRequestPublisher(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }


    func makeSUTFromDefaults() -> TransportRequestPublisher {
        TransportRequestPublisher()
    }


    func failOnCompletionWithNetworkError(completion: Subscribers.Completion<NetworkError>) {
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

    func test_PerformGETRequest_WhenSuccessful_PublishesNetworkResponse() {
        let request = URLRequest(url: TestData.endpointURL)
        let receivedResponse = expectation(description: "Received response after performing a successful request.")

        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithNetworkError,
                receiveValue: { response in
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)

        waitForExpectations(timeout: 1.0)
    }


    func test_PerformGETRequest_WhenSuccessful_PublishesNetworkResponseWithDataInBody() throws {
        let request = URLRequest(url: TestData.endpointURL)
        let receivedResponse = expectation(description: "Received response after performing a successful request")

        let response = "🦄"
        let responseData = Data(response.utf8)

        sut = makeSUT(dataTasker: MockDataTasker(responseData: responseData))

        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithNetworkError,
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

    func test_PerformGETRequest_WhenFailed_PublishesCompletionWithNetworkError() throws {
        let request = URLRequest(url: TestData.endpointURL)
        let receivedCompletionWithError = expectation(description: "Received completion with error after performing request.")

        sut = makeSUT(dataTasker: MockDataTasker(responseStatus: .badRequest))

        sut
            .perform(request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertEqual(error.code, .badRequest)
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

