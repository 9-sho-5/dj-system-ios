@testable import DJSystemiOS
import XCTest

class APIClientInternalErrorTests: XCTestCase {
    let baseURL = URL(string: "https://api.example.com")!
    var apiClient: APIClient = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockAPIResponseHandler.self]
        let session = URLSession(configuration: configuration)
        let apiClient = APIClient(urlSession: session, baseURL: URL(string: "https://example.com")!)
        return apiClient
    }()

    func testDecodeError() async {
        let response = HTTPURLResponse(url: baseURL, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
        let invalidJsonData = "{ invalid json }".data(using: .utf8)!
        MockAPIResponseHandler.registerResponse(httpURLResponse: response, jsonData: invalidJsonData)
        let result: Result<SomeDecodableModel, APIClientError> = await apiClient.get(from: .musicTop(roomId: "hoge"), dataType: SomeDecodableModel.self)
        switch result {
        case .success:
            XCTFail("Expected a decode error")
        case .failure(let error):
            if case .internalError(let internalError) = error, case .failedToDecodeData = internalError {
                XCTAssertNotNil(internalError)
            } else {
                XCTFail("Expected an encode error, actual: \(error.localizedDescription)")
            }
        }
    }

    func testEncodeError() async {
        let result: Result<SomeDecodableModel, APIClientError> = await apiClient.post(to: .musicTop(roomId: "hoge"), with: SomeNonEncodableModel(), responseDataType: SomeDecodableModel.self)
        switch result {
        case .success:
            XCTFail("Expected an encode error")
        case .failure(let error):
            if case .internalError(let internalError) = error, case .failedToEncodeData = internalError {
                XCTAssertNotNil(internalError)
            } else {
                XCTFail("Expected an encode error, actual: \(String(reflecting: error)) \(error.localizedDescription)")
            }
        }
    }
}

