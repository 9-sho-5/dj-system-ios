import Foundation

extension Room.API {
    struct RequestMusicInput {
        let musics: [String]
        let radioName: String
        let message: String
        let roomId: String
    }

    struct NewRequestMusicInput: Encodable {
        let musics: [String]
        let radioName: String
        let message: String
    }
    struct RequestMusicResponse: Codable {
        let ok: Bool
    }
}

protocol RequestMusicProtocol {
    func requestMusic(input: Room.API.RequestMusicInput) async throws -> Room.API.RequestMusicResponse
}

// TODO: こいつを実装する
protocol NewRequestMusicProtocol {
    func requestMusic(to id: String, inputs: Room.API.NewRequestMusicInput) async -> Result<Room.API.RequestMusicResponse, APIClientError>
}

extension Room.API: NewRequestMusicProtocol {
    func requestMusic(to id: String, inputs: NewRequestMusicInput) async -> Result<RequestMusicResponse, APIClientError> {
        let client = APIClient(baseURL: AppConfig.BaseAPIURL)
        let input: NewRequestMusicInput = inputs
        let requestMusic = await client.post(to: .requestMusic(roomId: id), with: input, responseDataType: Room.API.RequestMusicResponse.self)
        return requestMusic
    }
}
