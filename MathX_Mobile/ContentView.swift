import SwiftUI

struct ContentView: View {
    
    @Binding var tabSelection: Int
    @Binding var isCalShowing: Bool
    @Binding var deepLinkSource: String
        
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
        
    var body: some View {
        if !isShowingWelcomeScreen {
            TabView(selection: $tabSelection) {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        
                    }
                    .tag(0)
                ToolsView(isCalShowing: $isCalShowing, deepLinkSource: $deepLinkSource)
                    .tabItem {
                        Label("Tools", systemImage: "wrench.and.screwdriver")
                    }
                    .tag(1)
            }
            
            .accentColor(.purple)
        } else {
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("ContentView()")
    }
}


