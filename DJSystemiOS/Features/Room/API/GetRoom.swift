import Foundation
import Moya

extension Room.API {
    struct GetRoomResponse: Codable {
        let id: String
        let name: String
        let description: String
        let roomCooltime: Int
    }
}

protocol GetRoomAPIProtocol {
    func getRoom(id: String) async throws -> Result<Room.API.GetRoomResponse, APIClientError>
}

extension Room.API: GetRoomAPIProtocol {
    func getRoom(id: String) async -> Result<GetRoomResponse, APIClientError> {
        let client = APIClient(baseURL: Environment.BaseAPIURL)
        let result = await client.get(from: .getRoom(roomId: id), dataType: Room.API.GetRoomResponse.self)
        return result
    }
}


