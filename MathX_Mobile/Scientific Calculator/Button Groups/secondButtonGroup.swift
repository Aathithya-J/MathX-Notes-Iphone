//
//  secondButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct secondButtonGroup: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @Binding var qrCodeImage: UIImage
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var errorOccurred: Bool
    
    @Binding var encodedDeepLink: String
    @Binding var showingQRScreen: Bool
    
    let generator = UIImpactFeedbackGenerator()
        
    var body: some View {
        VStack {
            HStack {
                button(buttonSymbol: "OPTIONS", inputWhenPressed: "", shiftButtonSymbol: "SHARE", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{3}", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: ":", alphaInputWhenPressed: "")
                
                ForEach(1...2, id: \.self) { _ in
                    Text("")
                        .frame(width: UIScreen.main.bounds.width / 7)
                        .frame(height: UIScreen.main.bounds.height / 20)
                }
                
                button(buttonSymbol: "Abs", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}!", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)
            
            
            HStack {
                button(buttonSymbol: "\u{00BD}", inputWhenPressed: "", shiftButtonSymbol: "□\u{00BD}", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "√", inputWhenPressed: "", shiftButtonSymbol: "^{3}√", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{2}", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{□}", inputWhenPressed: "", shiftButtonSymbol: "^{□}√", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "log", inputWhenPressed: "", shiftButtonSymbol: "10^{□}", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "ln", inputWhenPressed: "", shiftButtonSymbol: "e^{□}", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

            
            HStack {
                button(buttonSymbol: "-", inputWhenPressed: "-", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "A", alphaInputWhenPressed: "")
                button(buttonSymbol: "° ’ ”", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "B", alphaInputWhenPressed: "")
                button(buttonSymbol: "\u{1D465}^{-1}", inputWhenPressed: "", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "C", alphaInputWhenPressed: "")
                button(buttonSymbol: "sin", inputWhenPressed: "", shiftButtonSymbol: "sin^{-1}", shiftInputWhenPressed: "", alphaButtonSymbol: "D", alphaInputWhenPressed: "")
                button(buttonSymbol: "cos", inputWhenPressed: "", shiftButtonSymbol: "cos^{-1}", shiftInputWhenPressed: "", alphaButtonSymbol: "E", alphaInputWhenPressed: "")
                button(buttonSymbol: "tan", inputWhenPressed: "", shiftButtonSymbol: "tan^{-1}", shiftInputWhenPressed: "", alphaButtonSymbol: "F", alphaInputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

            
            HStack {
                button(buttonSymbol: "STO", inputWhenPressed: "", shiftButtonSymbol: "RECALL", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "ENG", inputWhenPressed: "", shiftButtonSymbol: "←", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "(", inputWhenPressed: "(", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: ")", inputWhenPressed: ")", shiftButtonSymbol: ",", shiftInputWhenPressed: "", alphaButtonSymbol: "\u{1D465}", alphaInputWhenPressed: "")
                button(buttonSymbol: "S\u{21D4}D", inputWhenPressed: "", shiftButtonSymbol: "□½\u{21D4}³⁄₂", shiftInputWhenPressed: "", alphaButtonSymbol: "\u{1D466}", alphaInputWhenPressed: "")
                button(buttonSymbol: "M+", inputWhenPressed: "", shiftButtonSymbol: "M-", shiftInputWhenPressed: "", alphaButtonSymbol: "M", alphaInputWhenPressed: "")
            }
            .padding(.top, UIScreen.main.bounds.height / 200)

        }
    }
    
    @ViewBuilder
    func button(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)
                
                if !showingQRScreen {
                    if equationText != "" && resultsText != "" {
                        if shiftIndicator && shiftButtonSymbol == "SHARE" {
                            generateEquationQRandLink()
                            showingQRScreen = true
                        } else {
                            if inputWhenPressed == "+" || inputWhenPressed == "-" || inputWhenPressed == "×" || inputWhenPressed == "÷" {
                                equationText = "Ans" + "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                            } else {
                                equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                            }
                            resultsText = ""
                        }
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                        resultsText = ""
                    } else {
                        equationText = equationText + "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                    }
                }
                
                shiftIndicator = false
                alphaIndicator = false
            } label: {
                SubSuperScriptText(inputString: shiftIndicator ? shiftButtonSymbol : alphaIndicator ? alphaButtonSymbol : buttonSymbol, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(shiftIndicator ? .yellow : alphaIndicator ? .red : .white)
                    .frame(width: UIScreen.main.bounds.width / 7)
                    .frame(height: UIScreen.main.bounds.height / 20)
                    .background(.black)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
            .buttonStyle(.plain)
        }
    }
    
    func generateEquationQRandLink() {
        let textToBeEncoded = "ET:\(equationText) -,- RT:\(resultsText)"
        
        let textEncoded = textToBeEncoded.toBase64()
        let encodedDeepLink = "mathx://calculator?source=\(textEncoded)"
        self.encodedDeepLink = encodedDeepLink
        qrCodeImage = generateQRCode(from: encodedDeepLink)
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}



struct secondButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        Text("CalculatorView()")
    }
}
