import SwiftUI

struct ContentView: View {
    
    @Binding var tabSelection: Int
    @Binding var isCalShowing: Bool
    @Binding var isCalListShowing: Bool
    @Binding var deepLinkSource: String
    
    @State var isAnimationOver = false
            
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
        
    var body: some View {
        if !isShowingWelcomeScreen {
            if isAnimationOver {
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
                    ToolsView(isCalListShowing: $isCalListShowing, isCalShowing: $isCalShowing, deepLinkSource: $deepLinkSource)
                        .tabItem {
                            Label("Tools", systemImage: "wrench.and.screwdriver")
                        }
                        .tag(2)
                }
                .accentColor(.purple)
            } else {
                animationView(isAnimationOver: $isAnimationOver)
            }
        } else {
            WelcomeView()
        }
    }
}

struct animationView: View {
    
    @Binding var isAnimationOver: Bool // is true when all animations have been executed
    @State var titleShowingAnimation = false // shows "MathX" title
    
    @Namespace var animation
    
    var body: some View {
        ZStack {
            /// Background
            LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                Image(systemName: "x.squareroot")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 96)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) { // executes code after a second
                            withAnimation(.spring()) {
                                titleShowingAnimation = true // starts showing of text
                            }
                        }
                    }
                
                if titleShowingAnimation { /// "MathX" text title
                    Text("MathX")
                        .padding(.top, 10)
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.largeTitle)
                        .matchedGeometryEffect(id: "welcomeText", in: animation)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) { // executes code after 750 ms
                                withAnimation {
                                    isAnimationOver = true // shows normal content
                                }
                            }
                        }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("ContentView()")
    }
}


