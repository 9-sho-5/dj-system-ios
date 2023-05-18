@testable import DJSystemiOS
import Foundation
import XCTest


struct Sample: Codable {}

class NetworkErrorTests: XCTestCase {
    func testNetworkError() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockNSErrorHandler.self]
        let urlSession = URLSession(configuration: configuration)
        let client = APIClient(urlSession: urlSession, baseURL: URL(string: "https://example.com")!)

        for error in NetworkError.allCases {
            MockNSErrorHandler.registerError(error)
            let result: Result<Sample, APIClientError> = await client.get(from: .musicTop(roomId: "query"), dataType: Sample.self)
            switch result {
            case .success:
                XCTFail("Expected network error, got success")
            case .failure(let apiError):
                if case .networkError(let networkError) = apiError {
                    XCTAssertNotNil(networkError.errorDescription)
                } else {
                    XCTFail("Expected network error, got \(apiError)")
                }
            }
        }
    }
}

