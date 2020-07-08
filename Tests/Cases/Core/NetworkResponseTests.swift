import XCTest
import Combine
@testable import NetStack


private enum TestData {
    static let url = URL(string: "https://example.com")!
    static let urlRequest = URLRequest(url: url)

    enum Responses {
        static let creationSuccess = HTTPURLResponse(
            url: url,
            statusCode: HTTPStatus.created.rawValue,
            httpVersion: String(kCFHTTPVersion1_1),
            headerFields: [String : String]()
        )!
    }
}


final class NetworkResponseTests: XCTestCase {
    private var sut: NetworkResponse!


    override func setUpWithError() throws {
        try super.setUpWithError()
    }


    override func tearDownWithError() throws {
        sut = nil
    }


    func makeSUT(
        request: URLRequest = TestData.urlRequest,
        response: HTTPURLResponse,
        body: Data? = nil
    ) -> NetworkResponse {
        NetworkResponse(request: request, response: response, body: body)
    }
}


// MARK: - Computed Properties
extension NetworkResponseTests {

    func testNetworkResponse_status_usesResponseStatusCode() throws {
        sut = makeSUT(response: TestData.Responses.creationSuccess)

        let expected = TestData.Responses.creationSuccess.statusCode
        let actual = sut.status.rawValue

        XCTAssertEqual(actual, expected)
    }


    func testNetworkResponse_message_usesLocalizedStringForStatusCode() throws {
        let response = TestData.Responses.creationSuccess
        sut = makeSUT(response: response)

        let expected = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
        let actual = sut.message

        XCTAssertEqual(actual, expected)
    }
}
