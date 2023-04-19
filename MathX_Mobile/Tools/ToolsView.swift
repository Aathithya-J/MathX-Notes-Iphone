import SwiftUI

struct ToolsView: View {
    var algebra = "Algebra"
    var cal = "Calculators"
    var measure = "Measurements"
    var grapher = "Grapher (Desmos)"
    let tools = ["Measurements", "Algebra", "Calculators", "Grapher (Desmos)"]
    @State var searchText = ""
    
    @State var defaultReturn = false
    @State var isInsShowing = false
    @State var isAlgebraShowing = false
    @State var isGrapherShowing = false
    @Binding var isCalListShowing: Bool
    @Binding var isCalShowing: Bool

    @Binding var deepLinkSource: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 30) {
                        ForEach(searchResults, id: \.self) { tools in
                            NavigationLink(destination: getDestination(tools: tools), isActive: getIsActiveBool(tools: tools)) {
                                VStack {
                                    Text(tools)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                        .background(getCardColor(for: tools).opacity(0.7))
                                        .cornerRadius(16)
//                                        .shadow(radius: 5)
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
        case grapher:
            return AnyView(GrapherView())
        case algebra:
            return AnyView(OCRView())
        case cal:
            return AnyView(
                List {
                    NavigationLink("Calculator", destination: CalculatorView(deepLinkSource: $deepLinkSource), isActive: $isCalShowing)
                    NavigationLink("HCF/LCM Calculator", destination: HCF_LCM_CalculatorView())
                    NavigationLink("Pythagoras Calculator", destination: PythagorasCalc())
                    NavigationLink("Quadratic Equation Calculator", destination: LinearQuadEquationCalc())
                }
                .navigationTitle("Calculators")
            )
        case measure:
            return AnyView(
                List {
                    NavigationLink("Protractor", destination: EmptyView())
                    NavigationLink("Ruler", destination: EmptyView())
                }
                    .navigationTitle("Measurements")
            )
        default:
            return AnyView(EmptyView())
        }
    }

    func getCardColor(for tools: String) -> Color {
        switch tools {
        case grapher:
            return Color.green
        case algebra:
            return Color.blue
        case measure:
            return Color.purple
        case cal:
            return Color.orange
        default:
            return Color("CardBackground")
        }
    }
    
    func getIsActiveBool(tools: String) -> Binding<Bool> {
        switch tools {
        case grapher:
            return $isGrapherShowing
        case algebra:
            return $isAlgebraShowing
        case measure:
            return $isInsShowing
        case cal:
            return $isCalListShowing
        default:
            return $defaultReturn
        }
    }

    var searchResults: [String] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("ToolsView()")
    }
}
