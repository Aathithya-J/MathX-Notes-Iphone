import SwiftUI
import MathExpression

struct CalculatorView: View {
    
    @State var shiftIndicator = false
    @State var alphaIndicator = false
    
    @State var equalsPressed = false

    @State var errorOccurred = false

    @State var calculatorOn = true
    
    @State var equationText = ""
    @State var resultsText = ""
    
    @AppStorage("lastAns", store: .standard) var lastAns = ""
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""

    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .top) {
            if colorScheme == .light {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
            } else {
                Color.gray.opacity(0.35)
                    .ignoresSafeArea()
            }
            
            VStack(alignment: .center) {
                
                Spacer()
                Spacer()
                Spacer()


                modeIndicators(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator)
                    .padding(.horizontal, 5)
                
                screenView(equationText: $equationText, resultsText: $resultsText, errorOccurred: $errorOccurred)
                
                firstButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, calculatorOn: $calculatorOn, equationText: $equationText, resultsText: $resultsText)
                
                secondButtonGroup(equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred)
                
                thirdButtonGroup(equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred)
                    .padding(.bottom, 5)
                
                Spacer()
                Spacer()

                
            }
            .padding(.horizontal)
            .onChange(of: equalsPressed) { value in
                lastEquation = equationText
                let returnValue = calculate(equation: equationText)
                
                if returnValue.contains("ERROR:") {
                    errorOccurred = true
                    
                    equationText = returnValue
                    resultsText = ""
                } else {
                    if !returnValue.contains("e") && returnValue.count > 5 {
                        let returnValueBeforeCommasArray = Array(returnValue)
                        var returnValueArray = [Character]()
                        
                        returnValueBeforeCommasArray.indices.forEach { i in
                            returnValueArray.append(returnValueBeforeCommasArray[i])
                            
                            if i + 1 < returnValue.count {
                                if (i + 1) % 3 == 0 {
                                    returnValueArray.append(contentsOf: " ")
                                }
                            }
                        }
                        
                        resultsText = String(returnValueArray)
                        
                    } else {
                        resultsText = returnValue
                    }
                    
                    lastAns = returnValue
                }
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .statusBar(hidden: true)
    }
    
    func calculate(equation: String) -> String {
        var returnValue = ""
        var thereWasAnError = false
        var errorType = ""

        if !equation.isEmpty {
            var value = Double()
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
            
            equationConverted = String(equationConvertedArray)
            
            do {
                let expression = try MathExpression(equationConverted)
                value = expression.evaluate()
            } catch {
                print(error)
                thereWasAnError = true
                errorType = error.localizedDescription
            }
            
            returnValue = String(format: "%.0f", value)
            
            
            if returnValue.count > 15 {
                let val = value
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.positiveFormat = "0.###E+0"
                formatter.exponentSymbol = "e"
                if let scientificFormatted = formatter.string(for: val) {
                    returnValue = scientificFormatted
                }
            }
        }
        
        return thereWasAnError ? "ERROR: \(errorType)" : returnValue
    }
}

struct screenView: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var errorOccurred: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.green.opacity(0.4)
            VStack(alignment: .trailing) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            Text(equationText)
                                .lineLimit(1)
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HStack {Spacer()}
                                .id(1)
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .cornerRadius(16)
                    .onChange(of: equationText, perform: { value in
                        if !equationText.contains("ERROR:") {
                            proxy.scrollTo(1)
                        }
                    })
                }
                
                if errorOccurred {
                    Text("Press [AC key] to restore equation")
                        .lineLimit(1)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 5)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text("Press [any key] to remove equation")
                        .lineLimit(1)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                
                Text(resultsText)
                    .lineLimit(1)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.bottom)
                    .padding(.horizontal)
                    .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: .trailing)
                    .cornerRadius(16)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 6)
        .cornerRadius(16)
    }
}

struct modeIndicators: View {
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool
    
    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    indicator(indicatorName: "Shift", indicatorColor: .orange, isIndicatorOn: shiftIndicator)
                    indicator(indicatorName: "Alpha", indicatorColor: .red, isIndicatorOn: alphaIndicator)
                }
            }
            
            Text("MathX-97SG X")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
            
        }
    }
    
    @ViewBuilder
    func indicator(indicatorName: String, indicatorColor: Color, isIndicatorOn: Bool) -> some View {
        HStack {
            Circle()
                .frame(width: 12, height: 12)
            Text(indicatorName)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .foregroundColor(isIndicatorOn ? indicatorColor : .gray)
        .padding(5)
        .background(isIndicatorOn ? indicatorColor.opacity(0.5) : .gray.opacity(0.5))
        .cornerRadius(6)
        
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}
