@testable import DJSystemiOS
import Foundation
import XCTest

class APIClientTests: XCTestCase {
    let baseURL = URL(string: "https://api.example.com")!
    var apiClient: APIClient = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockAPIResponseHandler.self]
        let session = URLSession(configuration: configuration)
        let apiClient = APIClient(urlSession: session, baseURL: URL(string: "https://example.com")!)
        return apiClient
    }()
    let statusCodes: [StatusCode] = [
        .ok,
        .badRequest,
        .unauthorized,
        .notFound,
        .internalServerError,
        .notImplemented,
        .badGateway,
        .serviceUnavailable
    ]

    struct SampleResponse: Codable {
        let key: String
    }

    func testAPIClient() async {
        for statusCode in statusCodes {
            let jsonData = try! JSONEncoder().encode(SampleResponse(key: "value"))
            let response = HTTPURLResponse(url: baseURL, statusCode: statusCode.value, httpVersion: "HTTP/1.1", headerFields: nil)
            guard let response else { fatalError("invalid HTTPURLResponse") }
            MockAPIResponseHandler.registerResponse(httpURLResponse: response, jsonData: jsonData)
            let result: Result<SampleResponse, APIClientError> = await apiClient.get(from: .musicTop(roomId: "hoge"), dataType: SampleResponse.self)

            switch statusCode {
            case .ok:
                if case .failure(let error) = result {
                    XCTFail("Expected success, got \(error) instead", file: #filePath, line: #line)
                }
            default:
                XCTAssertFailure(result, HTTPError(statusCode: statusCode.value, data: jsonData))
            }
        }
    }

    private func XCTAssertFailure<T>(_ result: Result<T, APIClientError>, _ expectedError: HTTPError) {
         switch result {
         case .success:
             XCTFail("Expected failure, got success instead", file: #filePath, line: #line)
         case .failure(let error):
             switch error {
             case .httpError(let httpError):
                 XCTAssertEqual(httpError.statusCode, expectedError.statusCode)
             default:
                 XCTFail("Expected \(expectedError), got \(error) instead", file: #filePath, line: #line)
             }
         }
     }
}
