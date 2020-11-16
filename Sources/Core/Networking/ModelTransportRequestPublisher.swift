import Foundation
import Combine


public protocol ModelTransportRequestPublishing {

    func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder
    ) -> AnyPublisher<Model, NetworkError>


    func encode<Model: Encodable>(
        dataFor model: Model,
        using encoder: JSONEncoder
    ) -> AnyPublisher<Data, Error>


    func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: URLRequest,
        using encoder: JSONEncoder
    ) -> AnyPublisher<URLRequest, NetworkError>


    func send<Model: Codable>(
        dataFor model: Model,
        inBodyOf request: URLRequest,
        encodingWith encoder: JSONEncoder,
        decodingWith decoder: JSONDecoder
    ) -> AnyPublisher<Model, NetworkError>
}


public class ModelTransportRequestPublisher: ModelTransportRequestPublishing {
    public var transporter: TransportRequestPublishing

    
    public init(
        transporter: TransportRequestPublishing = TransportRequestPublisher()
    ) {
        self.transporter = transporter
    }


    public func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Model, NetworkError> {
        transporter
            .perform(request)
            .flatMap { networkResponse in
                return Just(networkResponse)
                    .map(\.body)
                    .replaceNil(with: Data())
                    .decode(type: Model.self, decoder: decoder)
                    .mapError { error in
                        switch error {
                        case (let error as DecodingError):
                            return NetworkError(
                                code: .dataDecodingFailed,
                                request: request,
                                response: networkResponse,
                                underlyingError: error
                            )
                        case (let error as NetworkError):
                            return error
                        default:
                            return NetworkError(
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


    public func encode<Model: Encodable>(
        dataFor model: Model,
        using encoder: JSONEncoder = .init()
    ) -> AnyPublisher<Data, Error> {
        Just(model)
            .encode(encoder: encoder)
            .eraseToAnyPublisher()
    }


    public func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: URLRequest,
        using encoder: JSONEncoder = .init()
    ) -> AnyPublisher<URLRequest, NetworkError> {
        encode(dataFor: model, using: encoder)
            .mapError { error in
                switch error {
                case (let error as EncodingError):
                    return NetworkError(
                        code: .dataEncodingFailed,
                        request: request,
                        response: nil,
                        underlyingError: error
                    )
                default:
                    return NetworkError(
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


    public func send<Model: Codable>(
        dataFor model: Model,
        inBodyOf request: URLRequest,
        encodingWith encoder: JSONEncoder = .init(),
        decodingWith decoder: JSONDecoder = .init()
    ) -> AnyPublisher<Model, NetworkError> {
        encode(dataFor: model, intoBodyOf: request)
            .flatMap { [weak self] request -> AnyPublisher<Model, NetworkError> in
                guard let self = self else {
                    return Fail(
                        error: NetworkError(
                            code: .cancelled,
                            request: request,
                            response: nil,
                            underlyingError: nil
                        )
                    )
                    .eraseToAnyPublisher()
                }

                return self.perform(request, decodingWith: decoder)
            }
            .eraseToAnyPublisher()
    }
}
