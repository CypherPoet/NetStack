import Foundation

public protocol NetworkResponding {
    associatedtype Response
    
    var request: URLRequest  { get }
    var response: Response { get }
    var body: Data?  { get }
}


