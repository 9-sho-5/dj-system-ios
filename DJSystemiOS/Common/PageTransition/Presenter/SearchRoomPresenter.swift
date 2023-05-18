import UIKit

protocol SearchRoomPresenterProtocol {
    func transitionToRoomOverviewPage(roomOverview: RoomOverview)
}

final class SearchRoomPresenter: SearchRoomPresenterProtocol {
    private let router: SearchRoomRouterProtocol

    init(router: SearchRoomRouterProtocol) {
        self.router = router
    }

    func transitionToRoomOverviewPage(roomOverview: RoomOverview) {
        router.transitionToRoomOverviewPage(roomOverview: roomOverview)
    }
}
