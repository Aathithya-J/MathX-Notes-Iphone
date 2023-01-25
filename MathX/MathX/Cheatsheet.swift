import SwiftUI

struct Cheatsheet: View {
    var S1 = "Sec 1"
    var S2 = "Sec 2"
    var S3 = "Sec 3"
    var S4 = "Sec 4"
    let allNames = Sec1Chap + Sec2Chap
    let names1: [String] = Sec1Chap
    let names2: [String] = Sec1Chap
    
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section ("Secondary 1") {
                    ForEach(searchResults, id: \.self) { names in
                        NavigationLink {
                            Notes()
                        } label: {
                            Text(names)
                        }
                    }
                }
                
                Section ("Secondary 2") {
                    ForEach(searchResults, id: \.self) { names in
                        NavigationLink {
                            Notes()
                        } label: {
                            Text(names)
                        }
                    }
                }
                .navigationTitle("Cheatsheets")
                .listStyle(.sidebar)
            }
            
            .searchable(text: $searchText)
        }
    }
        
        var searchResults: [String] {
            if searchText.isEmpty {
                return allNames
            } else {
                return allNames.filter { $0.contains(searchText) }
            }
        }
    }
    
    
    
    struct Cheatsheet_Previews: PreviewProvider {
        static var previews: some View {
            Cheatsheet()
        }
    }
    
