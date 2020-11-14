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
        let dataWasPublished = expectation(description: "Data was published")
        
        JSONDataLoader
            .load(fromFileNamed: TestConstants.FilePaths.weatherDataJSON, in: bundle)
            .sink { (completion) in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail(error.localizedDescription)
                }
            } receiveValue: { (data) in
                dataWasPublished.fulfill()
            }
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
    
    
    func test_LoadFromBundleFile_WhenFileDoesntExist_FailsWithFileNotFoundError() throws {
        let dataWasPublished = expectation(description: "Data was published")
        let errorWasPublished = expectation(description: "Publisher failed with error")
        
        dataWasPublished.isInverted = true
        
        JSONDataLoader
            .load(
                fromFileNamed: TestConstants.FilePaths.weatherDataJSON + "nope",
                in: bundle
            )
            .sink(
                receiveCompletion: { (completion) in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        errorWasPublished.fulfill()
                        
                        switch error {
                        case .fileNotFound(_):
                            break
                        default:
                            XCTFail("Unexpected error case: \(error)")
                        }
                    }
                },
                receiveValue: { _ in
                    dataWasPublished.fulfill()
                }
            )
            .store(in: &subscriptions)
        
        waitForExpectations(timeout: 2.0)
    }
}
