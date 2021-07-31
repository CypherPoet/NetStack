import Foundation


/// A type that builds on top of ``NetStack/NetworkDataTransporting`` protocol
/// to provide utilities for performing requests for `Codable` data.
public struct ModelTransporter: ModelTransporting {
    
    public var dataTransporter: NetworkDataTransporting

    
    // MARK: - Init
    public init(
        dataTransporter: NetworkDataTransporting = NetworkDataTransporter()
    ) {
        self.dataTransporter = dataTransporter
    }

    
    ///
    ///
    /// - Throws: ``NetworkError``
    public func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder = .init()
    ) async throws -> Model {
        
        let networkResponse = try await dataTransporter.perform(request)
        
        do {
            return try decoder.decode(Model.self, from: networkResponse.body)
        } catch (let decodingError as DecodingError) {
            throw NetworkError(
                code: .dataDecodingFailed,
                request: request,
                response: networkResponse,
                underlyingError: decodingError
            )
        }
    }


    ///
    ///
    /// - Throws: ``NetworkError``
    public func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: inout URLRequest,
        using encoder: JSONEncoder = .init()
    ) throws {
        do {
            request.httpBody = try encoder.encode(model)
        } catch (let encodingError as EncodingError) {
            throw  NetworkError(
                code: .dataEncodingFailed,
                request: request,
                response: nil,
                underlyingError: encodingError
            )
        }
    }


    ///
    ///
    /// - Throws: ``NetworkError``
    public func send<Model: Codable>(
        dataFor model: Model,
        inBodyOf request: inout URLRequest,
        encodingWith encoder: JSONEncoder = .init(),
        decodingWith decoder: JSONDecoder = .init()
    ) async throws -> Model {
        try encode(dataFor: model, intoBodyOf: &request, using: encoder)
    
        return try await perform(request, decodingWith: decoder)
    }
    
    
}
