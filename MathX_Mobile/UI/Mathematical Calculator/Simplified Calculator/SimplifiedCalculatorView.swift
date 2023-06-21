//
//  SimplifiedCalculatorView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/06/2023.
//

import SwiftUI
import MathExpression

struct SimplifiedCalculatorView: View {
    
    @State private var orientation = UIDeviceOrientation.unknown
    @Binding var path: NavigationPath
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @State var shiftIndicator = false
    @State var alphaIndicator = false
    
    @State var equalsPressed = false
    @State var sqrtPressed = false
    
    @State var errorOccurred = false
    
    @State var calculatorOn = true
    
    @State var equationText = ""
    @State var resultsText = ""
    
    @State var showingSharingScreen = false
    @State var qrCodeImage = UIImage()
    
    @State var encodedDeepLink = String()
    @Binding var deepLinkSource: String
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("secondLastAns", store: .standard) var secondLastAns = ""
    @AppStorage("lastAns", store: .standard) var lastAns = ""
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    @ObservedObject var calculationHistoryManager: CalculationHistoryManager = .shared
        
    var body: some View {
        ZStack {
            if colorScheme == .light {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
            } else {
                Color.gray.opacity(0.35)
                    .ignoresSafeArea()
            }
            
            VStack {
                Text("MathX-97SG XS")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                //                    .padding(.top)
                if !showingSharingScreen {
                    ScreenView(equationText: $equationText, resultsText: $resultsText, errorOccurred: $errorOccurred)
                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)
                } else {
                    SharingScreenView(equationText: $equationText, resultsText: $resultsText, showingSharingScreen: $showingSharingScreen, qrCodeImage: $qrCodeImage)
                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)
                }
                
                Spacer()
                
                SimplifiedCalculatorButtonGroup(qrCodeImage: $qrCodeImage, shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, sqrtPressed: $sqrtPressed, errorOccurred: $errorOccurred, showingSharingScreen: $showingSharingScreen, encodedDeepLink: $encodedDeepLink)
                    .padding(.bottom, 30)
            }
            .padding(.horizontal)
            .onChange(of: equalsPressed) { value in
                if !equationText.isEmpty {
                    equalsButtonPressed()
                }
            }
            .onChange(of: sqrtPressed) { value in
                if !equationText.contains("sqrt(") && equationText != "" {
                    if equationText.contains("Ans") && !resultsText.isEmpty {
                        equationText = "Ans"
                    }
                    
                    sqrtButtonPressed()
                }
            }
            .onAppear {
                receivedDeepLinkSource()
            }
            .onChange(of: deepLinkSource) { newValue in
                receivedDeepLinkSource()
            }
        }
        .statusBar(hidden: true)
        .toolbar(.hidden, for: .tabBar)
        .onRotate { newOrientation in
            if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                orientation = newOrientation
                dismiss.callAsFunction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    path.append(MathXCalculatorTools[0])
                }
            }
        }
    }
    
    
    // MARK: - On button press
    
    func equalsButtonPressed() {
        lastEquation = equationText // sets lastequation to equationtext in case of error
        let returnValue: String = calculate(equation: equationText) // gets calculated value, could be error or value
        
        if returnValue.contains("ERROR:") { // if error occurred
            errorOccurred(errorMessage: returnValue)
        } else { // if no error
            if !returnValue.contains("×10") && returnValue.count > 5 { // value is in standard form
                resultsText = returnValue
                saveToHistory(equationText: equationText, resultsText: returnValue)
            } else {  // value isnt in standard form
                resultsText = formatValueToBeDisplayed(returnValue: returnValue)
                saveToHistory(equationText: equationText, resultsText: returnValue)
            }
        }
    }
    
    func sqrtButtonPressed() {
        lastEquation = equationText // sets lastequation to equationtext in case of error
        let returnValue: String = sqrtcalculate(equation: equationText) // gets calculated value, could be error or value
        
        if returnValue.contains("ERROR:") { // if error occurred
            errorOccurred(errorMessage: returnValue)
        } else { // if no error
            if !returnValue.contains("×10") { // value is in standard form
                resultsText = returnValue
                equationText = "sqrt(\(equationText))"
                saveToHistory(equationText: equationText, resultsText: returnValue)
            } else {
                resultsText = formatValueToBeDisplayed(returnValue: returnValue)
                equationText = "sqrt(\(equationText))"
                saveToHistory(equationText: equationText, resultsText: returnValue)
            }
        }
    }
    
    // MARK: - Mathematical Calculations
    func calculate(equation: String) -> String {
        var returnValue = ""
        var thereWasAnError = false
        var errorType = ""
        
        if !equation.isEmpty {
            var value = Double()
            var equationConverted = ""
            
            equationConverted = formatEquationForCalculation(equation: equation) // formats equation, replaces Ans with lastans and () with * etc
            
            // evaluates equation and returns either a value or an error
            do {
                let expression = try MathExpression(equationConverted)
                value = expression.evaluate()
                secondLastAns = lastAns
                lastAns = String(value) // sets Ans to String of calculated value
            } catch {
                print(error)
                thereWasAnError = true
                errorType = error.localizedDescription
            }
            returnValue = String(value.formatted()) // formats value to look like int if its .0
            
            returnValue = convertToStandardForm(returnValue: returnValue, value: value)
        }
        
        return thereWasAnError ? "ERROR: \(errorType)" : returnValue // returns value, else returns error
    }
    
    func sqrtcalculate(equation: String) -> String {
        var returnValue = ""
        var thereWasAnError = false
        var errorType = ""
        
        if !equation.isEmpty {
            var value = Double()
            var equationConverted = ""
            
            equationConverted = formatEquationForCalculation(equation: equation) // formats equation, replaces Ans with lastans and () with * etc
            
            // evaluates equation and returns either a value or an error
            do {
                let expression = try MathExpression(equationConverted)
                value = expression.evaluate()
                secondLastAns = lastAns
                lastAns = String(sqrt(value))
            } catch {
                print(error)
                thereWasAnError = true
                errorType = error.localizedDescription
            }
            
            returnValue = String(sqrt(value).formatted()) // square root function happens here
            returnValue = convertToStandardForm(returnValue: returnValue, value: sqrt(value))
        }
        
        return thereWasAnError ? "ERROR: \(errorType)" : returnValue
    }
    
    
    // MARK: - Mathematical Subfunctions
    func saveToHistory(equationText et: String, resultsText rt: String) {
        calculationHistoryManager.calculations.insert(Calculation(equationText: et, resultsText: rt, base64encoded: generateEquationQRandLink()), at: 0)
    }
    
    func formatEquationForCalculation(equation: String) -> String {
        var equationConverted = ""
        
        equationConverted = equation.replacingOccurrences(of: "÷", with: "/")
        equationConverted = equationConverted.replacingOccurrences(of: "×", with: "*")
        equationConverted = equationConverted.replacingOccurrences(of: "Ans", with: "(\(lastAns))")
        
        var equationConvertedArray = Array(equationConverted)
        
        equationConvertedArray.indices.forEach { i in
            if equationConvertedArray[i] == "(" {
                if i > 0 {
                    if equationConvertedArray[i - 1] == ")" {
                        equationConvertedArray.insert("*", at: i)
                    } else if equationConvertedArray[i - 1].isNumber {
                        equationConvertedArray.insert("*", at: i)
                    }
                }
            }
            
            if equationConvertedArray[i] == ")" {
                if i < (equationConvertedArray.count - 1) {
                    if equationConvertedArray[i + 1].isNumber {
                        equationConvertedArray.insert("*", at: i + 1)
                    }
                }
            }
        }
        
        return String(equationConvertedArray)
    }
    
    func convertToStandardForm(returnValue: String, value: Double) -> String {
        var formattedReturn = ""
        
        if returnValue.count > 15 {
            let val = value
            let formatter = NumberFormatter()
            formatter.numberStyle = .scientific
            formatter.usesSignificantDigits = true
            formatter.positiveFormat = "0.###########E1"
            formatter.exponentSymbol = "×10"
            if let scientificFormatted = formatter.string(for: val) {
                formattedReturn = scientificFormatted
            }
        } else {
            formattedReturn = returnValue
        }
        
        return formattedReturn
    }
    
    func errorOccurred(errorMessage: String) {
        errorOccurred = true
        
        equationText = errorMessage
        resultsText = ""
    }
    
    func formatValueToBeDisplayed(returnValue: String) -> String {
        var stringToBeDisplayed = ""
        
        var numberOfDigitsInPower = Int()
        var positionOfStartingOfPower = Int()
        
        var resultsTextArray = Array(returnValue)
        resultsTextArray.indices.forEach { indices in
            if resultsTextArray[indices] == "×" {
                if resultsTextArray[indices + 1] == "1" {
                    if resultsTextArray[indices + 2] == "0" {
                        numberOfDigitsInPower = (returnValue.count - 1) - (indices + 2)
                        positionOfStartingOfPower = indices + 2
                    }
                }
            }
        }
        
        if numberOfDigitsInPower > 0 {
            resultsTextArray.insert(contentsOf: "}", at: (positionOfStartingOfPower + numberOfDigitsInPower) + 1)
            resultsTextArray.insert(contentsOf: "^{", at: (positionOfStartingOfPower) + 1)
            
            stringToBeDisplayed = String(resultsTextArray)
        } else {
            stringToBeDisplayed = returnValue
        }
        
        return stringToBeDisplayed
    }
    
    // MARK: - QR and DeepLinks Generation
    func generateEquationQRandLink() -> String {
        
        var textToBeEncoded = ""
        
        if !secondLastAns.isEmpty {
            textToBeEncoded = "ET:\(equationText.replacingOccurrences(of: "Ans", with: "\(String(describing: Double(secondLastAns)!.formatted()))")) -,- RT:\(resultsText)"
        } else {
            textToBeEncoded = "ET:\(equationText.replacingOccurrences(of: "Ans", with: " ")) -,- RT:\(resultsText)"
        }
        
        let textEncoded = textToBeEncoded.toBase64()
        let encodedDeepLink = "mathx:///calculator?source=\(textEncoded)"
        return encodedDeepLink
        //        qrCodeImage = generateQRCode(from: encodedDeepLink)
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
    
    func receivedDeepLinkSource() {
        if !deepLinkSource.isEmpty {
            errorOccurred = false
            showingSharingScreen = false
            
            var sourceConvertedArray = [String]()
            
            guard let sourceConverted = deepLinkSource.fromBase64() else { return }
//            deepLinkSource = ""
            
            sourceConvertedArray = sourceConverted.components(separatedBy: " -,- ")
            
            var ET = sourceConvertedArray[0]
            var RT = sourceConvertedArray[1]
            
            ET = ET.replacingOccurrences(of: "ET:", with: "")
            RT = RT.replacingOccurrences(of: "RT:", with: "")
            
            equationText = ET
            resultsText = RT
            
        }
    }
}
