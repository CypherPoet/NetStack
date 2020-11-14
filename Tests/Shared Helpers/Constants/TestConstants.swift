import Foundation


enum TestConstants {
    static let customSubscriptionQueue = DispatchQueue(label: "Custom Queue")

    enum FilePaths {
        static let headlineText = "headline"
        static let weatherDataJSON = "weather-data"
    }
}

