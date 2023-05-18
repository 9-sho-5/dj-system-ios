@testable import DJSystemiOS
import Foundation

class MockNSErrorHandler: URLProtocol {
    private static var error: NetworkError?

    private var error: NetworkError {
        guard let error = MockNSErrorHandler.error else { fatalError("error is not set") }
        return error
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        guard let client else { fatalError("client is not found ") }
        let nsError = NSNetworkError(error: error)
        client.urlProtocol(self, didFailWithError: nsError)
        client.urlProtocolDidFinishLoading(self)
    }

    class func registerError(_ error: NetworkError) {
        self.error = error
    }

    override func stopLoading() {}
}


