import SwiftUI

struct Cheatsheet: View {
    
    var body: some View {
        VStack {
            Text("Cheatsheets")
                .font(.title2)
                .fontWeight(.bold)
            List {
                Section(header: Text("Levels")) {
                    Text("Secondary 1").padding([.top,.bottom],10)
                    Text("Secondary 2").padding([.top,.bottom],10)
                    Text("Secondary 3").padding([.top,.bottom],10)
                    Text("Secondary 4").padding([.top,.bottom],10)
                }
            }
        }
    }
}
    


struct Cheatsheet_Previews: PreviewProvider {
    static var previews: some View {
        Cheatsheet()
    }
}
