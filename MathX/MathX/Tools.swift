
import SwiftUI

struct Tools: View {
    
    var body: some View {
        VStack {
            Text("Tools")
                .font(.title2)
                .fontWeight(.bold)
            
            List {
                Section(header: Text("Tools")) {
                    Text("Emergency Contact for Exams").padding([.top,.bottom],10)
                    Text("Calculator").padding([.top,.bottom],10)
                    Text("HCF and LCM").padding([.top,.bottom],10)
                    Text("Algebra Calculator").padding([.top,.bottom],10)
                    Text("Formulas").padding([.top,.bottom],10)
                    
                }
            }
        }
    }
    
}

struct Tools_Previews: PreviewProvider {
    static var previews: some View {
        Tools()
    }
}
