import Foundation
import Combine


public protocol ModelTransportRequestPublishing: TransportRequestPublishing {

    func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<Model, NetStackError>


    func encode<Model: Encodable>(
        dataFor model: Model,
        using encoder: JSONEncoder
    ) -> AnyPublisher<Data, Error>


    func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: URLRequest,
        using encoder: JSONEncoder
    ) -> AnyPublisher<URLRequest, NetStackError>


    func send<Model: Codable>(
        encodedDataFor model: Model,
        inBodyOf request: URLRequest,
        encodingWith encoder: JSONEncoder,
        decodingWith decoder: JSONDecoder,
        maxRetries allowedRetries: Int
    ) -> AnyPublisher<Model, NetStackError>
}



// MARK: - Default Core Functionality
public extension ModelTransportRequestPublishing {

    func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder = .init(),
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<Model, NetStackError> {
        perform(
            request,
            maxRetries: allowedRetries
        )
        .flatMap { networkResponse in
            return Just(networkResponse)
                .map(\.body)
                .replaceNil(with: Data())
                .decode(type: Model.self, decoder: decoder)
                .mapError { error in
                    switch error {
                    case (let error as DecodingError):
                        return NetStackError(
                            code: .dataDecodingFailed,
                            request: request,
                            response: networkResponse,
                            underlyingError: error
                        )
                    case (let error as NetStackError):
                        return error
                    default:
                        return NetStackError(
                            code: .unknown,
                            request: request,
                            response: networkResponse,
                            underlyingError: error
                        )
                    }
                }
        }
        .eraseToAnyPublisher()
    }


    func encode<Model: Encodable>(
        dataFor model: Model,
        using encoder: JSONEncoder = .init()
    ) -> AnyPublisher<Data, Error> {
        Just(model)
            .encode(encoder: encoder)
            .eraseToAnyPublisher()
    }


    func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: URLRequest,
        using encoder: JSONEncoder = .init()
    ) -> AnyPublisher<URLRequest, NetStackError> {
        encode(dataFor: model, using: encoder)
            .mapError { error in
                switch error {
                case (let error as EncodingError):
                    return NetStackError(
                        code: .dataEncodingFailed,
                        request: request,
                        response: nil,
                        underlyingError: error
                    )
                default:
                    return NetStackError(
                        code: .unknown,
                        request: request,
                        response: nil,
                        underlyingError: error
                    )
                }
            }
            .map { data in
                var request = request
                request.httpBody = data

                return request
            }
            .eraseToAnyPublisher()
    }


    func send<Model: Codable>(
        encodedDataFor model: Model,
        inBodyOf request: URLRequest,
        encodingWith encoder: JSONEncoder = .init(),
        decodingWith decoder: JSONDecoder = .init(),
        maxRetries allowedRetries: Int = 0
    ) -> AnyPublisher<Model, NetStackError> {
        encode(dataFor: model, intoBodyOf: request)
            .flatMap { request in
                self.perform(request, decodingWith: decoder, maxRetries: allowedRetries)
            }
            .eraseToAnyPublisher()
    }
}
