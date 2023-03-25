//
//  thirdButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct thirdButtonGroup: View {
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool

    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var errorOccurred: Bool
    
    let generator = UIImpactFeedbackGenerator()
    
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                button(buttonSymbol: "7", inputWhenPressed: "7", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "8", inputWhenPressed: "8", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "9", inputWhenPressed: "9", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                delButton()
                acButton()
                
            }
            .padding(.top, UIScreen.main.bounds.height / 50)
            
            HStack(spacing: 12) {
                button(buttonSymbol: "4", inputWhenPressed: "4", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "5", inputWhenPressed: "5", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "6", inputWhenPressed: "6", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "×", inputWhenPressed: "×", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "÷", inputWhenPressed: "÷", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                
            }
            
            HStack(spacing: 12) {
                button(buttonSymbol: "1", inputWhenPressed: "1", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "2", inputWhenPressed: "2", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "3", inputWhenPressed: "3", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "+", inputWhenPressed: "+", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "-", inputWhenPressed: "-", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
            }
            
            HStack(spacing: 12) {
                button(buttonSymbol: "0", inputWhenPressed: "0", shiftButtonSymbol: "Rnd", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: ".", inputWhenPressed: ".", shiftButtonSymbol: "Ran#", shiftInputWhenPressed: "", alphaButtonSymbol: "RanInt", alphaInputWhenPressed: "")
                button(buttonSymbol: "×10^{\u{1D465}}", inputWhenPressed: "", shiftButtonSymbol: "π", shiftInputWhenPressed: "", alphaButtonSymbol: "e", alphaInputWhenPressed: "e")
                button(buttonSymbol: "Ans", inputWhenPressed: "Ans", shiftButtonSymbol: "%", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                equalsButton()
            }
        }
    }
    
    @ViewBuilder
    func button(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
                        
            if equationText != "" && resultsText != "" {
                if inputWhenPressed == "+" || inputWhenPressed == "-" || inputWhenPressed == "×" || inputWhenPressed == "÷" {
                    equationText = "Ans" + "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                } else {
                    equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                }
                resultsText = ""
            } else if equationText.contains("ERROR:") {
                errorOccurred = false
                
                equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                resultsText = ""
            } else {
                equationText = equationText + "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
            }
            
            shiftIndicator = false
            alphaIndicator = false
        } label: {
            VStack {
                SubSuperScriptText(inputString: shiftIndicator ? shiftButtonSymbol : alphaIndicator ? alphaButtonSymbol : buttonSymbol, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(shiftIndicator ? .yellow : alphaIndicator ? .red : .white)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 16)
                    .background(.black)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
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
            
            shiftIndicator = false
            alphaIndicator = false
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
            
            shiftIndicator = false
            alphaIndicator = false
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
            
            shiftIndicator = false
            alphaIndicator = false
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
                    .minimumScaleFactor(0.1)
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
