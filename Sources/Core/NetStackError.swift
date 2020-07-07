import Foundation


public enum NetStackError: Error {
    case missingURL
    case missingDownloadURL
    
    /// 📝 NOTE: Despite `NetStack` providing an `errorDescription`, it might still be useful to
    /// inspect the full `EncodingError` instance returned as the error case's associated value.
    case dataEncodingFailed(EncodingError)
    
    /// 📝 NOTE: Despite `NetStack` providing an `errorDescription`, it might still be useful to
    /// inspect the full `DecodingError` instance returned as the error case's associated value.
    case dataDecodingFailed(DecodingError)
    
    case missingResponse
    case responseMissingData
    case requestFailed(error: Error)
    case unauthorizedRequest
    case badRequest(_ data: Data, _ response: HTTPURLResponse)
    case tooManyRequests(_ data: Data, _ response: HTTPURLResponse)
    case serverIsBusy(_ data: Data, _ response: HTTPURLResponse)
    case severSideFailure(_ data: Data, _ response: HTTPURLResponse)
    case notFound
    case unsuccessfulRequest(_ data: Data, _ response: HTTPURLResponse)
    case generic(error: Error)
}


extension NetStackError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .missingDownloadURL:
            return "No URL was returned for download request."
        case .missingResponse:
            return "No response was returned for the request."
        case .dataDecodingFailed(let decodingError):
            return "Error while attempting to decode data: \(decodingError.errorDescription ?? decodingError.localizedDescription)."
        case .dataEncodingFailed(let encodingError):
            return "Error while attempting to encode data: \(encodingError.errorDescription ?? encodingError.localizedDescription)."
        case .requestFailed(let error):
            return "The request failed with an error: \"\(error.localizedDescription)\""
        case .generic(let error):
            return error.localizedDescription
        case .missingURL:
            return "No URL was found in the request."
        case .responseMissingData:
            return "No data was returned in the response."
        case .unauthorizedRequest:
            return "The request was made without authorization."
        case .notFound:
            return "The requested resource could not be found."
        case .badRequest:
            return "The request was considered to be a bad request"
        case .tooManyRequests:
            return "Too many requests have been sent within a given amount of time."
        case .severSideFailure(_, let response):
            return "The request failed due to a server-side error. (Status Code: \(response.statusCode))."
        case .unsuccessfulRequest(_, let response):
            return "The request was unsuccessful. (Status Code: \(response.statusCode))."
        case .serverIsBusy(_, let response):
            return "The server has indicated that it's currently busy (Status Code: \(response.statusCode))."
        }
    }
}


extension NetStackError: Identifiable {
    public var id: String? { errorDescription }
}
