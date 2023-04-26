import PKHUD
import SwiftUI
import UIKit

protocol RequestMusicViewControllerProtocol: AnyObject {
    func postMusic(radioName: String, message: String) async
    var state: RequestMusicView.DataSource { get set }
}

class RequestMusicViewController: UIViewController {
    @ObservedObject var state: RequestMusicView.DataSource = .init()
    var roomId: String
    var music: Music

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(roomId: String, music: Music) {
        self.roomId = roomId
        self.music = music
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let requestMusicView = RequestMusicView(controller: self, music: music)
        let hostingVC = UIHostingController(rootView: requestMusicView)
        addChild(hostingVC)
        view.addSubview(hostingVC.view)
        hostingVC.didMove(toParent: self)
        hostingVC.coverView(parent: view)
    }
}

extension RequestMusicViewController: RequestMusicViewControllerProtocol {
    func postMusic(radioName: String, message: String) async {
        HUD.show(.progress)
        let result = try! await Room.API().requestMusic(input: Room.API.RequestMusicInput(musics: [music.id], radioName: radioName, message: message, roomId: roomId))
        if result.ok {
            self.navigationController?.pushViewController(CompleteRequestViewController(), animated: true)
            HUD.flash(.success, delay: 1.0)
        } else {
            HUD.flash(.error, delay: 1.0)
        }
    }
}
