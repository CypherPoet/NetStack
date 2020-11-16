import XCTest
import Combine
@testable import NetStack


final class FileRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    typealias MockDataURLResponder = FileRequestPublisher.MockDataURLResponder
    typealias MockErrorURLResponder = FileRequestPublisher.MockErrorURLResponder
    
    private var sut: FileRequestPublisher!
    private var bundle: Bundle!
    private var dataTasker: SessionDataTaskPublishing!

    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        bundle = Bundle.module
        dataTasker = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        sut = nil
        bundle = nil
        dataTasker = nil
        
        try super.tearDownWithError()
    }
    
    
    func makeSUT(
        subscriptionQueue: DispatchQueue = TestConstants.customSubscriptionQueue
    ) -> FileRequestPublisher {
        .init(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }
    
    
    func makeSUTFromDefaults() -> FileRequestPublisher {
        .init()
    }
}


// MARK: - Init
extension FileRequestPublisherTests {
    
    func test_Creation_WithDefaults_SetsSubscriptionQueueToGlobalQueue() {
        sut = makeSUTFromDefaults()
        
        let expected = DispatchQueue.global()
        let actual = sut.subscriptionQueue
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_Creation_WithDefaults_SetsDataTaskerToSharedURLSession() {
        sut = makeSUTFromDefaults()
        
        let expected = URLSession.shared as SessionDataTaskPublishing
        let actual = sut.dataTasker
        
        XCTAssertTrue(actual === expected)
    }
    
    
    func test_Creation_WithSubscriptionQueue_SetsSubscriptionQueue() {
        let expectedQueue = TestConstants.customSubscriptionQueue
        let actual = sut.subscriptionQueue

        sut = makeSUT(subscriptionQueue: expectedQueue)
        
        XCTAssertEqual(actual, expectedQueue)
    }
    
    
    func test_Creation_WithDataTasker_SetsDataTasker() {
        dataTasker = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
        
        let expected = dataTasker
        let actual = sut.dataTasker
        
        XCTAssertTrue(actual === expected)
    }
}


// MARK: - Performing Successful Requests
extension FileRequestPublisherTests {
    
    func test_PerformRequestForTxtFile_WhenSuccessful_PublishesFileResponse() throws {
        let url = try XCTUnwrap(bundle.url(
            forResource: TestConstants.FilePaths.headlineText,
            withExtension: "txt"
        ))
        
        let request = URLRequest(url: url)
        let publisher = sut.perform(request)
        
        XCTAssertNoThrow(try awaitCompletion(of: publisher))
    }
    
    
    func test_PerformRequestForJSONFile_WhenSuccessful_PublishesFileResponse() throws {
        let url = try XCTUnwrap(bundle.url(
            forResource: TestConstants.FilePaths.weatherDataJSON,
            withExtension: "json"
        ))
        
        let request = URLRequest(url: url)
        let publisher = sut.perform(request)
        
        XCTAssertNoThrow(try awaitCompletion(of: publisher))
    }
}


// MARK: - Error Handling
extension FileRequestPublisherTests {
    
    func test_PerformRequest_WhenFailed_PublishesCompletionWithFileLoadingError() throws {
        dataTasker = URLSession(mockResponder: MockErrorURLResponder.self)
        sut = makeSUT()

        let url = URL(fileURLWithPath: "this doesn't exist")
        
        let request = URLRequest(url: url)
        let publisher = sut.perform(request)
        
        XCTAssertThrowsError(try awaitCompletion(of: publisher)) { (error) in
            let error = try! XCTUnwrap(error as? FileLoadingError)
            
            switch error.code {
            case .badURL:
                break
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
    }
}
