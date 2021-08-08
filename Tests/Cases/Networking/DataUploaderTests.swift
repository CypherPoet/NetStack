import XCTest
import NetStack
import NetStackTestUtils


class DataUploaderTests: XCTestCase {
    private typealias SystemUnderTest = DataUploader
    private typealias MockDataURLResponder = SystemUnderTest.MockDataURLResponder
    private typealias MockErrorURLResponder = SystemUnderTest.MockErrorURLResponder

    
    private var urlSession: URLSession!
    private var sut: SystemUnderTest!
}


// MARK: - Lifecycle
extension DataUploaderTests {

    override func setUpWithError() throws {
        try super.setUpWithError()

        urlSession = .init(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        urlSession = nil
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension DataUploaderTests {

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
extension DataUploaderTests {

    private func givenSomething() {
        // some state or condition is established
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension DataUploaderTests {

    private func whenUploadExecutes() async throws -> NetworkResponse {
        let data = "Test Message".data(using: .utf8)!
        
        return try await sut.upload(
            data,
            to: TestConstants.EndpointURLs.example
        )
    }
}


// MARK: - Core Functionality
extension DataUploaderTests {

    func test_UploadDataToURL_WhenResponseSucceeds_ReturnsNetworkResponse() async throws {
        let response = try await whenUploadExecutes()
        let actualResponseData = response.body
        let expectedResponseData = SystemUnderTest.MockDataURLResponder.responseData

        XCTAssertEqual(actualResponseData, expectedResponseData)
    }
    
    
    func test_PerformUploadRequest_WhenResponseFails_ThrowsNetworkError() async throws {
        urlSession = .init(mockResponder: MockErrorURLResponder.self)
        sut = makeSUT()
        
        let response = try await whenUploadExecutes()
        let actualResponseData = response.body
        let expectedResponseData = SystemUnderTest.MockDataURLResponder.responseData

        XCTAssertEqual(actualResponseData, expectedResponseData)
    }
    
    
}
