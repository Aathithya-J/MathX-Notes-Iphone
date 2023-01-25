import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Welcome()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Cheatsheet()
                .tabItem {
                    Label("Cheatsheets", systemImage: "doc.text.magnifyingglass")
                }
            Tools()
                .tabItem {
                    Label("Tools", systemImage: "wrench.and.screwdriver")
                }
            Notes()
                .tabItem {
                    Label("Notes", systemImage: "doc.text")
                }
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
