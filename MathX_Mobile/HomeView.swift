import SwiftUI

struct HomeView: View {
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [.purple, .indigo], startPoint: .top, endPoint: .bottom).ignoresSafeArea()
            
            VStack {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                    .padding(.top, 150)
                
                Text("MathX")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text("Please ensure that you use the app at the appropriate times and only when necessary.")
                    .font(.body)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)
                
                Spacer()
                
                Button(action: {
                    // TODO: Add action for button
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 40)
                        .background(Color.blue)
                        .cornerRadius(20)
                }
                .padding(.bottom, 100)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
