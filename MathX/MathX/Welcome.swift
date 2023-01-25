
import SwiftUI

struct Welcome: View {
    
    var body: some View {
        VStack {
            Text("MathX")
                .font(.title)
                .fontWeight(.bold).padding([.bottom],250)
            Text("Pls ensure that you use the app at the appropriate times and only when necessary.").padding(30)
        }
    }
    
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
