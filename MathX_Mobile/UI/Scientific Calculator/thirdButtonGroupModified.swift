//
//  thirdButtonGroupModified.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct thirdButtonGroupModified: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @Binding var qrCodeImage: UIImage
    
    @State var showingHistoryView = false
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var sqrtPressed: Bool
    @Binding var errorOccurred: Bool
    
    @Binding var showingQRScreen: Bool
    @Binding var encodedDeepLink: String
    
    let generator = UIImpactFeedbackGenerator()
    
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                historyButton(buttonSymbol: "HIST", inputWhenPressed: "", shiftButtonSymbol: "HIST", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                shareButton(buttonSymbol: "SHARE", inputWhenPressed: "", shiftButtonSymbol: "SHARE", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                squarerootbutton(buttonSymbol: "√", inputWhenPressed: "", shiftButtonSymbol: "^{3}√", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                delButton()
                acButton()
            }
            .padding(.top, UIScreen.main.bounds.height / 50)
            
            HStack(spacing: 12) {
                button(buttonSymbol: "7", inputWhenPressed: "7", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "8", inputWhenPressed: "8", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "9", inputWhenPressed: "9", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: "(", inputWhenPressed: "(", shiftButtonSymbol: "", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                button(buttonSymbol: ")", inputWhenPressed: ")", shiftButtonSymbol: ",", shiftInputWhenPressed: "", alphaButtonSymbol: "\u{1D465}", alphaInputWhenPressed: "")
            }
            
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
//                button(buttonSymbol: "×10^{\u{1D465}}", inputWhenPressed: "", shiftButtonSymbol: "π", shiftInputWhenPressed: "", alphaButtonSymbol: "e", alphaInputWhenPressed: "e")
                button(buttonSymbol: "Ans", inputWhenPressed: "Ans", shiftButtonSymbol: "%", shiftInputWhenPressed: "", alphaButtonSymbol: "", alphaInputWhenPressed: "")
                equalsButton()
            }
        }
    }
    
    @ViewBuilder
    func button(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
               
            if !showingQRScreen {
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
                    .frame(width: buttonSymbol == "0" ? UIScreen.main.bounds.width / 3 + 12 : UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.black)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func squarerootbutton(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
               
            if !showingQRScreen {
                if equationText.contains("ERROR:") {
                    errorOccurred = false
                    
                    equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                    resultsText = ""
                } else {
                    sqrtPressed.toggle()
                }
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
                    .frame(width: buttonSymbol == "0" ? UIScreen.main.bounds.width / 3 + 12 : UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.black)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func shareButton(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        VStack {
            if !showingQRScreen {
                Button {
                    generator.impactOccurred(intensity: 0.7)
                    
                    if !showingQRScreen {
                        if equationText != "" && resultsText != "" {
                            if buttonSymbol == "SHARE" {
                                generateEquationQRandLink()
                                showingQRScreen = true
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
                    ZStack {
                        SubSuperScriptText(inputString: "", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                        Image(systemName: "square.and.arrow.up")
                    }
                    .minimumScaleFactor(0.1)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(shiftIndicator ? .yellow : alphaIndicator ? .red : .white)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.black)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            } else {
                ShareLink(item: encodedDeepLink) {
                    ZStack {
                        SubSuperScriptText(inputString: "", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                        Image(systemName: "square.and.arrow.up")
                    }
                    .minimumScaleFactor(0.1)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(shiftIndicator ? .yellow : alphaIndicator ? .red : .white)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.black)
                    .cornerRadius(8)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    @ViewBuilder
    func historyButton(buttonSymbol: String, inputWhenPressed: String, shiftButtonSymbol: String, shiftInputWhenPressed: String, alphaButtonSymbol: String, alphaInputWhenPressed: String) -> some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)
                
                if !showingQRScreen {
                    if equationText != "" && resultsText != "" {
                        if buttonSymbol == "HIST" {
                            showingHistoryView = true
                        }
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "\(shiftIndicator ? shiftInputWhenPressed : alphaIndicator ? alphaInputWhenPressed : inputWhenPressed)"
                        resultsText = ""
                    } else {
                        showingHistoryView = true
                    }
                } else {
                    showingHistoryView = true
                }
                
                shiftIndicator = false
                alphaIndicator = false
            } label: {
                ZStack {
                    SubSuperScriptText(inputString: "", bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                    Image(systemName: "clock.arrow.2.circlepath")
                }
                .minimumScaleFactor(0.1)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(shiftIndicator ? .yellow : alphaIndicator ? .red : .white)
                .frame(width: UIScreen.main.bounds.width / 6)
                .frame(height: UIScreen.main.bounds.height / 10)
                .background(.black)
                .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .sheet(isPresented: $showingHistoryView) {
                CalculationHistoryView()
            }
        }
    }
    
    @ViewBuilder
    func acButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if showingQRScreen {
                showingQRScreen = false
            } else {
                if errorOccurred {
                    if equationText.contains("SQRT") {
                        errorOccurred = false
                        equationText = ""
                        resultsText = ""
                    } else {
                        errorOccurred = false
                        equationText = lastEquation
                        resultsText = ""
                    }
                } else {
                    equationText = ""
                    resultsText = ""
                }
            }
            
            shiftIndicator = false
            alphaIndicator = false
        } label: {
            VStack {
                Text("AC")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.orange)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func delButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if showingQRScreen {
                UIPasteboard.general.string = encodedDeepLink
            } else {
                if equationText.contains("ERROR:") {
                    errorOccurred = false
                    
                    equationText = ""
                    resultsText = ""
                } else {
                    if equationText.suffix(3) == "Ans" {
                        equationText = String(equationText.dropLast(3))
                        resultsText = ""
                    } else if equationText.suffix(5) == "sqrt(" {
                        equationText = String(equationText.dropLast(5))
                        resultsText = ""
                    } else {
                        equationText = String(equationText.dropLast())
                        resultsText = ""
                    }
                }
            }
            
            shiftIndicator = false
            alphaIndicator = false
        } label: {
            VStack {
                Text("DEL")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .buttonStyle(.plain)
                    .frame(width: UIScreen.main.bounds.width / 6)
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.orange)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
        }
        .buttonStyle(.plain)
    }
    
    @ViewBuilder
    func equalsButton() -> some View {
        Button {
            generator.impactOccurred(intensity: 0.7)
            
            if !showingQRScreen {
                if equationText.contains("ERROR:") {
                    errorOccurred = false
                    
                    equationText = ""
                    resultsText = ""
                } else {
                    if equationText.contains("sqrt(") {
                        errorOccurred = true
                        equationText = "ERROR: SQRT() function should be used with the SQRT button"
                        resultsText = ""
                    } else {
                        equalsPressed.toggle()
                    }
                }
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
                    .frame(height: UIScreen.main.bounds.height / 10)
                    .background(.black)
                    .cornerRadius(8)
                    .minimumScaleFactor(0.1)
            }
        }
        .buttonStyle(.plain)
    }
    
    func generateEquationQRandLink() {
        let textToBeEncoded = "ET:\(equationText) -,- RT:\(resultsText)"
        
        let textEncoded = textToBeEncoded.toBase64()
        let encodedDeepLink = "mathx:///calculator?source=\(textEncoded)"
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

struct thirdButtonGroupModified_Previews: PreviewProvider {
    static var previews: some View {
        Text("CalculatorView()")
    }
}
