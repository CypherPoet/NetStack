import Foundation
import NetStack


enum TestConstants {
    static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")

    enum FilePaths {
        static let headlineText = "headline"
        static let weatherDataJSON = "weather-data"
    }
    
    enum EndpointURLs {
        static let example = URL(string: "https://www.example.com")!
    }
    
    enum SampleModels {
        static let player = Player(name: "Gandalf", xp: 100.32, level: 10)
    }
    
    
    enum HTTPURLResponses {
        static let creationSuccess = HTTPURLResponse(
            url: TestConstants.EndpointURLs.example,
            statusCode: HTTPStatus.created.rawValue,
            httpVersion: HTTPVersion.V1_1.rawValue,
            headerFields: [String : String]()
        )!
    }
}

