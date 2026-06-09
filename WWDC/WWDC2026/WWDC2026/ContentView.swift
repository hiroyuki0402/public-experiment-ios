import SwiftUI
import Playgrounds

@main struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Hello Word")
                .swipeActions {
                    Text("Hello Word")
                        .foregroundColor(.red)
                }

            Rectangle()
                .fill(.red)
                .frame(width: 200, height: 100)
                .swipeActions {
                    Text("Hello Word")
                        .foregroundColor(.red)
                }

        }.swipeActionsContainer()
    }
}

#Preview {
    ContentView()
}

