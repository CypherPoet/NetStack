import XCTest
import NetStack


class NetworkDataTransporterTests: XCTestCase {
    private typealias SystemUnderTest = NetworkDataTransporter
    
    private typealias MockDataURLResponder = NetworkDataTransporter.MockDataURLResponder
    private typealias MockErrorURLResponder = NetworkDataTransporter.MockErrorURLResponder
   
    private var urlSession: URLSession!
    private var sut: SystemUnderTest!
}


// MARK: - Lifecycle
extension NetworkDataTransporterTests {

    override func setUpWithError() throws {
        try super.setUpWithError()

        urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        urlSession = nil
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension NetworkDataTransporterTests {

    private func makeSUT() -> SystemUnderTest {
        .init(
            urlSession: urlSession
        )
    }

    
    /// Helper to make the system under test from any default initializer
    /// and then test its initial conditions
    private func makeSUTFromDefaults() -> SystemUnderTest {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
extension NetworkDataTransporterTests {

    private func givenSomething() {
        // some state or condition is established
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension NetworkDataTransporterTests {

    private func whenSomethingHappens() {
        // perform some action
    }
}


// MARK: - Core Functionality
extension NetworkDataTransporterTests {

    func test_PerformRequest_WhenResponseIsSuccessful_ReturnsNetworkResponse() async throws {
        let request = URLRequest(url: TestConstants.EndpointURLs.example)
        
        let expectedData = try await MockDataURLResponder.respond(to: request)
        let actualData = try await sut.perform(request).body
        
        XCTAssertEqual(actualData, expectedData)
    }
    
    
    func test_PerformRequest_WhenResponseIsUnsuccessful_ReturnsNetworkError() async throws {
        urlSession = .init(mockResponder: MockErrorURLResponder.self)
        sut = makeSUT()
        
        let request = URLRequest(url: TestConstants.EndpointURLs.example)
        
        do {
            let _ = try await sut.perform(request)
            
            XCTFail("Unexpected Success of request")
        } catch {
            let networkError = error as! NetworkError
            let underlyingError = networkError.underlyingError as! URLError
            let actualErrorCode = underlyingError.code
            let expectedErrorCode = MockErrorURLResponder.errorResponse.code
            
            XCTAssertEqual(actualErrorCode, expectedErrorCode)
        }
    }
}
