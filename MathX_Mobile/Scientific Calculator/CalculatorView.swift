import SwiftUI
import LaTeXSwiftUI
import MathExpression
import CoreImage.CIFilterBuiltins

struct CalculatorView: View {
    
    @State private var orientation = UIDeviceOrientation.unknown
    @Binding var isCalShowing: Bool
    
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
    
    @State var showingQRScreen = false
    @State var qrCodeImage = UIImage()
    
    @State var encodedDeepLink = String()
    @Binding var deepLinkSource: String
    
    @AppStorage("lastAns", store: .standard) var lastAns = ""
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    @ObservedObject var calculationManager: CalculationManager = .shared
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        if true {
            // simplified calculator
            ZStack {
                if colorScheme == .light {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                } else {
                    Color.gray.opacity(0.35)
                        .ignoresSafeArea()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Text("MathX-97SG XS")
                            .foregroundColor(.white)
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.trailing)
                    }
                    //                    .padding(.top)
                    if !showingQRScreen {
                        screenView(equationText: $equationText, resultsText: $resultsText, errorOccurred: $errorOccurred)
                            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)
                    } else {
                        qrScreenView(equationText: $equationText, resultsText: $resultsText, showingQRScreen: $showingQRScreen, qrCodeImage: $qrCodeImage)
                            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 5)
                    }
                    
                    Spacer()
                    
                    thirdButtonGroupModified(qrCodeImage: $qrCodeImage, shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, sqrtPressed: $sqrtPressed, errorOccurred: $errorOccurred, showingQRScreen: $showingQRScreen, encodedDeepLink: $encodedDeepLink)
                        .padding(.bottom, 30)
                }
                .padding(.horizontal)
                .onChange(of: equalsPressed) { value in
                    equalsButtonPressed()
                }
                .onChange(of: sqrtPressed) { value in
                    if !equationText.contains("sqrt(") {
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
            //            .toolbar(.hididen, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .onRotate { newOrientation in
                orientation = newOrientation
                dismiss.callAsFunction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    isCalShowing = true
                }
            }
        } else {
            // advance scientific calculator - WIP - will be an update
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
                    
                    if !showingQRScreen {
                        screenView(equationText: $equationText, resultsText: $resultsText, errorOccurred: $errorOccurred)
                            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 6)
                    } else {
                        qrScreenView(equationText: $equationText, resultsText: $resultsText, showingQRScreen: $showingQRScreen, qrCodeImage: $qrCodeImage)
                            .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 6)
                    }
                    
                    firstButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, calculatorOn: $calculatorOn, equationText: $equationText, resultsText: $resultsText, showingQRScreen: $showingQRScreen)
                    
                    secondButtonGroup(qrCodeImage: $qrCodeImage, shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred, encodedDeepLink: $encodedDeepLink, showingQRScreen: $showingQRScreen)
                    
                    thirdButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred, showingQRScreen: $showingQRScreen, encodedDeepLink: $encodedDeepLink)
                        .padding(.bottom, 5)
                    
                    Spacer()
                    Spacer()
                    
                    
                }
                .padding(.horizontal)
                .onChange(of: equalsPressed) { value in
                    equalsButtonPressed()
                }
                .onAppear {
                    receivedDeepLinkSource()
                }
                .onChange(of: deepLinkSource) { newValue in
                    receivedDeepLinkSource()
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .toolbar(.hidden, for: .tabBar)
            .statusBar(hidden: true)
            .onRotate { newOrientation in
                orientation = newOrientation
                dismiss.callAsFunction()
                isCalShowing = true
            }
        }
    }
    
    func receivedDeepLinkSource() {
        if !deepLinkSource.isEmpty {
            showingQRScreen = false
            
            var sourceConvertedArray = [String]()
            
            guard let sourceConverted = deepLinkSource.fromBase64() else { return }
            deepLinkSource = ""
            
            sourceConvertedArray = sourceConverted.components(separatedBy: " -,- ")
            
            var ET = sourceConvertedArray[0]
            var RT = sourceConvertedArray[1]
            
            ET = ET.replacingOccurrences(of: "ET:", with: "")
            RT = RT.replacingOccurrences(of: "RT:", with: "")
            
            equationText = ET
            resultsText = RT
            
        }
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
            
            returnValue = String(value.formatted())
            
            if returnValue.count > 15 {
                let val = value
                let formatter = NumberFormatter()
                formatter.numberStyle = .scientific
                formatter.usesSignificantDigits = true
                formatter.positiveFormat = "0.###########E1"
                formatter.exponentSymbol = "×10"
                if let scientificFormatted = formatter.string(for: val) {
                    returnValue = scientificFormatted
                }
            }
            
            lastAns = String(value)
            
        }
        
        return thereWasAnError ? "ERROR: \(errorType)" : returnValue
    }
    
    func sqrtcalculate(equation: String) -> String {
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
            
            returnValue = String(value.formatted())
            
            lastAns = String(value)
        }
        
        return thereWasAnError ? "ERROR: \(errorType)" : returnValue
    }
    
    func equalsButtonPressed() {
        lastEquation = equationText
        let returnValue: String = calculate(equation: equationText)
        
        if returnValue.contains("ERROR:") {
            errorOccurred = true
            
            equationText = returnValue
            resultsText = ""
        } else {
            if !returnValue.contains("×10") && returnValue.count > 5 {
                resultsText = returnValue
                saveToHistory(equationText: equationText, resultsText: returnValue)
            } else {
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
                    
                    resultsText = String(resultsTextArray)
                    saveToHistory(equationText: equationText, resultsText: String(resultsTextArray))
                    
                } else {
                    resultsText = returnValue
                    saveToHistory(equationText: equationText, resultsText: returnValue)
                }
            }
        }
    }
    
    func sqrtButtonPressed() {
        guard let sqrted = Double(sqrtcalculate(equation: equationText)) else { return }
        equationText = "sqrt(\(equationText))"
        resultsText = String(sqrt(sqrted).formatted())
    }
    
    func generateEquationQRandLink() -> String {
        let textToBeEncoded = "ET:\(equationText) -,- RT:\(resultsText)"
        
        let textEncoded = textToBeEncoded.toBase64()
        let encodedDeepLink = "mathx://calculator?source=\(textEncoded)"
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
    
    func saveToHistory(equationText et: String, resultsText rt: String) {
        calculationManager.calculations.insert(Calculation(equationText: et, resultsText: rt, base64encoded: generateEquationQRandLink()), at: 0)
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
                            if equationText.contains("ERROR:") {
                                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                                    Text("\(equationText)")
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    Text("\(equationText)")
                                        .lineLimit(1)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            } else {
                                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                                    LaTeX("\(equationText)")
                                        .parsingMode(.all)
                                        .imageRenderingMode(.template)
                                        .errorMode(.original)
                                        .blockMode(.alwaysInline)
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    LaTeX("\(equationText)")
                                        .parsingMode(.all)
                                        .imageRenderingMode(.template)
                                        .errorMode(.original)
                                        .blockMode(.alwaysInline)
                                        .lineLimit(1)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            
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
                    if !equationText.contains("SQRT") {
                        Text("Press [AC key] to restore equation")
                            .lineLimit(1)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("Press [any key] to remove equation")
                        .lineLimit(1)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                    SubSuperScriptText(inputString: resultsText, bodyFont: .title, subScriptFont: .callout, baseLine: 10.0)
                        .parsingMode(.all)
                        .imageRenderingMode(.template)
                        .errorMode(.original)
                        .blockMode(.alwaysInline)
                        .lineLimit(1)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: .trailing)
                        .cornerRadius(16)
                } else {
                    SubSuperScriptText(inputString: resultsText, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                        .parsingMode(.all)
                        .imageRenderingMode(.template)
                        .errorMode(.original)
                        .blockMode(.alwaysInline)
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
        }
        .cornerRadius(16)
    }
}

struct qrScreenView: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var showingQRScreen: Bool
    @Binding var qrCodeImage: UIImage
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.green.opacity(0.4)
            
            VStack(alignment: .center) {
                GeometryReader { geometry in
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Spacer()
                            Image(uiImage: qrCodeImage)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.height - 30, height: geometry.size.height - 30, alignment: .center)
                            Spacer()
                        }
                        .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            Text("Press [AC] to go back")
                            Text("Press [DEL] to copy link to clipboard")
                                .padding(.top, 2)
                            Text("Press [\(Image(systemName: "square.and.arrow.up"))] to open share sheet")
                                .padding(.top, 2)
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        Spacer()
                    }
                }
            }
        }
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
                    indicator(indicatorName: "Shift", indicatorColor: .yellow, isIndicatorOn: shiftIndicator)
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

struct DeviceRotationViewModifier: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        self.modifier(DeviceRotationViewModifier(action: action))
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        Text("CalculatorView()")
    }
}
