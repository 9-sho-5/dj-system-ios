@testable import DJSystemiOS
import XCTest

final class SuccessfulCooltimeDataSource: CooltimeDataSourceProtocol {
    func fetch() throws -> TimeInterval {
        return Date().timeIntervalSince1970 + 1000
    }
    func remove() {}
    func set(unixTime: TimeInterval) {}
}

final class FailableCooltimeDataSource: CooltimeDataSourceProtocol {
    func fetch() throws -> TimeInterval {
        return Date().timeIntervalSince1970 - 1000
    }
    func remove() {}
    func set(unixTime: TimeInterval) {}
}

final class CooltimeSeriviceTests: XCTestCase {
    override func setUpWithError() throws {}
    override func tearDownWithError() throws {}

    func testFormatTime() throws {
        let cooltimeSerivce = CooltimeService(dataSource: SuccessfulCooltimeDataSource())
        let formattedTime1 = cooltimeSerivce.formatTime(hours: 0, minutes: 45, seconds: 15)
        XCTAssertEqual(formattedTime1, "45:15")

        let formattedTime2 = cooltimeSerivce.formatTime(hours: 0, minutes: 45, seconds: 5)
        XCTAssertEqual(formattedTime2, "45:05")

        let formattedTime3 = cooltimeSerivce.formatTime(hours: 1, minutes: 30, seconds: 30)
        XCTAssertEqual(formattedTime3, "01:30:30")

        let formattedTime4 = cooltimeSerivce.formatTime(hours: 1, minutes: 0, seconds: 0)
        XCTAssertEqual(formattedTime4, "01:00:00")
    }

    func testCalculateTimeLeft() {
        let cooltimeSerivce = CooltimeService(dataSource: SuccessfulCooltimeDataSource())
        let currentTime = Int(Date().timeIntervalSince1970)
        let timeToAdd: Int = 2 * 3_600 + 30 * 60 + 10
        let futureCooltime = currentTime + timeToAdd
        let (hours, minutes, seconds) = cooltimeSerivce.calculateTimeLeft(cooltime: futureCooltime)

        XCTAssertEqual(hours, 2)
        XCTAssertEqual(minutes, 30)
        XCTAssertEqual(seconds, 10)
    }

    func testHasExpired() {
        let successfullCooltimeService = CooltimeService(dataSource: SuccessfulCooltimeDataSource())
        let failableCooltimeService = CooltimeService(dataSource: FailableCooltimeDataSource())
        XCTAssertFalse(successfullCooltimeService.hasExpired)
        XCTAssertTrue(failableCooltimeService.hasExpired)
    }
}
