import Foundation
import NetStack
import Combine


final class MockModelTransporter {
    var session: URLSession
    var requestError: NetworkError?
    
    
    // MARK: - Init
    init(
        session: URLSession,
        requestError: NetworkError? = nil
    ) {
        self.session = session
        self.requestError = requestError
    }
}


// MARK: - ModelTransportRequestPublishing
extension MockModelTransporter: ModelTransportRequestPublishing {
    
    func perform<Model>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder
    ) -> AnyPublisher<Model, NetworkError>
    where Model: Decodable {
        session
            .dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: Model.self, decoder: decoder)
            .mapError { _ in self.requestError ?? NetworkError(code: .unknown, request: request) }
            .eraseToAnyPublisher()
    }
    
    
    func encode<Model>(
        dataFor model: Model,
        using encoder: JSONEncoder
    ) -> AnyPublisher<Data, Error>
    where Model: Encodable {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
    
    func encode<Model>(
        dataFor model: Model,
        intoBodyOf request: URLRequest,
        using encoder: JSONEncoder
    ) -> AnyPublisher<URLRequest, NetworkError>
    where Model: Encodable {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
    
    
    func send<Model>(
        dataFor model: Model,
        inBodyOf request: URLRequest,
        encodingWith encoder: JSONEncoder,
        decodingWith decoder: JSONDecoder
    ) -> AnyPublisher<Model, NetworkError>
    where Model: Decodable, Model : Encodable {
        Empty(completeImmediately: true).eraseToAnyPublisher()
    }
}
