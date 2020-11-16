import XCTest
import Combine
import NetStack
import NetStackTestUtils



final class JSONDataLoaderTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()

    typealias MockDataURLResponder = FileRequestPublisher.MockDataURLResponder

    private var bundle: Bundle!
    private var session: URLSession!
    private var sut: JSONDataLoader!
    
    
    override func setUpWithError() throws {
        try super.setUpWithError()
            
        bundle = Bundle.module
        session = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        bundle = nil
        session = nil
        sut = nil
        
        try super.tearDownWithError()
    }
    
    
    func makeSUT() -> JSONDataLoader {
        JSONDataLoader(dataTasker: session)
    }
}


extension JSONDataLoaderTests {
    
    func test_LoadFromBundleFile_PublishesData() throws {
        let publisher = sut
            .load(
                fromFileNamed: TestConstants.FilePaths.weatherDataJSON,
                in: bundle
            )
        
        XCTAssertNoThrow(try awaitCompletion(of: publisher))
    }
    
    
    func test_LoadFromBundleFile_WhenFileDoesntExist_FailsWithFileNotFoundError() throws {
        let publisher = sut
            .load(
                fromFileNamed: TestConstants.FilePaths.weatherDataJSON + "nope",
                in: bundle
            )
        
        XCTAssertThrowsError(try awaitCompletion(of: publisher)) { (error) in
            let error = try! XCTUnwrap(error as? JSONDataLoaderError)
            
            switch error {
            case .fileNotFound:
                break
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
    }
    
    
    func test_LoadFromBundleFile_WhenURLErrorOccurs_FailsWithNetworkError() throws {
        session = URLSession(mockResponder: MockErrorURLResponder.self)
        sut = makeSUT()
        
        let publisher = sut
            .load(
                fromFileNamed: TestConstants.FilePaths.weatherDataJSON,
                in: bundle
            )
        
        XCTAssertThrowsError(try awaitCompletion(of: publisher)) { error in
            let error = try! XCTUnwrap(error as? JSONDataLoaderError)

            switch error {
            case .networkError(let error as FileLoadingError):
                let urlError = try! XCTUnwrap(error.underlyingError as? URLError)

                XCTAssertEqual(urlError.code, MockErrorURLResponder.errorResponse.code)
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
    }
}

