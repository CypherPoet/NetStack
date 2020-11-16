import XCTest
import Combine
@testable import NetStack


final class TransportRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    typealias MockDataURLResponder = TransportRequestPublisher.MockDataURLResponder
    typealias MockErrorURLResponder = TransportRequestPublisher.MockErrorURLResponder

    
    private var dataTasker: SessionDataTaskPublishing!
    private var sut: TransportRequestPublisher!


    override func setUpWithError() throws {
        try super.setUpWithError()

        dataTasker = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        dataTasker = nil
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT(
        subscriptionQueue: DispatchQueue = TestConstants.customSubscriptionQueue
    ) -> TransportRequestPublisher {
        .init(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }


    func makeSUTFromDefaults() -> TransportRequestPublisher {
        .init()
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
        let expected = TestConstants.customSubscriptionQueue
        let actual = sut.subscriptionQueue

        XCTAssertEqual(actual, expected)
    }


    func test_WhenCreated_WithDataTasker_SetsDataTasker() {
        dataTasker = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
        
        let expected = dataTasker
        let actual = sut.dataTasker

        XCTAssertTrue(actual === expected)
    }
}


// MARK: - Performing Successful Requests
extension TransportRequestPublisherTests {

    func test_PerformGETRequest_WhenSuccessful_PublishesNetworkResponse() {
        let request = URLRequest(url: TestConstants.EndpointURLs.example)
        let publisher = sut.perform(request)
        
        XCTAssertNoThrow(try awaitCompletion(of: publisher))
    }
}


// MARK: - Error Handling
extension TransportRequestPublisherTests {

    func test_PerformGETRequest_WhenFailed_PublishesCompletionWithNetworkError() throws {
        dataTasker = URLSession(mockResponder: MockErrorURLResponder.self)
        sut = makeSUT()

        let request = URLRequest(url: TestConstants.EndpointURLs.example)
        let publisher = sut.perform(request)
        
        XCTAssertThrowsError(try awaitCompletion(of: publisher)) { (error) in
            let error = try! XCTUnwrap(error as? NetworkError)
            
            switch error.code {
            case .badURL:
                break
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
    }
}

