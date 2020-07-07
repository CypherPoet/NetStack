import Foundation
import Combine


public protocol ModelTransportRequestPublishing: TransportRequestPublishing {

    /// The instance of URLSession used for calling `.dataTaskPublisher`
    ///
    /// Default: `URLSession.shared`
    var session: URLSession { get }


    func perform<Model: Decodable>(
        _ request: URLRequest,
        with decoder: JSONDecoder,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<Model, NetStackError>


    func encode<Model: Encodable>(
        dataFor model: Model,
        withEncoder encoder: JSONEncoder
    ) -> AnyPublisher<Data, NetStackError>


    func encode<Model: Codable>(
        dataFor: Model,
        withEncoder: JSONEncoder,
        sendingInBodyOf request: URLRequest,
        decodingWith decoder: JSONDecoder,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<Model, NetStackError>
}



// MARK: - Default Core Functionality
public extension ModelTransportRequestPublishing {


    /// Uses the `session` to perform a data task for a `URLRequest`,
    /// then attempts to handle request errors and data decoding.
    /// - Parameters:
    ///   - receptionQueue: A queue to be used for parsing the response -- ideally off
    ///     the main thread.
    func perform<Model: Decodable>(
        _ request: URLRequest,
        with decoder: JSONDecoder = .init(),
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<Model, NetStackError> {
        perform(
            request,
            maxRetries: allowedRetries
        )
        .decode(type: Model.self, decoder: decoder)
        .mapError { error in
            switch error {
            case (let error as DecodingError):
                return .dataDecodingFailed(error)
            case (let error as NetStackError):
                return error
            default:
                return .generic(error: error)
            }
        }
        .eraseToAnyPublisher()
    }


    func encode<Model: Encodable>(
        dataFor model: Model,
        withEncoder encoder: JSONEncoder = .init()
    ) -> AnyPublisher<Data, NetStackError> {
        Just(model)
            .encode(encoder: encoder)
            .mapError { error in
                if let encodingError = error as? EncodingError {
                    return .dataEncodingFailed(encodingError)
                } else {
                    return .generic(error: error)
                }
            }
            .eraseToAnyPublisher()
    }


    func encode<Model: Codable>(
        dataFor model: Model,
        withEncoder encoder: JSONEncoder = .init(),
        sendingInBodyOf request: URLRequest,
        decodingWith decoder: JSONDecoder = .init(),
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<Model, NetStackError> {
        encode(dataFor: model, withEncoder: encoder)
            .map { data in
                var request = request
                request.httpBody = data

                return request
            }
            .flatMap { request in
                self.perform(request, with: decoder, maxRetries: allowedRetries)
            }
            .eraseToAnyPublisher()
    }
}
