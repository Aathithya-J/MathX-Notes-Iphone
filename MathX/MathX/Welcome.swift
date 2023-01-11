
import SwiftUI

struct Welcome: View {
    
    var body: some View {
        VStack {
            Text("Welcome to Math X")
                .font(.title)
                .fontWeight(.bold).padding([.bottom],100)
            Text("Pls ensure to use the app at the appropriately and when only necessary.").padding(30)
        }
    }
    
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
