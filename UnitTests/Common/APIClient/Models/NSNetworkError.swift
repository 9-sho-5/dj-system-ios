@testable import DJSystemiOS
import Foundation

class NSNetworkError: NSError {
    init(error: DJSystemiOS.NetworkError) {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "Network error: \(error)"
        ]
        super.init(domain: "CustomNetworkErrorDomain", code: error.code, userInfo: userInfo)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
