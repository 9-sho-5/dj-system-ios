import UIKit

protocol SearchRoomRouterProtocol: AnyObject {
    func transitionToRoomOverviewPage(roomOverview: RoomOverview)
}

final class SearchRoomRouter: SearchRoomRouterProtocol {
    private(set) weak var controller: SearchRoomPageViewController!

    init(controller: SearchRoomPageViewController) {
        self.controller = controller
    }

    func transitionToRoomOverviewPage(roomOverview: RoomOverview) {
        // 遷移先のRoomOverViewController
        let roomOverviewController = RoomOverviewViewController(roomOverview: roomOverview)
        // 画面遷移
        controller.navigationController?.pushViewController(roomOverviewController, animated: true)
    }
}
