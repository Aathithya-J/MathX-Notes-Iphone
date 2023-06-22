import SwiftUI

let MathXTools: [Tool] = [
    .init(name: "Calculators", color: .orange),
    .init(name: "Grapher (Desmos)", color: .green),
//        .init(name: "Measurements", color: .purple), // likely to come as a future update as ruler and protractor still dont work
    .init(name: "Randomise", color: .red),
    .init(name: "Converters", color: .blue),
]

let MathXCalculatorTools: [SubTool] = [
    .init(name: "Calculator"),
    .init(name: "Average Calculator"),
    .init(name: "HCF/LCM Calculator"),
    .init(name: "Pythagoras Calculator"),
    .init(name: "Quadratic Calculator"),
    .init(name: "Set Calculator"),
    .init(name: "Shapes Calculator"),
    .init(name: "Trigonometry Calculator"),
]

let MathXConverterTools: [SubTool] = [
    .init(name: "Binary Converter"),
    .init(name: "Unit Converter")
]

struct Tool: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var color: Color
}

struct SubTool: Identifiable, Hashable {
    var id = UUID()
    var name: String
}

struct ToolsView: View {
    
    let tools: [Tool] = MathXTools
    
    @State var searchText = ""
    
    @Binding var calculatorDeepLinkSource: String
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
                                        .minimumScaleFactor(0.1)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .padding()
                                        .background(tool.color.opacity(0.7).gradient)
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
            .navigationDestination(for: SubTool.self) { tool in
                getSubToolsDestination(for: tool.name)
            }
        }
    }
    
    func getSubToolsDestination(for tool: String) -> AnyView {
        switch tool {
        case "Calculator":
            return AnyView(CalculatorView(path: $path, calculatorDeepLinkSource: $calculatorDeepLinkSource))
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
            
        case "Unit Converter":
            return AnyView(UnitConverterView())
        case "Binary Converter":
            return AnyView(BinaryConverter())
        default:
            return AnyView(EmptyView())
        }
    }

    func getDestination(for tools: String) -> AnyView {
        switch tools {
        case "Converters":
            return AnyView(ConverterSelectionView())
        case "Randomise":
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
    
    let tools: [SubTool] = MathXCalculatorTools
    
    @State var searchText = String()
    
    var body: some View {
        VStack {
            Form {
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
//        .searchable(text: $searchText)
    }
    
    var searchResults: [SubTool] {
        if searchText.isEmpty {
            return tools
        } else {
            return tools.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct ConverterSelectionView: View {
    
    let tools: [SubTool] = MathXConverterTools
    
    @State var searchText = String()
    
    var body: some View {
        VStack {
            Form {
                ForEach(searchResults) { tool in
                    NavigationLink(value: tool) {
                        Text(tool.name)
                    }
                }
            }
            .navigationTitle("Converters")
        }
//        .searchable(text: $searchText)
    }
    
    var searchResults: [SubTool] {
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
