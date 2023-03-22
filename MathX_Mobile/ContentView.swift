import SwiftUI

struct ContentView: View {
    
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
    
    var body: some View {
        if !isShowingWelcomeScreen {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                        
                    }
                ToolsView()
                    .tabItem {
                        Label("Tools", systemImage: "wrench.and.screwdriver")
                    }
            }
            
            .accentColor(.purple)
        } else {
            WelcomeView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


