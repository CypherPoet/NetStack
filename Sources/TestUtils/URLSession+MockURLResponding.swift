import Foundation


extension URLSession {
    
    public convenience init<T: MockURLResponding>(mockResponder: T.Type) {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol<T>.self]
        
        self.init(configuration: config)

        URLProtocol.registerClass(MockURLProtocol<T>.self)
    }
}
