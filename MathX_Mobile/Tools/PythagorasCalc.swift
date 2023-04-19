//
//  TrigoCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI

struct PythagorasCalc: View {
    
    @State var pythagorasNumber1 = ""
    @State var pythagorasNumber2 = ""
    @State var pythagorasNumber3 = ""

    var body: some View {
        VStack {
            Spacer()
            
            TextField("Side A", text: $pythagorasNumber1)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            TextField("Side B", text: $pythagorasNumber2)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            TextField("Side C", text: $pythagorasNumber3)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
                .padding(.bottom)
            
            Text("\(calculatePythagoras(num1: Double(pythagorasNumber1) ?? 0, num2: Double(pythagorasNumber2) ?? 0, num3: Double(pythagorasNumber3) ?? 0))")
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
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
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Pythagoras Calculator")
    }
    
    func calculatePythagoras(num1: Double, num2: Double, num3: Double) -> String {
        var returnValue = ""
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
        
        if fillCount > 2 {
            returnValue = "Leave at least 1 text field empty."
        } else if fillCount < 2 {
            returnValue = ""
        } else {
            if num3 > 0 {
                if num1 > 0 {
                    returnValue = "Unknown side: \(String(sqrt(pow(num3, 2) - pow(num1, 2)).formatted()))"
                } else {
                    returnValue = "Unknown side: \(String(sqrt(pow(num3, 2) - pow(num2, 2)).formatted()))"
                }
            } else {
                returnValue = "Unknown side: \(String(sqrt(pow(num1, 2) + pow(num2, 2)).formatted()))"
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
