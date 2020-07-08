extension NetStackError {

    public enum Code: Int {

        /// the `URLRequest` did not contain a `URL`.
        case missingURL

        /// the `URLRequest` did not contain a download `URL`.
        case missingDownloadURL

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
        case requestFailedOnLaunch

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
