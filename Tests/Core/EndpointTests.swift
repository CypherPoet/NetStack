import XCTest
@testable import NetStack


final class EndpointTests: XCTestCase {

    private var sut: Endpoint!
}


// MARK: - Lifecycle
extension EndpointTests {

    override func setUpWithError() throws {
        // Put setup code here.
        // This method is called before the invocation of each
        // test method in the class.
        try super.setUpWithError()

        sut = makeSUTWithDefaults()
    }


    override func tearDownWithError() throws {
        // Put teardown code here.
        // This method is called after the invocation of each
        // test method in the class.
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension EndpointTests {

    func makeSUTWithDefaults() -> Endpoint {
        Endpoint(host: "www.example.com", path: "/test")
    }


    func makeSUT(
        host: String,
        path: String,
        scheme: String = "https",
        queryItems: [URLQueryItem]? = nil
    ) -> Endpoint {
        Endpoint(
            host: host,
            path: path,
            scheme: scheme,
            queryItems: queryItems
        )
    }
}


// MARK: - Test Initial Conditions
extension EndpointTests {

    func test_init_setsDefaultScheme() throws {
        XCTAssertEqual(sut.scheme, "https")
    }


    func test_init_withHostAndPath_computesURL() throws {
        let url = try XCTUnwrap(sut.url)

        XCTAssertEqual(url.absoluteString, "https://www.example.com/test")
    }


    func test_init_withBadPath_computesNoURL() throws {
        sut = makeSUT(host: "asdf", path: "🍕")

        XCTAssertNil(sut.url)
    }
}
