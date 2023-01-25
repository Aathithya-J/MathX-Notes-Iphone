import SwiftUI

struct Cheatsheet: View {
    var S1 = "Sec 1"
    var S2 = "Sec 2"
    var S3 = "Sec 3"
    var S4 = "Sec 4"
    let names = ["Numbers & their Operation", "Percentage", "Rate Ratio Speed", "Basic Algebra and Algebraic manipulation","Linear Equations and Inequalities","Data Analysis","Linear Functions and Graphs","Mensuration"]
    @State var searchText = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section ("S1"){
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
                return names
            } else {
                return names.filter { $0.contains(searchText) }
            }
        }
    }
    
    
    
    struct Cheatsheet_Previews: PreviewProvider {
        static var previews: some View {
            Cheatsheet()
        }
    }
    
