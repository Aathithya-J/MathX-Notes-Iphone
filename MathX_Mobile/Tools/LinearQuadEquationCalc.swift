//
//  LinearQuadEquationCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI
import LaTeXSwiftUI

struct LinearQuadEquationCalc: View {
    
    @State var quadcalculated = false
    
    @State var linearText = ""
    @State var quadraticaText = ""
    @State var quadraticbText = ""
    @State var quadraticcText = ""
    
    @State var yintercept = ""
    @State var discriminant = ""
    @State var quadxintercept1 = ""
    @State var quadxintercept2 = ""

    @State var gradient = ""
    
    @State var roots = ""
    @State var lineofsymmetry = ""
    @State var turningpoint = ""
    
    @State private var equationSelected = 1
    
    @FocusState var quadraticaTextFocused: Bool
    @FocusState var quadraticbTextFocused: Bool
    @FocusState var quadraticcTextFocused: Bool
    

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: .systemBackground))
                .ignoresSafeArea()
                .onTapGesture {
                    quadraticaTextFocused = false
                    quadraticbTextFocused = false
                    quadraticcTextFocused = false
                }
            VStack {
                //            Picker("", selection: $equationSelected) {
                //                Text("Linear Equation")
                //                    .tag(0)
                //                Text("Quadratic Equation")
                //                    .tag(1)
                //            }
                //            .pickerStyle(.segmented)
                                
                if equationSelected == 0 {
                    // linear
                    TextField("linear", text: $linearText)
                } else {
                    Form {
                        Section {
                            LaTeX("\(quadraticaText.isEmpty ? "a" : quadraticaText)x^2 \(quadraticbText.isEmpty ? "+" : Double(quadraticbText) ?? 0 < 0 ? "-": "+") \(quadraticbText.isEmpty ? "b" : String(abs(Double(quadraticbText) ?? 0).formatted()))x \(quadraticcText.isEmpty ? "+" : Double(quadraticcText) ?? 0 < 0 ? "-": "+") \(quadraticcText.isEmpty ? "c" : String(abs(Double(quadraticcText) ?? 0).formatted())) = 0")
                                .parsingMode(.all)
                                .blockMode(.alwaysInline)
                        }
                        
                        Section {
                            TextField("a", text: $quadraticaText)
                                .keyboardType(.decimalPad)
                                .focused($quadraticaTextFocused)
                            
                            TextField("b", text: $quadraticbText)
                                .keyboardType(.decimalPad)
                                .focused($quadraticbTextFocused)
                            
                            TextField("c", text: $quadraticcText)
                                .keyboardType(.decimalPad)
                                .focused($quadraticcTextFocused)
                        }
                        
                        Section {
                            HStack {
                                Text("y-intercept:")
                                Spacer()
                                if quadcalculated {
                                    Text("(0, \(yintercept))")
                                }
                            }
                            
                            if Double(discriminant.replacingOccurrences(of: ",", with: "")) ?? 0 < 0 {
                                HStack {
                                    Text("x-intercept:")
                                    Spacer()
                                    Text(quadcalculated ? "-" : "")
                                }
                            } else if Double(discriminant.replacingOccurrences(of: ",", with: "")) ?? 0 == 0 {
                                HStack {
                                    Text("x-intercept:")
                                    Spacer()
                                    if quadcalculated {
                                        Text("(\(quadxintercept1), 0)")
                                    }
                                }
                            } else {
                                HStack {
                                    Text("x-intercept 1:")
                                    Spacer()
                                    if quadcalculated {
                                        Text("(\(quadxintercept1), 0)")
                                    }
                                }
                                
                                HStack {
                                    Text("x-intercept 2:")
                                    Spacer()
                                    if quadcalculated {
                                        Text("(\(quadxintercept2), 0)")
                                    }
                                }
                            }
                            
                            HStack {
                                Text("Line of symmetry:")
                                Spacer()
                                Text("\(quadcalculated ? lineofsymmetry : "")")
                            }
                            
                            HStack {
                                Text("Turning point:")
                                Spacer()
                                Text("\(quadcalculated ? turningpoint : "")")
                            }
                            
                            HStack {
                                Text("Discriminant:")
                                Spacer()
                                Text("\(quadcalculated ? discriminant : "")")
                            }
                            
                            HStack {
                                Text("Number of roots:")
                                Spacer()
                                Text("\(quadcalculated ? roots : "")")
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onChange(of: quadraticaText) { _ in
                        if !quadraticaText.isEmpty && !quadraticbText.isEmpty && !quadraticcText.isEmpty {
                            calculateQuadEquation(
                                a: Double(quadraticaText) ?? 0,
                                b: Double(quadraticbText) ?? 0,
                                c: Double(quadraticcText) ?? 0
                            )
                            
                        }
                    }
                    .onChange(of: quadraticbText) { _ in
                        if !quadraticaText.isEmpty && !quadraticbText.isEmpty && !quadraticcText.isEmpty {
                            calculateQuadEquation(
                                a: Double(quadraticaText) ?? 0,
                                b: Double(quadraticbText) ?? 0,
                                c: Double(quadraticcText) ?? 0
                            )
                        }
                    }
                    .onChange(of: quadraticcText) { _ in
                        if !quadraticaText.isEmpty && !quadraticbText.isEmpty && !quadraticcText.isEmpty {
                            calculateQuadEquation(
                                a: Double(quadraticaText) ?? 0,
                                b: Double(quadraticbText) ?? 0,
                                c: Double(quadraticcText) ?? 0
                            )
                        }
                    }
                }
            }
            .navigationTitle("Quadratic Calculator")
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Button {
                            if quadraticaTextFocused {
                                if !quadraticaText.isEmpty {
                                    guard let quadadouble = Double(quadraticaText) else { return }
                                    quadraticaText = String((quadadouble * -1).formatted()).replacingOccurrences(of: ",", with: "")
                                }
                            } else if quadraticbTextFocused {
                                if !quadraticbText.isEmpty {
                                    guard let quadbdouble = Double(quadraticbText) else { return }
                                    quadraticbText = String((quadbdouble * -1).formatted()).replacingOccurrences(of: ",", with: "")
                                }
                            } else if quadraticcTextFocused {
                                if !quadraticcText.isEmpty {
                                    guard let quadcdouble = Double(quadraticcText) else { return }
                                    quadraticcText = String((quadcdouble * -1).formatted()).replacingOccurrences(of: ",", with: "")
                                }
                            }
                        } label: {
                            Text("Negative")
                        }
                        Spacer()
                    }
                }
            }
        }
    }
    
    func calculateQuadEquation(a: Double, b: Double, c: Double) {
        yintercept = ""
        turningpoint = ""
        lineofsymmetry = ""
        discriminant = ""
        quadxintercept1 = ""
        quadxintercept2 = ""

        // y intercept
        yintercept = String(c.formatted())
        
        // roots
        let discriminant = (pow(b, 2)) - (4*a*c)
        
        var quadxintercept1 = Double()
        var quadxintercept2 = Double()
        
        if discriminant >= 0 {
            // x intercept(s)
            if discriminant == 0 {
                quadxintercept1 = ((-1*b) + (sqrt(pow(b, 2) - (4*a*c)))) / (2*a)
            } else {
                quadxintercept1 = ((-1*b) + (sqrt(pow(b, 2) - (4*a*c)))) / (2*a)
                quadxintercept2 = ((-1*b) - (sqrt(pow(b, 2) - (4*a*c)))) / (2*a)
            }
        }
        
        // line of symmetry
        let los = (-1*b) / (2*a)
        
        // turning point
        let turningpointy = a*pow(los, 2) + b*los + c

        self.quadxintercept1 = String(quadxintercept1.formatted())
        self.quadxintercept2 = String(quadxintercept2.formatted())
        self.discriminant = String(discriminant.formatted())
        self.lineofsymmetry = "x = \(String(los.formatted()))"
        self.turningpoint = "(\(String(los.formatted())), \(String(turningpointy.formatted())))"
        self.roots = discriminant < 0 ? "0" : discriminant == 0 ? "1" : "2"
        
        quadcalculated = true
    }
}

struct LinearQuadEquationCalc_Previews: PreviewProvider {
    static var previews: some View {
        LinearQuadEquationCalc()
    }
}
