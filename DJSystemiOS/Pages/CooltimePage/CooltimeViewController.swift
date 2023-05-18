import UIKit

class CooltimeViewController: UIViewController {

    /*TODO:
     画面がロードされたときにCooltimeServiceからクールタイムを取得し表示する
     1秒間隔でCooltimeServiceから残り時間を取得し、更新する
     クールタイムが0になった時、なったらタイマーを止める
     */

    override func viewDidLoad() {
        super.viewDidLoad()

        let cooltimeService = CooltimeService(dataSource: CooltimeDataSource())

        // 残り時間を取得する
        let remainingTime = cooltimeService.getRemainingCooltime()
        // 残り時間をUserDefaultsを保存する
        //    https://wa3.i-3-i.info/word18474.html
        let time = Date().timeIntervalSince1970 + 1000
        cooltimeService.saveCooltime(unixTime: time)
    }

}
