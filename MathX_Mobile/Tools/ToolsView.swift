import SwiftUI

struct ToolsView: View {
    var algebra = "Algebra"
    var cal = "Calculators"
    var measure = "Measurements"
    var grapher = "Grapher (Desmos)"
    var rand = "Randomise"
    var unit = "Unit Converter"
    let tools = [
        "Calculators",
        "Grapher (Desmos)",
//        "Measurements", // likely to come as a future update as ruler and protractor still dont work
        "Randomise",
        "Unit Converter"
    ]
    @State var searchText = ""
    
    @State var defaultReturn = false
    @State var isInsShowing = false
    @State var isAlgebraShowing = false
    @State var isGrapherShowing = false
    @State var isRandShowing = false
    @State var isUnitShowing = false
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
                                }
                                .shadow(color: .black.opacity(0.4), radius: 2, x: 3, y: 3)
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
        case unit:
            return AnyView(UnitConverterView())
        case rand:
            return AnyView(RandView())
        case grapher:
            return AnyView(GrapherView())
        case algebra:
            return AnyView(OCRView())
        case cal:
            return AnyView(
                List {
                    Section(header: Text("Calculator")) {
                        NavigationLink("Calculator", destination: CalculatorView(isCalShowing: $isCalShowing, deepLinkSource: $deepLinkSource), isActive: $isCalShowing)
                    }
                    
                    Section(header: Text("Other Calculators")) {
                        NavigationLink("Average Calculator", destination: AverageCalc())
                        NavigationLink("HCF/LCM Calculator", destination: HCF_LCM_CalculatorView(lhsNumber: 0, rhsNumber: 0))
                        NavigationLink("Pythagoras Calculator", destination: PythagorasCalc())
                        NavigationLink("Quadratic Calculator", destination: LinearQuadEquationCalc())
                        NavigationLink("Set Calculator", destination: SetsCalc())
                        NavigationLink("Trigonometry Calculator", destination: TrigoCalc())
                        NavigationLink("Shapes Calculator", destination: ShapesCalc())
                    }
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
        case rand:
            return Color.red
        case grapher:
            return Color.green
        case algebra:
            return Color.blue
        case measure:
            return Color.purple
        case cal:
            return Color.orange
        case unit:
            return Color.blue
        default:
            return Color("CardBackground")
        }
    }
    
    func getIsActiveBool(tools: String) -> Binding<Bool> {
        switch tools {
        case rand:
            return $isRandShowing
        case grapher:
            return $isGrapherShowing
        case algebra:
            return $isAlgebraShowing
        case measure:
            return $isInsShowing
        case unit:
            return $isUnitShowing
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
