import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Welcome()
                .tabItem {
                    Label("Home", systemImage: "homekit")
                }
            Cheatsheet()
                .tabItem {
                    Label("Cheatsheets", systemImage: "doc.text.magnifyingglass")
                }
            Tools()
                .tabItem {
                    Label("Tools", systemImage: "wrench.and.screwdriver")
                }
            About()
                .tabItem {
                    Label("About", systemImage: "person.fill.questionmark")
                }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
