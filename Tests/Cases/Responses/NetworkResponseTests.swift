import XCTest
import NetStack


class NetworkResponseTests: XCTestCase {
    private typealias SystemUnderTest = NetworkResponse

    private var sut: SystemUnderTest!
    private var urlRequest: URLRequest!
    private var httpURLResponse: HTTPURLResponse!
    private var body: Data!
}


// MARK: - Lifecycle
extension NetworkResponseTests {

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        urlRequest = .init(url: TestConstants.EndpointURLs.example)
        httpURLResponse = TestConstants.HTTPURLResponses.creationSuccess
        body = Data()

        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        urlRequest = nil
        httpURLResponse = nil
        body = nil
        
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension NetworkResponseTests {

    private func makeSUT(
    ) -> SystemUnderTest {
        .init(
            request: urlRequest,
            response: httpURLResponse,
            body: body
        )
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
extension NetworkResponseTests {

    private func givenSomething() {
        // some state or condition is established
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension NetworkResponseTests {

    private func whenSomethingHappens() {
        // perform some action
    }
}


// MARK: - Computed Properties
extension NetworkResponseTests {

    func test_Status_UsesResponseStatusCode() throws {
        let expected = TestConstants.HTTPURLResponses.creationSuccess.statusCode
        let actual = sut.status.rawValue

        XCTAssertEqual(actual, expected)
    }


    func test_Message_UsesLocalizedStringForStatusCode() throws {
        let response = TestConstants.HTTPURLResponses.creationSuccess

        let expected = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        let actual = sut.message

        XCTAssertEqual(actual, expected)
    }
    
    
    func test_Header_UsesAllHeaderFieldsOnResponse() throws {
        let expected = TestConstants
            .HTTPURLResponses
            .creationSuccess
            .allHeaderFields as! [String: String]
        
        let actual = sut.headers as! [String: String]

        XCTAssertEqual(actual, expected)
    }
}
