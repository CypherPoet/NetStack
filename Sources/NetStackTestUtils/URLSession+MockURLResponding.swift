import Foundation


extension URLSession {
    
    public convenience init<MockURLResponder: MockURLResponding>(
        mockResponder: MockURLResponder.Type
    ) {
        let config = URLSessionConfiguration.ephemeral
        
        config.protocolClasses = [MockURLProtocol<MockURLResponder>.self]
        
        self.init(configuration: config)

        URLProtocol.registerClass(MockURLProtocol<MockURLResponder>.self)
    }
}
