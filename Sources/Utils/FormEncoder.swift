import Foundation


/// A utility for encoding form-item pairs (consisting of a "key" and "value")
/// into Data that can be used during [multi-part form uploads](https://en.wikipedia.org/wiki/MIME#Form-Data).
public enum FormEncoder {

    static func queryItems(for formItems: [String: String]) -> [URLQueryItem] {
        formItems.map { URLQueryItem(name: $0.key, value: $0.value) }
    }

    static func urlEncode(string: String) -> String {
        string.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? ""
    }

    static func urlEncode(queryItem: URLQueryItem) -> String {
        let (name, value) = (queryItem.name, queryItem.value ?? "")

        return "\(urlEncode(string: name))=\(urlEncode(string: value))"
    }


    public static func encode(formItems: [String: String]) -> Data {
        let queryItems = self.queryItems(for: formItems)
        let formPieces = queryItems.map(Self.urlEncode(queryItem:))

        let bodyString = formPieces.joined(separator: "&")

        return Data(bodyString.utf8)
    }
}
