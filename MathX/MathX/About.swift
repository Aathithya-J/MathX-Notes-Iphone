
import SwiftUI

struct About: View {
    
    var body: some View {
        VStack {
            Text("About")
                .font(.title)
                .fontWeight(.bold).padding([.bottom],100)
            Text("This app was brought to you by Aathithya Jegatheesan and Kavin Jayakumar from SST Inc.").padding(30)
        }
    }
    
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
