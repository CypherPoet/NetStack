import XCTest
@testable import NetStack



final class NetworkResponseTests: XCTestCase {
    private var sut: NetworkResponse!
    
    enum SampleData {
        enum Responses {
            static let creationSuccess = HTTPURLResponse(
                url: TestConstants.EndpointURLs.example,
                statusCode: HTTPStatus.created.rawValue,
                httpVersion: HTTPVersion.V1_1.rawValue,
                headerFields: [String : String]()
            )!
        }
    }


    override func setUpWithError() throws {
        try super.setUpWithError()
    }


    override func tearDownWithError() throws {
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT(
        request: URLRequest = .init(url: TestConstants.EndpointURLs.example),
        response: HTTPURLResponse,
        body: Data? = nil
    ) -> NetworkResponse {
        .init(request: request, response: response, body: body)
    }
}


// MARK: - Computed Properties
extension NetworkResponseTests {

    func test_Status_UsesResponseStatusCode() throws {
        sut = makeSUT(response: SampleData.Responses.creationSuccess)

        let expected = SampleData.Responses.creationSuccess.statusCode
        let actual = sut.status.rawValue

        XCTAssertEqual(actual, expected)
    }


    func test_Message_UsesLocalizedStringForStatusCode() throws {
        let response = SampleData.Responses.creationSuccess
        
        sut = makeSUT(response: response)

        let expected = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        let actual = sut.message

        XCTAssertEqual(actual, expected)
    }
    
    
    func test_Header_UsesAllHeaderFieldsOnResponse() throws {
        let response = SampleData.Responses.creationSuccess
        
        sut = makeSUT(response: response)

        let expected = SampleData.Responses.creationSuccess.allHeaderFields as! [String: String]
        let actual = sut.headers as! [String: String]

        XCTAssertEqual(actual, expected)
    }
}
