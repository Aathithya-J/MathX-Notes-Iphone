
import SwiftUI

struct Tools: View {
    var EC = "Emergency Contact"
    var Ins = "Instruments"
    let tools = ["Emergency Contact", "HCF & LCM", "Algebra", "Instruments"]
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(searchResults, id: \.self) { tools in
                    NavigationLink {
                        if tools == EC {
                            Emergency()
                        }
                        else if tools == Ins {
                            List{
                                NavigationLink("Protractor", destination: EmptyView())
                                NavigationLink("Ruler", destination: EmptyView())
                            }
                        }
                    } label: {
                        Text(tools)
                    }
                }
            }
            .navigationTitle("Cheatsheets")
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [String] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.contains(searchText) }
        }
    }
}





struct Tools_Previews: PreviewProvider {
    static var previews: some View {
        Tools()
    }
}

