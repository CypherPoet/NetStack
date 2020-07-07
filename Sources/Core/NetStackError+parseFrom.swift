import Foundation


extension NetStackError {
    
    public static func parseFrom(
        _ data: Data,
        and response: HTTPURLResponse
    ) -> Result<Void, NetStackError>  {
        switch response.statusCode {
        case 200 ..< 300:
            return .success(())
        case 400:
            return .failure(.badRequest(data, response))
        case 401:
            return .failure(.unauthorizedRequest)
        case 404:
            return .failure(.notFound)
        case 429:
            return .failure(.tooManyRequests(data, response))
        case 503:
            return .failure(.serverIsBusy(data, response))
        case 500 ..< 600:
            return .failure(.severSideFailure(data, response))
        default:
            return .failure(.unsuccessfulRequest(data, response))
        }
    }
}
