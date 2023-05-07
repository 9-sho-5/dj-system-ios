import PKHUD
import SwiftUI
import UIKit

protocol SearchRoomPageControllerProtocol: AnyObject {
    func searchRoom(byId id: String) async throws
    var state: SearchRoomPageView.DataSource { get set }
}

final class SearchRoomPageViewController: UIViewController {
    @ObservedObject var state: SearchRoomPageView.DataSource = .init()
    // TODO: 後でletに変える
    var roomAPI: GetRoomAPIProtocol = Room.API()

    init(roomAPI: GetRoomAPIProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.roomAPI = roomAPI
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.roomAPI = Room.API()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let homePage = SearchRoomPageView(controller: self)
        let hostingVC = UIHostingController(rootView: homePage)
        addChild(hostingVC)
        view.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)
        hostingVC.coverView(parent: view)
    }
}

extension SearchRoomPageViewController: SearchRoomPageControllerProtocol {
    func searchRoom(byId id: String) async throws {
        do {
            // ローディング開始
            HUD.show(.progress)
            // Roomの存在確認
            let roomOverview = try await roomAPI.getRoom(id: id)
            // RoomIdが空でないとき
            if !roomOverview.id.isEmpty {
                Task.detached { @MainActor [state] in
                    // 取得したRoomOverviewを渡す
                    state.currentRoom = roomOverview
                    // 表示結果を表示する
                    state.showResultText = true
                    // アラートを非表示する
                    state.shouldShowAlert = false
                }
                // 遷移先のRoomOverViewController
                let roomOverviewController = RoomOverviewViewController(roomOverview: roomOverview)
                // 画面遷移
                self.navigationController?.pushViewController(roomOverviewController, animated: true)
                // ローディング終了
                HUD.hide()
            // RoomIdが空の時(""の時)
            } else {
                Task.detached { @MainActor [state] in
                    // 空のRoomOverviewを渡す
                    state.currentRoom = RoomOverview(id: "", name: "", description: "")
                    // 表示結果を非表示にする
                    state.showResultText = false
                    // アラートを表示する
                    state.shouldShowAlert = true
                }
                // ローディング終了
                HUD.hide()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

