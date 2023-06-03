//
//  FormulasView.swift
//  MathX_Mobile
//
//  Created by Tristan on 06/05/2023.
//

import SwiftUI
import Equation

struct FormulasView: View {
    
    @State var viewSelection = 0
    
    @State var formula: EquationGroup = .vir
    @State var firstValue: Double = 0
    @State var secondValue: Double = 0

    @State var unitTarget: SolveTarget = .top(0)

    @Namespace var namespace

    @State var numbers: [EquationUnit: Int] = [:]

    // TODO: Persistence
    @State var renderMethod: EquationRenderMethod = .equals

    enum EquationRenderMethod {
        case triangle, equals
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    switch renderMethod {
                    case .triangle:
                        EquationTriangleView(equation: formula, selected: $unitTarget)
                            .frame(height: 170)
                    case .equals:
                        EquationEqualView(equation: formula, selected: $unitTarget)
                            .frame(height: 170)
                    }
                    Spacer()
                }
                
                HStack {
                    Picker("", selection: $viewSelection) {
                        Text("In relation")
                            .tag(0)
                        Text("Triangle")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: viewSelection) { newValue in
                        withAnimation {
                            switch renderMethod {
                            case .triangle:
                                renderMethod = .equals
                            case .equals:
                                renderMethod = .triangle
                            }
                        }
                    }
                    
                    Menu {
                        ForEach(EquationGroup.allEquations, id: \.description) { equation in
                            Button(equation.description) {
                                withAnimation {
                                    formula = equation
                                }
                            }
                        }
                    } label: {
                        Text(formula.description)
                            .minimumScaleFactor(0.1)
                    }
                    .fixedSize()
                }
            } header: {
                Text("Formula")
            }
            
            Section {
                ForEach(formula.flatUnits, id: \.1) { unit, role in
                    if unitTarget != role {
                        viewForUnit(unit: unit)
                    }
                }
            } header: {
                Text("Inputs")
            }

            Section {
                viewForUnit(unit: formula[unitTarget], computed: true)
            } header: {
                Text("Results")
            }
        }
        .navigationTitle("Formulas")
    }
    
    func viewForUnit(unit: EquationUnit, computed: Bool = false) -> some View {
        HStack {
            Text(unit.unitPurpose)
            if computed {
                Spacer()
                Text(String(format: "%.2f", result()))
            } else {
                TextField(unit.unitName, value: .init(get: {
                    numbers[unit] ?? 0
                }, set: { newValue in
                    numbers[unit] = newValue
                }), formatter: NumberFormatter())
                .multilineTextAlignment(.trailing)
            }
            UnitTextView(unit.unitSymbol, font: .system(.body, design: .serif))
        }
        .matchedGeometryEffect(id: unit.id, in: namespace)
    }

    func result() -> Double {
        let values = numbers.map({ ($0, Double($1)) })
        return formula.solve(target: unitTarget,
                             values: .init(uniqueKeysWithValues: values))
    }
}

struct FormulasView_Previews: PreviewProvider {
    static var previews: some View {
        FormulasView()
    }
}
