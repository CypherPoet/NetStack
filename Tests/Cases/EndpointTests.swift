import XCTest
import NetStack


final class EndpointTests: XCTestCase {
    private var sut: Endpoint!
    private var path: String!
    private var host: String!
    private var scheme: String!
    private var queryItems: [URLQueryItem]!
}


// MARK: - Lifecycle
extension EndpointTests {

    override func setUpWithError() throws {
        try super.setUpWithError()

        host = "www.example.com"
        path = "test"
        scheme = "https"
        queryItems = nil
        
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        host = nil
        path = nil
        scheme = nil
        queryItems = nil
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension EndpointTests {

    func makeSUTWithDefaults() -> Endpoint {
        .init(host: host, path: path)
    }


    func makeSUT() -> Endpoint {
        .init(
            host: host,
            path: path,
            scheme: scheme,
            queryItems: queryItems
        )
    }
}


// MARK: - Test Initial Conditions
extension EndpointTests {

    func test_Creation_SetsDefaultScheme() throws {
        XCTAssertEqual(sut.scheme, scheme)
    }


    func test_Creation_WithHostAndValidPath_ComputesURL() throws {
        let url = try XCTUnwrap(sut.url)

        XCTAssertEqual(url.absoluteString, "\(scheme!)://\(host!)/\(path!)")
    }
}
