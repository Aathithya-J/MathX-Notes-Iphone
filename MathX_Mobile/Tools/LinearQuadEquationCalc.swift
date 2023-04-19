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
    
    var body: some View {
        VStack {
//            Picker("", selection: $equationSelected) {
//                Text("Linear Equation")
//                    .tag(0)
//                Text("Quadratic Equation")
//                    .tag(1)
//            }
//            .pickerStyle(.segmented)
            
            Spacer()
            
            if equationSelected == 0 {
                // linear
                
                TextField("linear", text: $linearText)
            } else {
                if quadcalculated {
                    VStack(alignment: .leading) {
                        Text("y-intercept: (0, \(yintercept))")
                        Text("discriminant: \(discriminant)")
                        Text("number of roots: \(roots)")
                        
                        if Double(discriminant) ?? 0 < 0 {
                            Text("x-intercept: NaN")
                        } else if Double(discriminant) ?? 0 == 0 {
                            Text("x-intercept: (\(quadxintercept1), 0)")
                        } else {
                            Text("x-intercept 1: (\(quadxintercept1), 0)")
                            Text("x-intercept 2: (\(quadxintercept2), 0)")
                        }
                        
                        Text("line of symmetry: \(lineofsymmetry)")
                        Text("turning point: \(turningpoint)")
                    }
                    .padding(.bottom)
                }
                
                LaTeX("\(quadraticaText.isEmpty ? "a" : quadraticaText)x^2 \(quadraticbText.isEmpty ? "+" : Double(quadraticbText) ?? 0 < 0 ? "-": "+") \(quadraticbText.isEmpty ? "b" : String(abs(Double(quadraticbText) ?? 0).formatted()))x \(quadraticcText.isEmpty ? "+" : Double(quadraticcText) ?? 0 < 0 ? "-": "+") \(quadraticcText.isEmpty ? "c" : String(abs(Double(quadraticcText) ?? 0).formatted())) = 0")
                    .parsingMode(.all)
                    .blockMode(.alwaysInline)
                
                VStack {
                    TextField("a", text: $quadraticaText)
                        .keyboardType(.numbersAndPunctuation)
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                    TextField("b", text: $quadraticbText)
                        .keyboardType(.numbersAndPunctuation)
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                    TextField("c", text: $quadraticcText)
                        .keyboardType(.numbersAndPunctuation)
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                    
                    Button {
                        calculateQuadEquation(
                            a: Double(quadraticaText) ?? 0,
                            b: Double(quadraticbText) ?? 0,
                            c: Double(quadraticcText) ?? 0
                        )
                    } label: {
                        Text("Calculate")
                            .padding()
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                            .background(.blue)
                            .cornerRadius(16)
                    }
                    .buttonStyle(.plain)
                    .disabled(quadraticaText.isEmpty || quadraticbText.isEmpty || quadraticcText.isEmpty)
                }
                .padding(.top)
            }
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Quadratic Equation Calculator")
        .navigationBarTitleDisplayMode(.inline)
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
