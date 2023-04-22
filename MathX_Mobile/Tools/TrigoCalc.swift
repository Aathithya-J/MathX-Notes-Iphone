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
    
    @State var angleUnitSelection = 0
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
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
                                LaTeX("\\[x\\]°")
                                    .offset(x: 50, y: -30)
                                    .parsingMode(.onlyEquations)
                                    .blockMode(.alwaysInline)
                            )
                            .padding()
                            .padding(.bottom)
                        Spacer()
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        if fillCount(num1: Double(sideA) ?? 0, num2: Double(sideB) ?? 0, num3: Double(sideC) ?? 0) > 1 {
                            LaTeX("\\[x\\]° = \\[\(equation)\\]")
                                .parsingMode(.onlyEquations)
                                .blockMode(.alwaysInline)
                        } else {
                            LaTeX("\\[x\\]° =")
                                .parsingMode(.onlyEquations)
                                .blockMode(.alwaysInline)
                        }
                    }
                }
                
                Section(footer: Text("If all 3 sides are filled up, MathX will default to whichever operation first returns a value, following the order: Sine, Cosine, then Tangent.")) {
                    Picker("", selection: $angleUnitSelection) {
                        Text("Degrees")
                            .tag(0)
                        Text("Radians")
                            .tag(1)
                    }
                    .pickerStyle(.segmented)
                    
                    TextField("Side A (Opposite)", text: $sideA)
                        .keyboardType(.decimalPad)
                    
                    TextField("Side B (Adjacent)", text: $sideB)
                        .keyboardType(.decimalPad)
                    
                    TextField("Side C (Hypotenuse)", text: $sideC)
                        .keyboardType(.decimalPad)
                }
                
                Section {
                    HStack {
                        LaTeX("\\[x\\]° =")
                            .parsingMode(.onlyEquations)
                            .blockMode(.alwaysInline)
                        Spacer()
                        
                        if fillCount(num1: Double(sideA) ?? 0, num2: Double(sideB) ?? 0, num3: Double(sideC) ?? 0) > 1 {
                            if results != "NaN" {
                                Text("\(results)°")
                                    .multilineTextAlignment(.trailing)
                            } else {
                                Text("-")
                                    .multilineTextAlignment(.trailing)
                            }
                        }
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
        }
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
        .onChange(of: angleUnitSelection) { _ in
            results = findAngleX()
        }
        
    }
    
    func fillCount(num1: Double, num2: Double, num3: Double) -> Int {
        var fillCount = 0
        
        if num1 > 0 {
            fillCount += 1
        }
        if num2 > 0 {
            fillCount += 1
        }
        if num3 > 0 {
            fillCount += 1
        }
        
        return fillCount
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
        
        if filledFields < 2 {
            equation = ""
            returnValue = ""
        } else {
            h = Double(sideC) ?? 0
            a = Double(sideB) ?? 0
            o = Double(sideA) ?? 0
            
            if filledFields < 3 {
                // 2 textfields filled up
                if sideC.isEmpty {
                    // TOA
                    equation = "tan^-1\\frac{\(o.formatted())}{\(a.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((atan(o/a) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((atan(o/a)).formatted()))"
                    }
                } else if sideA.isEmpty {
                    // CAH
                    equation = "cos^-1\\frac{\(a.formatted())}{\(h.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((acos(a/h) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((acos(a/h)).formatted()))"
                    }
                } else {
                    // SOH
                    equation = "sin^-1\\frac{\(o.formatted())}{\(h.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((asin(o/h) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((asin(o/h)).formatted()))"
                    }
                }
            } else {
                // all 3 textfields filled up
                if "\(String(asin(o/h).formatted()))" != "NaN" {
                    // SOH
                    equation = "sin^-1\\frac{\(o.formatted())}{\(h.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((asin(o/h) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((asin(o/h)).formatted()))"
                    }
                } else if "\(String(acos(a/h).formatted()))" != "NaN" {
                    // CAH
                    equation = "cos^-1\\frac{\(a.formatted())}{\(h.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((acos(a/h) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((acos(a/h)).formatted()))"
                    }
                } else if "\(String(atan(o/a).formatted()))" != "NaN" {
                    // TOA
                    equation = "tan^-1\\frac{\(o.formatted())}{\(a.formatted())}"
                    if angleUnitSelection == 0 {
                        returnValue = "\(String((atan(o/a) * 180 / .pi).formatted()))"
                    } else {
                        returnValue = "\(String((atan(o/a)).formatted()))"
                    }
                }
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
