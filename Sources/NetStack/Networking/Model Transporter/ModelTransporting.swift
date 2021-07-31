import Foundation


public protocol ModelTransporting {

    var dataTransporter: NetworkDataTransporting { get }

    
    init(dataTransporter: NetworkDataTransporting)
    
    
    func perform<Model: Decodable>(
        _ request: URLRequest,
        decodingWith decoder: JSONDecoder
    ) async throws -> Model


    func encode<Model: Encodable>(
        dataFor model: Model,
        intoBodyOf request: inout URLRequest,
        using encoder: JSONEncoder
    ) throws


    func send<Model: Codable>(
        dataFor model: Model,
        inBodyOf request: inout URLRequest,
        encodingWith encoder: JSONEncoder,
        decodingWith decoder: JSONDecoder
    ) async throws -> Model
}
