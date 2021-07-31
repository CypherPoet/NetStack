import Foundation


extension FileDataFetchingError {

    public enum Code: Int {
        
        /// A malformed URL prevented a URL request from being initiated.
        /// [Docs](https://developer.apple.com/documentation/foundation/1508628-url_loading_system_error_codes/nsurlerrorbadurl)
        case badURL

        case unknown
    }
}


// MARK: - Init from `URLError`
extension FileDataFetchingError.Code {

    /// Attempts to construct a `FileLoadingError` from
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
        default:
            self = .unknown
        }
    }
}
