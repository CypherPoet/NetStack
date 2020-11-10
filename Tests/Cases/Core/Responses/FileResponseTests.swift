//import XCTest
//@testable import NetStack
//
//
//private enum TestData {
////    static let url = URL(string: "https://example.com")!
//    enum FilePaths {
//        static let headline = "headline"
//        static let json = "weather-data"
//    }
//    
//    enum Responses {
////        static let loadJSONSuccess = URLResponse(url: url)!
//    }
//}
//
//
//final class FileResponseTests: XCTestCase {
//    private var sut: FileResponse!
//
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//    }
//
//
//    override func tearDownWithError() throws {
//        sut = nil
//
//        try super.tearDownWithError()
//    }
//
//
//    func makeSUT(
//        request: URLRequest = TestData.urlRequest,
//        response: HTTPURLResponse,
//        body: Data? = nil
//    ) -> FileResponse {
//        FileResponse(request: request, response: response, body: body)
//    }
//}
//
//
//// MARK: - Computed Properties
//extension FileResponseTests {
//
//    func test_Status_UsesResponseStatusCode() throws {
//        sut = makeSUT(response: TestData.Responses.creationSuccess)
//
//        let expected = TestData.Responses.creationSuccess.statusCode
//        let actual = sut.status.rawValue
//
//        XCTAssertEqual(actual, expected)
//    }
//
//
//    func test_Message_UsesLocalizedStringForStatusCode() throws {
//        let response = TestData.Responses.creationSuccess
//        sut = makeSUT(response: response)
//
//        let expected = HTTPURLResponse.localizedString(forStatusCode: response.statusCode)
//        let actual = sut.message
//
//        XCTAssertEqual(actual, expected)
//    }
//    
//    
//    func test_Header_UsesAllHeaderFieldsOnResponse() throws {
//        let response = TestData.Responses.creationSuccess
//        sut = makeSUT(response: response)
//
//        let expected = TestData.Responses.creationSuccess.allHeaderFields as! [String: String]
//        let actual = sut.headers as! [String: String]
//
//        XCTAssertEqual(actual, expected)
//    }
//}
