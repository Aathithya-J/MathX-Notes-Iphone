//
//  TrigoCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI
import LaTeXSwiftUI

struct PythagorasCalc: View {
    
    @State var pythagorasNumber1 = ""
    @State var pythagorasNumber2 = ""
    @State var pythagorasNumber3 = ""
    
    @FocusState var pyNum1Focused: Bool
    @FocusState var pyNum2Focused: Bool
    @FocusState var pyNum3Focused: Bool

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(uiColor: .systemBackground))
                .ignoresSafeArea()
                .onTapGesture {
                    pyNum1Focused = false
                    pyNum2Focused = false
                    pyNum3Focused = false
                }
            
            VStack {
                Form {
                    Section {
                        HStack {
                            Spacer()
                            Triangle()
                                .foregroundColor(.blue.opacity(0.7))
                                .frame(width: 128, height: 128)
                                .overlay(
                                    Text("A")
                                        .offset(y: 80)
                                )
                                .overlay(
                                    Text("B")
                                        .offset(x: 80)
                                )
                                .overlay(
                                    Text("C")
                                        .offset(x: -18, y: -15)
                                )
                                .padding()
                                .padding(.bottom)
                            Spacer()
                        }
                        ScrollView(.horizontal, showsIndicators: false) {
                            LaTeX("\(pythagorasNumber1.isEmpty ? "a" : pythagorasNumber1)^2 \(pythagorasNumber2.isEmpty ? "+" : Double(pythagorasNumber2) ?? 0 < 0 ? "-": "+") \(pythagorasNumber2.isEmpty ? "b" : String(abs(Double(pythagorasNumber2) ?? 0).formatted()))^2 = \(pythagorasNumber3.isEmpty ? "c" : String(abs(Double(pythagorasNumber3) ?? 0).formatted()))^2")
                                .parsingMode(.all)
                                .blockMode(.alwaysInline)
                                .lineLimit(1)
                        }
                    }
                    
                    Section {
                        TextField("Side A", text: $pythagorasNumber1)
                            .keyboardType(.decimalPad)
                            .focused($pyNum1Focused)
                        
                        TextField("Side B", text: $pythagorasNumber2)
                            .keyboardType(.decimalPad)
                            .focused($pyNum2Focused)
                        
                        TextField("Side C", text: $pythagorasNumber3)
                            .keyboardType(.decimalPad)
                            .focused($pyNum3Focused)
                    }
                    
                    Section {
                        if calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0) == "Leave at least 1 text field empty." {
                            Text("\(calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0))")
                        } else {
                            HStack {
                                Text("Unknown side:")
                                Spacer()
                                if fillCount(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0) > 1 {
                                    if calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0) != "NaN" {
                                        Text("\(calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0))")
                                            .multilineTextAlignment(.trailing)
                                    } else {
                                        Text("-")
                                            .multilineTextAlignment(.trailing)
                                    }
                                }
                            }
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
        }
        .navigationTitle("Pythagoras Calculator")
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
    
    func calculatePythagoras(num1: Double, num2: Double, num3: Double) -> String {
        var returnValue = ""
        var fillCount = fillCount(num1: num1, num2: num2, num3: num3)
        
        if fillCount > 2 {
            returnValue = "Leave at least 1 text field empty."
        } else if fillCount < 2 {
            returnValue = ""
        } else {
            if num3 > 0 {
                if num1 > 0 {
                    returnValue = "\(String(sqrt(pow(num3, 2) - pow(num1, 2)).formatted()))"
                } else {
                    returnValue = "\(String(sqrt(pow(num3, 2) - pow(num2, 2)).formatted()))"
                }
            } else {
                returnValue = "\(String(sqrt(pow(num1, 2) + pow(num2, 2)).formatted()))"
            }
        }
                
        return returnValue
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))

        return path
    }
}

struct PythagorasCalc_Previews: PreviewProvider {
    static var previews: some View {
        PythagorasCalc()
    }
}
