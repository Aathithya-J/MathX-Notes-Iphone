import SwiftUI

let MathXTools: [Tool] = [
    .init(name: "Calculators", color: .orange),
    .init(name: "Grapher (Desmos)", color: .green),
//        .init(name: "Measurements", color: .purple), // likely to come as a future update as ruler and protractor still dont work
    .init(name: "Randomise", color: .red),
    .init(name: "Unit Converter", color: .blue)
]

let MathXCalculatorTools: [CalculatorTool] = [
    .init(name: "Calculator"),
    .init(name: "Average Calculator"),
    .init(name: "HCF/LCM Calculator"),
    .init(name: "Pythagoras Calculator"),
    .init(name: "Quadratic Calculator"),
    .init(name: "Set Calculator"),
    .init(name: "Shapes Calculator"),
    .init(name: "Trigonometry Calculator")
]

struct Tool: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var color: Color
}

struct CalculatorTool: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct ToolsView: View {
    
    let tools: [Tool] = MathXTools
    
    @State var searchText = ""
    
    @Binding var deepLinkSource: String
    @Binding var path: NavigationPath
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 30) {
                        ForEach(searchResults, id: \.self) { tool in
                            NavigationLink(value: tool) {
                                VStack {
                                    Text(tool.name)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                        .background(tool.color.opacity(0.7))
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
            .navigationDestination(for: Tool.self) { tool in
                getDestination(for: tool.name)
            }
            .navigationDestination(for: CalculatorTool.self) { tool in
                getCalculatorDestination(for: tool.name)
            }
        }
    }
    
    func getCalculatorDestination(for tool: String) -> AnyView {
        switch tool {
        case "Calculator":
            return AnyView(CalculatorView(path: $path, deepLinkSource: $deepLinkSource))
        case "Average Calculator":
            return AnyView(AverageCalc())
        case "HCF/LCM Calculator":
            return AnyView(HCF_LCM_CalculatorView(lhsNumber: 0, rhsNumber: 0))
        case "Pythagoras Calculator":
            return AnyView(PythagorasCalc())
        case "Quadratic Calculator":
            return AnyView(LinearQuadEquationCalc())
        case "Set Calculator":
            return AnyView(SetsCalc())
        case "Shapes Calculator":
            return AnyView(ShapesCalc())
        case "Trigonometry Calculator":
            return AnyView(TrigoCalc())
        default:
            return AnyView(EmptyView())
        }
    }

    func getDestination(for tools: String) -> AnyView {
        switch tools {
        case "Unit Converter":
            return AnyView(UnitConverterView())
        case "Randomis":
            return AnyView(RandView())
        case "Grapher (Desmos)":
            return AnyView(GrapherView())
        case "Algebra":
            return AnyView(OCRView())
        case "Calculators":
            return AnyView(CalculatorSelectionView())
        case "Measurements":
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

    var searchResults: [Tool] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct CalculatorSelectionView: View {
    
    let tools: [CalculatorTool] = MathXCalculatorTools
    
    @State var searchText = String()
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Calculator")) {
                    ForEach(searchResults) { tool in
                        if tool.name == "Calculator" {
                            NavigationLink(value: tool) {
                                Text(tool.name)
                            }
                        }
                    }
                }
                Section(header: Text("Other Calculators")) {
                    ForEach(searchResults) { tool in
                        if tool.name != "Calculator" {
                            NavigationLink(value: tool) {
                                Text(tool.name)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Calculators")
        }
        .searchable(text: $searchText)
    }
    
    var searchResults: [CalculatorTool] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct ToolsView_Previews: PreviewProvider {
    static var previews: some View {
        Text("ToolsView()")
    }
}
