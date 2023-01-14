import SwiftUI

struct Cheatsheet: View {
    @State var sections = ["Sec 1", "Sec 2", "Sec 3", "Sec 4"]
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



struct Cheatsheet_Previews: PreviewProvider {
    static var previews: some View {
        Cheatsheet()
    }
}

