//
//  thirdButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct thirdButtonGroup: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var errorOccurred: Bool
    
    let generator = UIImpactFeedbackGenerator()
    
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                button(text: "7", isOrange: false, inputWhenPressed: "7")
                button(text: "8", isOrange: false, inputWhenPressed: "8")
                button(text: "9", isOrange: false, inputWhenPressed: "9")
                delButton()
                acButton()
                
            }
            .padding(.top, UIScreen.main.bounds.height / 50)
            
            HStack(spacing: 12) {
                button(text: "4", isOrange: false, inputWhenPressed: "4")
                button(text: "5", isOrange: false, inputWhenPressed: "5")
                button(text: "6", isOrange: false, inputWhenPressed: "6")
                button(text: "×", isOrange: false, inputWhenPressed: "×")
                button(text: "÷", isOrange: false, inputWhenPressed: "÷")
                
            }
            
            HStack(spacing: 12) {
                button(text: "1", isOrange: false, inputWhenPressed: "1")
                button(text: "2", isOrange: false, inputWhenPressed: "2")
                button(text: "3", isOrange: false, inputWhenPressed: "3")
                button(text: "+", isOrange: false, inputWhenPressed: "+")
                button(text: "-", isOrange: false, inputWhenPressed: "-")
            }
            
            HStack(spacing: 12) {
                button(text: "0", isOrange: false, inputWhenPressed: "0")
                button(text: ".", isOrange: false, inputWhenPressed: ".")
                button(text: "×10^{\u{1D465}}", isOrange: false, inputWhenPressed: "")
                button(text: "Ans", isOrange: false, inputWhenPressed: "Ans")
                equalsButton()
            }
        }
    }
    
    @ViewBuilder
    func button(text: String, isOrange: Bool, inputWhenPressed: String) -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if equationText != "" && resultsText != "" {
                if inputWhenPressed == "+" || inputWhenPressed == "-" || inputWhenPressed == "×" || inputWhenPressed == "÷" {
                    equationText = "Ans" + "\(inputWhenPressed)"
                } else {
                    equationText = "\(inputWhenPressed)"
                }
                resultsText = ""
            } else if equationText.contains("ERROR:") {
                errorOccurred = false
                
                equationText = "\(inputWhenPressed)"
                resultsText = ""
            } else {
                equationText = equationText + "\(inputWhenPressed)"
            }
        } label: {
            VStack {
                SubSuperScriptText(inputString: text, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(text == "DEL" || text == "AC" ? .black : .white)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 16)
                    .background(isOrange ? .orange : .black)
                    .cornerRadius(8)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func acButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if errorOccurred {
                errorOccurred = false
                equationText = lastEquation
                resultsText = ""
            } else {
                equationText = ""
                resultsText = ""
            }
        } label: {
            VStack {
                SubSuperScriptText(inputString: "AC", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 16)
                    .background(.orange)
                    .cornerRadius(8)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func delButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if equationText.contains("ERROR:") {
                errorOccurred = false
                
                equationText = ""
                resultsText = ""
            } else {
                if equationText.suffix(3) == "Ans" {
                    equationText = String(equationText.dropLast(3))
                    resultsText = ""
                } else {
                    equationText = String(equationText.dropLast())
                    resultsText = ""
                }
            }
        } label: {
            VStack {
                SubSuperScriptText(inputString: "DEL", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 16)
                    .background(.orange)
                    .cornerRadius(8)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func equalsButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if equationText.contains("ERROR:") {
                errorOccurred = false
                
                equationText = ""
                resultsText = ""
            } else {
                equalsPressed.toggle()
            }
        } label: {
            VStack {
                SubSuperScriptText(inputString: "=", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 16)
                    .background(.black)
                    .cornerRadius(8)
            }
        }
        .buttonStyle(.plain)
    }
}

struct thirdButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
