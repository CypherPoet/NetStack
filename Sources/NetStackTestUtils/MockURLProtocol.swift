import Foundation
import XCTest
import NetStack


// References:
//  --: https://developer.apple.com/videos/play/wwdc2018/417/
//  --: https://www.swiftbysundell.com/articles/testing-networking-logic-in-swift/
//  --: https://nshipster.com/nsurlprotocol/


public final class MockURLProtocol<Responder: MockURLResponding>: URLProtocol {
    var loadingTask: Task<Void, Error>?
    
    
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
        loadingTask?.cancel()
        
        loadingTask = Task {
            try await performLoad()
        }
    }
    
    
    public override func stopLoading() {
        // This method is required but doesn't need to do anything
        loadingTask = nil
    }
}


extension MockURLProtocol {
    
    private func performLoad() async throws {
        guard let client = client else {
            preconditionFailure()
        }

        
        // Here we try to get data from our responder type, and
        // we then send that data, as well as a HTTP response,
        // to our client. If any of those operations fail,
        // we send an error instead:
        do {
            let data = try await Responder.respond(to: request)
            
            client.urlProtocol(self, didLoad: data)
            
            let response = try XCTUnwrap(HTTPURLResponse(
                url: XCTUnwrap(self.request.url),
                statusCode: 200,
                httpVersion: HTTPVersion.V1_1.rawValue,
                headerFields: nil
            ))
            
            client.urlProtocol(
                self,
                didReceive: response,
                cacheStoragePolicy: .notAllowed
            )
            
            client.urlProtocolDidFinishLoading(self)
        } catch {
            client.urlProtocol(self, didFailWithError: error)
        }
    }
}
