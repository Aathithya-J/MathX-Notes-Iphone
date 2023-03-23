//
//  secondButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct secondButtonGroup: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var errorOccurred: Bool
        
    var body: some View {
        VStack {
            HStack {
                button(buttonSymbol: "OPT", inputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{3}", inputWhenPressed: "")
                
                ForEach(1...2, id: \.self) { _ in
                    Text("")
                        .frame(width: UIScreen.main.bounds.width / 7)
                        .frame(height: UIScreen.main.bounds.height / 20)
                }
                
                button(buttonSymbol: "Abs", inputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}!", inputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)
            
            
            HStack {
                button(buttonSymbol: "\u{00BD}", inputWhenPressed: "")
                button(buttonSymbol: "√", inputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{2}", inputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{□}", inputWhenPressed: "")
                button(buttonSymbol: "log", inputWhenPressed: "")
                button(buttonSymbol: "ln", inputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

            
            HStack {
                button(buttonSymbol: "-", inputWhenPressed: "-")
                button(buttonSymbol: "° ’ ”", inputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{-1}", inputWhenPressed: "")
                button(buttonSymbol: "sin", inputWhenPressed: "")
                button(buttonSymbol: "cos", inputWhenPressed: "")
                button(buttonSymbol: "tan", inputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

            
            HStack {
                button(buttonSymbol: "STO", inputWhenPressed: "")
                button(buttonSymbol: "ENG", inputWhenPressed: "")
                button(buttonSymbol: "(", inputWhenPressed: "(")
                button(buttonSymbol: ")", inputWhenPressed: ")")
                button(buttonSymbol: "S\u{21D4}D", inputWhenPressed: "")
                button(buttonSymbol: "M+", inputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

        }
    }
    
    @ViewBuilder
    func button(buttonSymbol: String, inputWhenPressed: String) -> some View {
        VStack {
            Button {
                if equationText != "" && resultsText != "" {
                    equationText = "Ans" + "\(inputWhenPressed)"
                    resultsText = ""
                } else if equationText.contains("ERROR:") {
                    errorOccurred = false
                    
                    equationText = "\(inputWhenPressed)"
                    resultsText = ""
                } else {
                    equationText = equationText + "\(inputWhenPressed)"
                }
            } label: {
                SubSuperScriptText(inputString: buttonSymbol, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width / 7)
                    .frame(height: UIScreen.main.bounds.height / 20)
                    .background(.black)
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
        }
    }
}



struct secondButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
