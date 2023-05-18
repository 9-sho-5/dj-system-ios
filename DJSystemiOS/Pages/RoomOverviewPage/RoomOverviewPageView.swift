import SwiftUI

struct RoomOverviewPageView: View {

    weak var controller: RoomOverviewControllerProtocol?
    @ObservedObject var dataSource: DataSource

    init(controller: RoomOverviewControllerProtocol) {
        self.controller = controller
        self.dataSource = controller.state
    }

    var body: some View {
        VStack {
            if let name = controller?.state.name {
                Text(name)
                    .foregroundColor(Color(.label))
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
            }

            if let description = controller?.state.description {
                Text(description)
                    .foregroundColor(Color(.label))
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 36)
            }

            Button {
                controller?.toSearchMusicPage()
            } label: {
                // ボタンのタップ領域をここで指定
                Text("曲をリクエストする")
                    .frame(maxWidth: .infinity, minHeight: 42)
            }
            .background(Color.pink)
            .foregroundColor(Color(.white))
            .font(.system(size: 12, weight: .bold, design: .default))
            .cornerRadius(10)
        }
        .padding(16)

        Spacer()
    }
}

extension RoomOverviewPageView {
    class DataSource: ObservableObject {
        @Published var name: String = ""
        @Published var description: String = ""
        init(name: String, description: String) {
            self.name = name
            self.description = description
        }
    }
}

struct RoomOverviewPageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoomOverviewPageView(controller: RoomOverviewViewController(roomOverview: RoomOverview(id: "sample-gassi", name: "sample-gassi", description: "サンプルの部屋")))
        }
    }
}
