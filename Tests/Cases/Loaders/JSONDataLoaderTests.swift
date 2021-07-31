import XCTest
import NetStack
import NetStackTestUtils

class JSONDataLoaderTests: XCTestCase {
    private typealias SystemUnderTest = JSONDataLoader
    private typealias MockDataURLResponder = FileDataFetcher.MockDataURLResponder

    private var fileName: String!
    private var bundle: Bundle!
    private var urlSession: URLSession!
    private var sut: JSONDataLoader!
}


// MARK: - Lifecycle
extension JSONDataLoaderTests {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        fileName = TestConstants.FilePaths.weatherDataJSON
        bundle = .module
//        urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        urlSession = .shared
        
        sut = makeSUT()
    }
    
    
    override func tearDownWithError() throws {
        fileName = nil
        bundle = nil
        urlSession = nil
        
        sut = nil
        
        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension JSONDataLoaderTests {
    
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
extension JSONDataLoaderTests {
    
    private func givenSomething() {
        // some state or condition is established
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension JSONDataLoaderTests {
    
    private func whenSomethingHappens() {
        // perform some action
    }
}


// MARK: - Test Initial Conditions From Default Initialization
extension JSONDataLoaderTests {
    
    func test_Init_WithDefaultProperties_() throws {
        
    }
}


// MARK: - Test Initializing with Custom Arguments
extension JSONDataLoaderTests {
//
//    func test_Init_GivenCustom[ARG_NAME]_EstablishesSomeCondition() throws {
//
//    }
}


extension JSONDataLoaderTests {
    
    func test_Fetch_GivenValidFileNameAndBundle_ReturnsDataFromFile() async throws {
        let actual = try await sut.fetch(
            fromFileNamed: fileName,
            in: bundle
        )
        
        let expected = try! Data(
            contentsOf: bundle.url(
                forResource: fileName,
                withExtension: "json"
            )!
        )
        
        XCTAssertEqual(actual, expected)
    }
    
    func test_Fetch_GivenInvalidFileName_FailsWithFileNotFoundError() async throws {
        fileName += "nope"

        do {
            let _ = try await sut.fetch(
                fromFileNamed: fileName,
                in: bundle
            )
        } catch (let error as JSONDataLoader.Error) {
            switch error {
            case .fileNotFound:
                return
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
        
        XCTFail("Unexpected success")
    }

    
    func test_Fetch_WhenURLErrorOccurs_FailsWithNetworkError() async throws {
        urlSession = URLSession(mockResponder: FileDataFetcher.MockErrorURLResponder.self)
        sut = makeSUT()
        
        do {
            let _ = try await sut.fetch(
                fromFileNamed: fileName,
                in: bundle
            )
        } catch (let error as JSONDataLoader.Error) {
            switch error {
            case .networkError:
                return
            default:
                XCTFail("Unexpected error case: \(error)")
            }
        }
        
        XCTFail("Unexpected success")
    }
}
