import Foundation

enum NetworkError: LocalizedError {

    case unknown
    case invalidURL
    case timedOut
    case notConnectedToInternet
    case cannotFindHost
    case cannotConnectToHost
    case networkConnectionLost
    case appTransportSecurityRequiresSecureConnection
    case other(error: NSError)

    var errorDescription: String? {
        switch self {
        case .unknown:
            return "不明なエラーが発生しました"
        case .invalidURL:
            return "URLが無効です"
        case .timedOut:
            return "リクエストがタイムアウトしました"
        case .notConnectedToInternet:
            return "デバイスがインターネットに接続されていません"
        case .cannotFindHost:
            return "ホストが見つかりませんでした"
        case .cannotConnectToHost:
            return "ホストへの接続が確立できませんでした"
        case .networkConnectionLost:
            return "ネットワーク接続が失われました"
        case .appTransportSecurityRequiresSecureConnection:
            return "アプリは安全な接続を要求していますが、サーバーが安全でないため接続できません"
        case .other(let error):
            return "エラーが発生しました: \(error.localizedDescription)"
        }
    }

    var code: Int {
        switch self {
        case .unknown:
            return -1
        case .invalidURL:
            return -1000
        case .timedOut:
            return -1001
        case .notConnectedToInternet:
            return -1009
        case .cannotFindHost:
            return -1003
        case .cannotConnectToHost:
            return -1004
        case .networkConnectionLost:
            return -1005
        case .appTransportSecurityRequiresSecureConnection:
            return -1022
        case .other:
            return 0
        }
    }

    init(error: NSError) {
        switch error.code {
        case NSURLErrorUnknown:
            self = .unknown
        case NSURLErrorBadURL:
            self = .invalidURL
        case NSURLErrorTimedOut:
            self = .timedOut
        case NSURLErrorNotConnectedToInternet:
            self = .notConnectedToInternet
        case NSURLErrorCannotFindHost:
            self = .cannotFindHost
        case NSURLErrorCannotConnectToHost:
            self = .cannotConnectToHost
        case NSURLErrorNetworkConnectionLost:
            self = .networkConnectionLost
        case NSURLErrorAppTransportSecurityRequiresSecureConnection:
            self = .appTransportSecurityRequiresSecureConnection
        default:
            self = .other(error: error)
        }
    }
}

extension NetworkError: CaseIterable {
    static var allCases: [NetworkError] {
        return [
            .appTransportSecurityRequiresSecureConnection,
            .cannotConnectToHost,
            .cannotFindHost,
            .invalidURL,
            .networkConnectionLost,
            .notConnectedToInternet,
            .timedOut,
            .unknown,
            .other(error: NSError(domain: "CustomNetworkErrorDomain", code: 0_000, userInfo: [NSLocalizedDescriptionKey: "Network error"]))
        ]
    }
}
