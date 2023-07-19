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
                                Text("A")
                                    .font(.system(size: 17))
                                    .offset(y: 80)
                            )
                            .overlay(
                                Text("B")
                                    .font(.system(size: 17))
                                    .offset(x: 80)
                            )
                            .overlay(
                                Text("C")
                                    .font(.system(size: 17))
                                    .offset(x: -18, y: -15)
                            )
                            .padding()
                            .padding(.bottom)
                        Spacer()
                    }
                    ScrollView(.horizontal, showsIndicators: false) {
                        let calculatedPyth = calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0)
                        
                        if calculatedPyth == "Leave at least 1 text field empty." || calculatedPyth == "The hypotenuse (Side C) has to be the largest number." {
                            LaTeX("a^2 + b^2 = c^2")
                                .parsingMode(.all)
                                .blockMode(.alwaysInline)
                                .lineLimit(1)
                        } else {
                            LaTeX("\(pythagorasNumber1.isEmpty ? "a" : pythagorasNumber1)^2 \(pythagorasNumber2.isEmpty ? "+" : Double(pythagorasNumber2) ?? 0 < 0 ? "-": "+") \(pythagorasNumber2.isEmpty ? "b" : String(abs(Double(pythagorasNumber2) ?? 0).formatted()))^2 = \(pythagorasNumber3.isEmpty ? "c" : String(abs(Double(pythagorasNumber3) ?? 0).formatted()))^2")
                                .parsingMode(.all)
                                .blockMode(.alwaysInline)
                                .lineLimit(1)
                        }
                    }
                }
                
                Section {
                    TextField("Side A", text: $pythagorasNumber1)
                        .keyboardType(.decimalPad)
                    
                    TextField("Side B", text: $pythagorasNumber2)
                        .keyboardType(.decimalPad)
                    
                    TextField("Side C", text: $pythagorasNumber3)
                        .keyboardType(.decimalPad)
                }
                
                Section(header: Text("Results")) {
                    let calculatedPyth = calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0)
                    
                    if calculatedPyth == "Leave at least 1 text field empty." || calculatedPyth == "The hypotenuse (Side C) has to be the largest number." {
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
        let fillCount = fillCount(num1: num1, num2: num2, num3: num3)
        
        if fillCount > 2 {
            returnValue = "Leave at least 1 text field empty."
        } else if fillCount < 2 {
            returnValue = ""
        } else {
            if num3 > 0 {
                if num3 <= num1 || num3 <= num2 {
                    returnValue = "The hypotenuse (Side C) has to be the largest number."
                } else {
                    if num1 > 0 {
                        returnValue = "\(String(sqrt(pow(num3, 2) - pow(num1, 2)).formatted()))"
                    } else {
                        returnValue = "\(String(sqrt(pow(num3, 2) - pow(num2, 2)).formatted()))"
                    }
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
