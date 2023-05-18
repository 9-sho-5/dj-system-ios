import Foundation

enum URLBuilder {
    case roomOverview(roomId: String)
    case musicTop(roomId: String)
    case musicSearch(roomId: String, query: String)
    case requestMusic(roomId: String)
    case getRoom(roomId: String)

    var endpoint: URL {
        let baseURL = "http://example.com"
        switch self {
        case .roomOverview(let roomId):
            return URL(string: "\(baseURL)/room/\(roomId)")!
        case .musicTop(let roomId):
            return URL(string: "\(baseURL)/room/\(roomId)/music/top")!
        case .musicSearch(let roomId, let query):
            return URL(string: "\(baseURL)/room/\(roomId)/music/search?q=\(query)")!
        case .requestMusic(let roomId):
            return URL(string: "\(baseURL)/room/\(roomId)/request")!
        case .getRoom(let roomId):
            return URL(string: "\(baseURL)/room/\(roomId)")!
        }
    }
}

enum Endpoint {
    case roomOverview(roomId: String)
    case musicTop(roomId: String)
    case musicSearch(roomId: String, query: String)
    case requestMusic(roomId: String)
    case getRoom(roomId: String)

    var path: String {
        switch self {
        case .roomOverview(let roomId):
            return "/room/\(roomId)"
        case .musicTop(let roomId):
            return "/room/\(roomId)/music/top"
        case .musicSearch(let roomId, let query):
            return "/room/\(roomId)/music/search?q=\(query)"
        case .requestMusic(let roomId):
            return "/room/\(roomId)/request"
        case .getRoom(let roomId):
            return "/room/\(roomId)"
        }
    }
}

