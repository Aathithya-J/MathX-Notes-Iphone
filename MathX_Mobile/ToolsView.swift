import SwiftUI

struct ToolsView: View {
    var EC = "Emergency Contact"
    var HCFLCM = "HCF & LCM"
    var algebra = "Algebra"
    var cal = "Calculator"
    var Ins = "Instruments"
    let tools = ["Emergency Contact","Instruments", "HCF & LCM", "Algebra","Calculator" ]
    @State var searchText = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 30) {
                        ForEach(searchResults, id: \.self) { tools in
                            NavigationLink(destination: getDestination(tools: tools)) {
                                VStack {
                                    Text(tools)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                        .background(getCardColor(for: tools))
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .frame(height: 150)
                        }
                    }
                    .padding()
                    Spacer()
                }
            }
            .navigationTitle("Tools")
            .searchable(text: $searchText)
        }
    }

    func getDestination(tools: String) -> AnyView {
        switch tools {
        case EC:
            return AnyView(EmergencyView())
        case HCFLCM:
            return AnyView(HCF_LCM_CalculatorView())
        case algebra:
            return AnyView(OCRView())
        case algebra:
            return AnyView(EmptyView())
        case Ins:
            return AnyView(
                List {
                    NavigationLink("Protractor", destination: EmptyView())
                    NavigationLink("Ruler", destination: EmptyView())
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }

    func getCardColor(for tools: String) -> Color {
        switch tools {
        case EC:
            return Color(.red)
        case HCFLCM:
            return Color(.blue)
        case algebra:
            return Color(.green)
        case Ins:
            return Color(.purple)
        case cal:
            return Color(.orange)
        default:
            return Color("CardBackground")
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.contains(searchText) }
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        ToolsView()
    }
}
