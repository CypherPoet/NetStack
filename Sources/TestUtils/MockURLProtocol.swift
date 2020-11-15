import Foundation
import Combine
import XCTest

// References:
//  --: https://developer.apple.com/videos/play/wwdc2018/417/
//  --: https://www.swiftbysundell.com/articles/testing-networking-logic-in-swift/
//  --: https://nshipster.com/nsurlprotocol/


public final class MockURLProtocol<Responder: MockURLResponding>: URLProtocol {
    private var loadingTask: AnyCancellable?

    
    public override class func canInit(with request: URLRequest) -> Bool {
        true
    }
    
    
    // Handle all types of tasks
    public override class func canInit(with task: URLSessionTask) -> Bool {
        true
    }
    
    
    // Ignore this method; just send back what we were given.
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    
    public override func startLoading() {
        performLoad()
    }
    
    
    public override func stopLoading() {
        // This method is required but doesn't need to do anything
    }
}


private extension MockURLProtocol {
    
    func performLoad() {
        guard let client = client else { return }
        
        // Here we try to get data from our responder type, and
        // we then send that data, as well as a HTTP response,
        // to our client. If any of those operations fail,
        // we send an error instead:
        loadingTask = Responder
            .respond(to: request)
            .tryMap({ data -> HTTPURLResponse in
                client.urlProtocol(self, didLoad: data)
                
                let response = try XCTUnwrap(HTTPURLResponse(
                    url: XCTUnwrap(self.request.url),
                    statusCode: 200,
                    httpVersion: "HTTP/1.1",
                    headerFields: nil
                ))
                
                return response
            })
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard let self = self else { return }
                    
                    switch completion {
                    case .failure(let error):
                        client.urlProtocol(self, didFailWithError: error)
                    case .finished:
                        break
                    }
                },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    
                    client.urlProtocol(
                        self,
                        didReceive: response,
                        cacheStoragePolicy: .notAllowed
                    )
                })
        
        client.urlProtocolDidFinishLoading(self)
    }
    
}
