//
//  secondButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct secondButtonGroup: View {
    var body: some View {
        VStack {
            HStack() {
                button(text: "OPT")
                button(text: "\u{1D465}^{3}")
                
                ForEach(1...2, id: \.self) { _ in
                    Text("")
                        .frame(width: UIScreen.main.bounds.width / 7)
                        .frame(height: 40)
                }
                
                button(text: "Abs")
                button(text: "\u{1D465}!")
            }
            .padding(.bottom, 5)
            
            
            HStack {
                button(text: "\u{00BD}")
                button(text: "√")
                button(text: "\u{1D465}^{2}")
                button(text: "\u{1D465}^{□}")
                button(text: "log")
                button(text: "ln")
            }
            .padding(.vertical, 5)
            
            HStack {
                button(text: "-")
                button(text: "° ’ ”")
                button(text: "\u{1D465}^{-1}")
                button(text: "sin")
                button(text: "cos")
                button(text: "tan")
            }
            .padding(.vertical, 5)
            
            HStack {
                button(text: "STO")
                button(text: "ENG")
                button(text: "(")
                button(text: ")")
                button(text: "S\u{21D4}D")
                button(text: "M+")
            }
            .padding(.vertical, 5)
        }
    }
    
    @ViewBuilder
    func button(text: String) -> some View {
        VStack {
            Button {
                
            } label: {
                SubSuperScriptText(inputString: text, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .foregroundColor(.white)
            .buttonStyle(.plain)
            .frame(width: UIScreen.main.bounds.width / 7)
            .frame(height: 40)
            .background(.black)
            .cornerRadius(8)
        }
    }
}



struct secondButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
