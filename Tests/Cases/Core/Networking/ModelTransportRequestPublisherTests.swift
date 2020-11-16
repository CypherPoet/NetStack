import XCTest
import Combine
@testable import NetStack


final class ModelTransportRequestPublisherTests: XCTestCase {
    private var subscriptions = Set<AnyCancellable>()
    
    typealias MockDataURLResponder = ModelTransportRequestPublisher.MockDataURLResponder
    typealias MockErrorURLResponder = ModelTransportRequestPublisher.MockErrorURLResponder

    
    private var dataTasker: SessionDataTaskPublishing!
    private var sut: ModelTransportRequestPublisher!


    override func setUpWithError() throws {
        try super.setUpWithError()

        dataTasker = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        dataTasker = nil
        sut = nil

        try super.tearDownWithError()
    }


    func makeSUT() -> ModelTransportRequestPublisher {
        .init(
            requestPublisher: TransportRequestPublisher(dataTasker: dataTasker)
        )
    }


    func makeSUTFromDefaults() -> ModelTransportRequestPublisher {
        .init()
    }
}


// MARK: - Core Functionality
extension ModelTransportRequestPublisherTests {

    func test_EncodeDataForModel_CreatesEncodedData() throws {
        let player = TestConstants.SampleModels.player
        let expectedData = try JSONEncoder().encode(player)

        let publisher = sut.encode(dataFor: player)
        let result = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(result, [expectedData])
    }


    func test_EncodeDataForModelIntoBodyOfRequest_EncodesDataAndSetsItOnARequestBody() throws {
        let player = TestConstants.SampleModels.player

        let expectedData = try JSONEncoder().encode(player)
        let request = URLRequest(url: TestConstants.EndpointURLs.example)
        let publisher = sut.encode(dataFor: player, intoBodyOf: request)
        
        let result = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(result.first?.httpBody, expectedData)
    }


    func test_SendEncodedDataForModelInBodyOfRequest_EncodesDataAndPerformsAPost() throws {
        var request = URLRequest(url: TestConstants.EndpointURLs.example)

        RequestConfigurator.configure(
            &request,
            withHeaders: RequestConfigurator.DefaultHeaders.postJSON,
            method: .post
        )

        let player = MockDataURLResponder.responseModel
        let publisher = sut.send(dataFor: player, inBodyOf: request)
        let result = try awaitCompletion(of: publisher)
        
        XCTAssertEqual(result, [player])
    }
}
