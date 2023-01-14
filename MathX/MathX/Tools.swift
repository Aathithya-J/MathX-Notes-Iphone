
import SwiftUI

struct Tools: View {
    @State var sections = ["Emergency Contact for Exams", "Calculator", "HCF and LCM", "Algebra Calculator", "Formulas"]
    
    var body: some View {
        NavigationView {
                List {
                    Section {
                        ForEach(sections, id:\.self) {section in
                            NavigationLink(destination: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Destination@*/Text("Destination")/*@END_MENU_TOKEN@*/) {
                                Text(section)
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Tools").font(.title), displayMode: .inline)
        }
    }
}




struct Tools_Previews: PreviewProvider {
    static var previews: some View {
        Tools()
    }
}
