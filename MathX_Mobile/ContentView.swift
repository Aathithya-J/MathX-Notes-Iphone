import SwiftUI

struct ContentView: View {
    
    @Binding var tabSelection: Int
    @Binding var isCalShowing: Bool
    @Binding var deepLinkSource: String
            
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
        
    var body: some View {
        if !isShowingWelcomeScreen {
            TabView(selection: $tabSelection) {
                NotesView()
                    .tabItem {
                        Label("Notes", systemImage: "doc.text")
                    }
                    .tag(0)
                CheatsheetsView()
                    .tabItem {
                        Label("Cheatsheets", systemImage: "list.bullet.clipboard")
                    }
                    .tag(1)
                ToolsView(isCalShowing: $isCalShowing, deepLinkSource: $deepLinkSource)
                    .tabItem {
                        Label("Tools", systemImage: "wrench.and.screwdriver")
                    }
                    .tag(2)
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


