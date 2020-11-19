import Foundation


extension NetworkError {

    public enum Code: Int {
        
        /// A malformed URL prevented a URL request from being initiated.
        /// [Docs](https://developer.apple.com/documentation/foundation/1508628-url_loading_system_error_codes/nsurlerrorbadurl)
        case badURL

        /// Some sort of network connectivity problem
        case cannotConnect

        /// The user cancelled the request
        case cancelled

        /// Couldn't establish a secure connection to the server.
        case insecureConnection

        case dataEncodingFailed
        case dataDecodingFailed

        case missingResponse
        case responseMissingData

        /// The system did not receive a valid `HTTPURLResponse` response.
        case invalidResponse

        /// The request failed upon being fired.
        case unknownFailureOnLaunch

        /// The server determined that this request lacks proper authorization credentials.
        case unauthorizedRequest

        /// The server could not understand the request due to invalid syntax.
        ///
        /// See: [400 Bad Request](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400)
        case badRequest

        /// See: [402: Payment Required](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/402)
        case paymentRequired

        /// The requested resource could not be found
        case notFound

        /// The server determined that this request was beyond the number
        /// of requests it wants to handle from us.
        ///
        /// AKA: [Rate Limiting](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/429)
        case tooManyRequests

        /// The server is not ready to handle the request
        ///
        /// See: [503: Service Unavailable](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/503)
        case serverIsBusy

        /// Some generic server-side failure
        case severSideFailure

        /// The problem can't be determined... or at least it's not
        /// something `NetStack` is prepared to handle.
        case unknown
    }
}


// MARK: - Init from `HTTPURLResponse`
extension NetworkError.Code {

    init?(httpURLResponse: HTTPURLResponse) {
        switch httpURLResponse.statusCode {
        case 200 ..< 300:
            return nil
        case 400:
            self = .badRequest
        case 401:
            self = .unauthorizedRequest
        case 402:
            self = .paymentRequired
        case 404:
            self = .notFound
        case 429:
            self = .tooManyRequests
        case 503:
            self = .serverIsBusy
        case 500 ..< 600:
            self = .severSideFailure
        default:
            self = .unknown
        }
    }
}



// MARK: - Init from `URLError`
extension NetworkError.Code {

    /// Attempts to construct a `NetworkError` from
    /// a [`URLError`](https://developer.apple.com/documentation/foundation/urlerror).
    ///
    /// This can be useful for determining why request failed upon being launched -- before
    /// any other significant response data could be returned.
    init(urlError: URLError) {
        switch urlError.code {
        case .badURL:
            self = .badURL
        case .unsupportedURL:
            self = .badURL
        case .cannotConnectToHost:
            self = .cannotConnect
        default:
            self = .unknown
        }
    }
}
