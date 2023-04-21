import SwiftUI

struct WelcomeView: View {
    
    @State var isStartingAnimationOver = false // is true when all animations have been executed
    
    var body: some View {
        
        if isStartingAnimationOver {
            TabView {
                welcomeTextPage() // stationary "welcome to mathx" view

                aboutPage(sfSymbol: "square.on.square.dashed", title: "New UI", description: "MathX has been completely redesigned by a team of developers from SST Inc!\n\nDevelopers: Aathithya Jegatheesan, Kavin Jayakumar, Sairam Suresh, and Tristan Chay (SST Batch 12)")
                
                aboutPage(sfSymbol: "list.clipboard", title: "Notes and Cheatsheets", description: "Notes and Cheatsheets allows you to take down and refer to revision materials later on.")

                aboutPage(sfSymbol: "wrench.and.screwdriver", title: "Useful Tools", description: "MathX's tools lets you do things like generate randomised numerical data, convert units, and plot graphs through Desmos right in the app!")

                aboutPage(sfSymbol: "plusminus.circle", title: "Calculators", description: "The built in calculators allows you to calculate mathematical equations like HCF, LCM, and Quadratic Equations on your phone!")
                
                finalPage() // last page with button to continue on to mathx
            }
            .padding(.bottom) // shifts tabview dots up
            .background(LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom))
            .ignoresSafeArea()
            .tabViewStyle(.page(indexDisplayMode: .always))
            
        } else {
            animatingWelcomeTextPage(isStartingAnimationOver: $isStartingAnimationOver) // animating "welcome to mathx" view
        }
    }
}

/// Stationary welcome text view
struct welcomeTextPage: View {
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
//                    Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                    Image(systemName: "x.squareroot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
//                        .frame(height: 64)
                }
                Text("Welcome to MathX!")
                    .foregroundColor(.white)
                    .fontWeight(.black)
                    .font(.title)
            }
            .padding(.top)
            Spacer()
            
            Image(systemName: "hand.draw")
                .resizable()
                .frame(width: 128, height: 128)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
            
            HStack {
                Text("To get started, swipe over to the next page!")
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .font(.subheadline)
            .fontWeight(.bold)
            .padding(.top)
            
            Spacer()
        }
    }
}

/// Animating welcome text view
struct animatingWelcomeTextPage: View {
    
    @Binding var isStartingAnimationOver: Bool // is true when all animations have been executed
    @State var titleExpandAnimation = false // text expanding from "MathX" to "Welcome to MathX"
    @State var titleShiftUpAnimation = false // text shifting to the top
    @Namespace var animation
    
    var body: some View {
        ZStack {
            /// Background
            LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        /// App Icon
//                        Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
                        Image(systemName: "x.squareroot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: titleExpandAnimation ? 32 : 64)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
//                            .frame(height: titleExpandAnimation ? 64 : 256)
                    }
                    
                    if titleExpandAnimation { /// To be shown when text has expanded from "MathX" to "Welcome to MathX"
                        Text("Welcome to MathX!")
                            .minimumScaleFactor(0.7)
                            .foregroundColor(.white)
                            .fontWeight(.black)
                            .font(.title)
                            .matchedGeometryEffect(id: "welcomeText", in: animation)
                            .onAppear {
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { // executes code after a second
                                    withAnimation(.spring()) {
                                        titleShiftUpAnimation = true // starts shifting up of App Icon and text
                                        
                                        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(750)) { // executes code after 750 ms (just enough time for the shifting up animation to execute)
                                            isStartingAnimationOver = true // shows stationary welcome text view
                                        }
                                    }
                                }
                            }
                    }
                }
                .padding(.top)
                
                if !titleExpandAnimation { /// Starting "MathX" text
                    Text("MathX")
                        .padding(.top, 5)
                        .minimumScaleFactor(0.7)
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .font(.largeTitle)
                        .matchedGeometryEffect(id: "welcomeText", in: animation)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) { // executes code after a second
                                withAnimation(.spring()) {
                                    titleExpandAnimation = true // starts expansion of text and shrinking of app icon
                                }
                            }
                        }
                }
                
                if titleShiftUpAnimation { /// Other view information to be shown when animation is over (to seamlessly transition to stationary welcome text view)
                    Spacer()
                    
                    Image(systemName: "hand.draw")
                        .resizable()
                        .frame(width: 128, height: 128)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)

                    HStack {
                        Text("To get started, swipe over to the next page!")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .padding(.top)
                    
                    Spacer()
                }
            }
        }
    }
}

struct aboutPage: View {
    
    let sfSymbol: String
    let title: String
    let description: String

    var body: some View {
        VStack {
            Image(systemName: sfSymbol)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 128, height: 128)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)

            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Text(description)
                .font(.subheadline)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 1)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
}

struct finalPage: View {
    
    @ObservedObject var noteManager: NoteManager = .shared
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true
    
    var body: some View {
        VStack {
            
//            Image(uiImage: UIImage(named: "AppIcon") ?? UIImage())
            Image(systemName: "x.squareroot")
                .resizable()
                .scaledToFit()
                .frame(width: 64)
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.4), radius: 3, x: 1, y: 3)
//                .frame(height: 128)
            
            Text("Ready to use MathX? Press the button below to continue!")
                .fontWeight(.black)
                .font(.title2)
                .padding(.top)
            
            Button {
                isShowingWelcomeScreen = false // turns welcomeview off (in ContentView), shows normal mathx view
                let content = "Welcome to MathX! This note is an example of how you can integrate LaTeX into your math notes :) \n\nFor example, here's the quadratic equation: \n \\[x=\\frac{-b\\pm\\sqrt{b^2-4ac}}{2a}\\] \n\nLaTeX allows us to do all sorts of cool things with math, ranging from simple things like \\[x^2\\] to more advanced mathematical formulas.\n\nFeel free to click the \"Edit\" button in the top right hand corner to look at the LaTeX code, or you could click on the blue \"?\" button to learn more about LaTeX."
                noteManager.notes.insert(Note(title: "LaTeX Example Note", content: content, latexRendering: true, dateLastModified: Date()), at: 0)
            } label: {
                HStack {
                    Text("Proceed to MathX")
                    Image(systemName: "arrow.right")
                }
                .padding()
                .frame(width: UIScreen.main.bounds.width / 1.5, height: 60)
                .background(.blue)
                .fontWeight(.bold)
                .font(.headline)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.25), radius: 3, x: 1, y: 3)
            }
            .padding(.top)
        }
        .padding(.horizontal)
        .foregroundColor(.white)
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
