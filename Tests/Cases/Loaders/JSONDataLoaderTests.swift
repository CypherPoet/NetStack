import XCTest
import Combine
import NetStack



final class JSONDataLoaderTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    private var bundle: Bundle!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        bundle = Bundle.module
    }
    
    
    override func tearDownWithError() throws {
        bundle = nil
        
        try super.tearDownWithError()
    }
}


extension JSONDataLoaderTests {
    
    func test_LoadFromBundleFile_PublishesData() throws {
        let publisher = JSONDataLoader
            .load(
                fromFileNamed: TestConstants.FilePaths.weatherDataJSON,
                in: bundle
            )
        
        XCTAssertNoThrow(try awaitCompletion(of: publisher))
    }
    
    
    func test_LoadFromBundleFile_WhenFileDoesntExist_FailsWithFileNotFoundError() throws {
        let publisher = JSONDataLoader
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
}

