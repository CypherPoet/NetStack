import XCTest
import Combine
@testable import NetStack


private enum TestData {
    static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")
    //    static let endpointURL = URL(string: "https://www.example.com")!
    //    static let mockFileDataTasker = MockFileDataTasker()
    enum FilePaths {
        static let headline = "headline"
        static let json = "weather-data"
    }
}


final class FileRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    private var sut: FileRequestPublisher!
    
    
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
        dataTasker: SessionDataTaskPublishing = MockFileDataTasker(responseData: Data())
    ) -> FileRequestPublisher {
        FileRequestPublisher(
            subscriptionQueue: subscriptionQueue,
            dataTasker: dataTasker
        )
    }
    
    
    func makeSUTFromDefaults() -> FileRequestPublisher {
        FileRequestPublisher()
    }
    
    
    func failOnCompletionWithFileLoadingError(completion: Subscribers.Completion<FileLoadingError>) {
        switch completion {
        case .failure(let error):
            XCTFail(error.localizedDescription)
        case .finished:
            break
        }
    }
}


// MARK: - Init
extension FileRequestPublisherTests {
    
    func test_WhenCreated_WithDefaults_SetsSubscriptionQueueToGlobalQueue() {
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
        let expected = TestData.customSubscriptionQueue
        let actual = sut.subscriptionQueue
        
        XCTAssertEqual(actual, expected)
    }
    
    
    func test_Creation_WithDataTasker_SetsDataTasker() {
        let dataTasker = MockFileDataTasker(responseData: Data())
        
        sut = makeSUT(dataTasker: dataTasker)
        
        let expected = dataTasker
        let actual = sut.dataTasker
        
        XCTAssertTrue(actual === expected)
    }
}


// MARK: - Performing Successful Requests
extension FileRequestPublisherTests {
    
    func test_PerformRequestForTxtFile_WhenSuccessful_PublishesFileResponse() throws {
        let url = try XCTUnwrap(Bundle.module.url(
            forResource: TestData.FilePaths.headline,
            withExtension: "txt"
        ))
        
        let request = URLRequest(url: url)
        
        let receivedResponse = expectation(
            description: "Received response after performing a successful request."
        )
        
        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithFileLoadingError,
                receiveValue: { response in
                    receivedResponse.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 1.0)
    }
    
    
    func test_PerformRequestForJSONFile_WhenSuccessful_PublishesFileResponse() throws {
        let url = try XCTUnwrap(Bundle.module.url(
            forResource: TestData.FilePaths.json,
            withExtension: "json"
        ))
        
        let request = URLRequest(url: url)
        
        let receivedResponse = expectation(
            description: "Received response after performing a successful request"
        )
        
        let response = "🦄"
        let responseData = Data(response.utf8)
        
        sut = makeSUT(dataTasker: MockFileDataTasker(responseData: responseData))
        
        sut
            .perform(request)
            .sink(
                receiveCompletion: failOnCompletionWithFileLoadingError,
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
extension FileRequestPublisherTests {
    
    func test_PerformRequest_WhenFailed_PublishesCompletionWithFileLoadingError() throws {
        let url = try XCTUnwrap(Bundle.module.url(
            forResource: TestData.FilePaths.json,
            withExtension: "json"
        ))
        
        let request = URLRequest(url: url)
        let urlErrorCode = URLError.Code.badURL
        let urlError = URLError(urlErrorCode)
        
        let expectedErrorCode = FileLoadingError.Code(urlError: urlError)
        let expectedError = FileLoadingError(code: expectedErrorCode, request: request)
        
        let receivedCompletionWithError = expectation(
            description: "Received completion with error after performing request."
        )
        
        let mockDataTasker = MockFileDataTasker(
            responseData: Data(),
            error: urlError
        )
        
        sut = makeSUT(dataTasker: mockDataTasker)
        
        sut
            .perform(request)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        XCTAssertTrue(type(of: error) == type(of: expectedError))
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


final class MockFileDataTasker {
    var responseData: Data
    var mimeType: String
    var error: URLError?
    
    
    init(
        responseData: Data,
        mimeType: String = "application/json",
        error: URLError? = nil
    ) {
        self.responseData = responseData
        self.mimeType = mimeType
        self.error = error
    }
}


extension MockFileDataTasker: SessionDataTaskPublishing {
    
    func response(for request: URLRequest) -> AnyPublisher<DataTaskResponse, DataTaskFailure> {
        guard error == nil else {
            return Fail(error: error!).eraseToAnyPublisher()
        }
        
        let response = URLResponse(
            url: request.url!,
            mimeType: mimeType,
            expectedContentLength: 0,
            textEncodingName: nil
        )
        
        let data = responseData
        
        return Just((data: data, response: response))
            .setFailureType(to: DataTaskFailure.self)
            .eraseToAnyPublisher()
    }
}
