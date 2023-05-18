import PKHUD
import SwiftUI
import UIKit

protocol SearchRoomPageControllerProtocol: Transitioner {
    var state: SearchRoomPageView.DataSource { get set }
    func searchRoom(byId id: String) async throws
}

final class SearchRoomPageViewController: UIViewController {
    @ObservedObject var state: SearchRoomPageView.DataSource = .init()
    // TODO: 後でletに変える
    var roomAPI: GetRoomAPIProtocol = Room.API()

    init(roomAPI: GetRoomAPIProtocol) {
        self.roomAPI = roomAPI
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            // レスポンス取得
            let result = try await roomAPI.getRoom(id: id)
            switch result {
            // Roomが見つかった時
            case .success(let response):
                let roomOverview = RoomOverview(id: response.id, name: response.name, description: response.description)
                Task.detached { @MainActor [state] in
                    // 取得したRoomOverviewを渡す
                    state.currentRoom = roomOverview
                    // 表示結果を表示する
                    state.showResultText = true
                }
                let router = SearchRoomRouter(controller: self)
                // Routerを使った画面遷移
                router.transitionToRoomOverviewPage(roomOverview: roomOverview)
                // ローディング終了
                HUD.hide()
            // Roomが見つからなかった時
            case .failure:
                let alert = UIAlertController(title: "ルームが見つかりませんでした", message: "IDが間違っていないか確認してください", preferredStyle: .alert)
                alert.addAction(
                    UIAlertAction(title: "OK", style: .cancel, handler:{ [self] (action: UIAlertAction!) -> Void in
                        Task.detached { @MainActor [state] in
                            // 空のRoomOverviewを渡す
                            state.currentRoom = RoomOverview(id: "", name: "", description: "")
                            // 表示結果を非表示にする
                            state.showResultText = false
                        }
                    })
                )
                present(alert, animated: true)
                // ローディング終了
                HUD.hide()
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}

