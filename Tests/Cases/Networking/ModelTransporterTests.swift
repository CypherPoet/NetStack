import XCTest
import NetStack


class ModelTransporterTests: XCTestCase {
    private typealias SystemUnderTest = ModelTransporter
    
    private typealias MockDataURLResponder = ModelTransporter.MockDataURLResponder
    private typealias MockErrorURLResponder = ModelTransporter.MockErrorURLResponder
   
    private var urlSession: URLSession!
    private var sut: SystemUnderTest!
}


// MARK: - Lifecycle
extension ModelTransporterTests {

    override func setUpWithError() throws {
        try super.setUpWithError()

        urlSession = URLSession(mockResponder: MockDataURLResponder.self)
        sut = makeSUT()
    }


    override func tearDownWithError() throws {
        urlSession = nil
        sut = nil

        try super.tearDownWithError()
    }
}


// MARK: - Factories
extension ModelTransporterTests {

    private func makeSUT(
    ) -> SystemUnderTest {
        .init(
            dataTransporter: NetworkDataTransporter(urlSession: urlSession)
        )
    }

    /// Helper to make the system under test from any default initializer
    /// and then test its initial conditions
    private func makeSUTFromDefaults() -> SystemUnderTest {
        .init()
    }
}


// MARK: - "Given" Helpers (Conditions Exist)
extension ModelTransporterTests {

    private func givenSomething() {
        // some state or condition is established
    }
}


// MARK: - "When" Helpers (Actions Are Performed)
extension ModelTransporterTests {

    private func whenSomethingHappens() {
        // perform some action
    }
}


// MARK: - Test Initializing with Custom Arguments
extension ModelTransporterTests {

    func test_Init_GivenCustomDataTransporter_UsesCustomDataTransporter() throws {
        XCTAssertEqual(
            sut.dataTransporter.urlSession.configuration.identifier,
            urlSession.configuration.identifier
        )
    }
}



// MARK: - Core Functionality
extension ModelTransporterTests {

    func test_EncodingRequestData_GivenEncodableData_SetsDataOnRequestBody() throws {
        let player = TestConstants.SampleModels.player
        var request = URLRequest(url: TestConstants.EndpointURLs.example)

        try sut.encode(dataFor: player, intoBodyOf: &request)

        let actualData = request.httpBody
        let expectedData = try JSONEncoder().encode(player)

        XCTAssertEqual(actualData, expectedData)
    }
    

    func test_SendEncodedDataForModelInBodyOfRequest_EncodesDataAndPerformsAPost() async throws {
        var request = URLRequest(url: TestConstants.EndpointURLs.example)

        RequestConfigurator.configure(
            &request,
            withHeaders: RequestConfigurator.DefaultHeaders.postJSON,
            method: .post
        )

        let modelToSendDataFor = MockDataURLResponder.responseModel
        let actualResult = try await sut.send(
            dataFor: modelToSendDataFor,
            inBodyOf: &request
        )
        let expectedResult = modelToSendDataFor

        XCTAssertEqual(actualResult, expectedResult)
    }
}
