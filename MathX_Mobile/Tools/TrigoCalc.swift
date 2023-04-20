//
//  TrigoCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import SwiftUI
import LaTeXSwiftUI

struct TrigoCalc: View {
    
    @State var sideA = ""
    @State var sideB = ""
    @State var sideC = ""

    @State var results = ""
    @State var equation = ""

    var body: some View {
        VStack {
            Spacer()
            
            Triangle()
                .foregroundColor(.blue.opacity(0.7))
                .frame(width: 128, height: 128)
                .overlay(
                    Text("A (O)")
                        .offset(y: 80)
                )
                .overlay(
                    Text("B (A)")
                        .offset(x: 90)
                )
                .overlay(
                    Text("C (H)")
                        .offset(x: -18, y: -15)
                )
                .overlay(
                    Text("x")
                        .offset(x: 50, y: -30)
                )
                .padding(.bottom, 45)
            
            LaTeX(equation)
                .parsingMode(.all)
                .blockMode(.alwaysInline)
            
            TextField("Side A", text: $sideA)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            TextField("Side B", text: $sideB)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            TextField("Side C", text: $sideC)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
                .padding(.bottom)
            
            Text("\(results)")
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Trigonometry Calculator")
        .onChange(of: sideA) { _ in
            results = findAngleX()
        }
        .onChange(of: sideB) { _ in
                results = findAngleX()
        }
        .onChange(of: sideC) { _ in
            results = findAngleX()
        }
    }
    
    func findAngleX() -> String {
        
        var returnValue = ""
        var filledFields = 0
        
        var h = Double()
        var a = Double()
        var o = Double()
        
        if !sideA.isEmpty {
            filledFields += 1
        }
        if !sideB.isEmpty {
            filledFields += 1
        }
        if !sideC.isEmpty {
            filledFields += 1
        }
        
        if filledFields > 2 {
            equation = ""
            returnValue = "Leave at least 1 text field empty."
        } else if filledFields < 2 {
            equation = ""
            returnValue = ""
        } else {
            h = Double(sideC) ?? 0
            a = Double(sideB) ?? 0
            o = Double(sideA) ?? 0
            
            if sideC.isEmpty {
                // TOA
                equation = "tan^-1\\frac{\(o.formatted())}{\(a.formatted())}"
                returnValue = "x = \(String(atan(o/a).formatted()))"
            } else if sideB.isEmpty {
                // SOH
                equation = "sin^-1\\frac{\(o.formatted())}{\(h.formatted())}"
                returnValue = "x = \(String(asin(o/h).formatted()))"
            } else {
                // CAH
                equation = "cos^-1\\frac{\(a.formatted())}{\(h.formatted())}"
                returnValue = "x = \(String(acos(a/h).formatted()))"
            }
        }
        
        return returnValue
    }
}

struct TrigoCalc_Previews: PreviewProvider {
    static var previews: some View {
        TrigoCalc()
    }
}