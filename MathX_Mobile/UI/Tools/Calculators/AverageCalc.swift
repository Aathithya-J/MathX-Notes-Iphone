//
//  AverageCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 26/04/2023.
//

import SwiftUI

enum avFocusable: Hashable {
    case none
    case identifier(id: Int)
}

struct AverageCalc: View {
        
    @State var mean = "-"
    @State var median = "-"
    @State var mode = "-"
    @State var stdev = "-"
    
    @State var textfieldCount = 1
    
    @State var textfieldArray: [String] = [""]
    
    @FocusState var focused: avFocusable?

    var body: some View {
        VStack {
            Form {
                Section {
                    ForEach(1...textfieldCount, id: \.self) { position in
                        TextField("Enter values", text: $textfieldArray[position - 1])
                            .focused($focused, equals: .identifier(id: position - 1))
                            .submitLabel(position == textfieldCount ? .done : .return)
                            .keyboardType(.decimalPad)
//                            .swipeActions {
//                                if textfieldCount > 1 {
//                                    Button {
//                                        textfieldArray.remove(at: position - 1)
//                                    } label: {
//                                        Text("Delete")
//                                    }
//                                    .tint(.red)
//                                }
//                            }
                    }
                    
                    Button {
                        textfieldCount += 1
                        textfieldArray.append("")
                    } label: {
                        Text("Add value")
                    }
                }
                
                Section(header: Text("Results")) {
                    HStack {
                        Text("Mean:")
                        Spacer()
                        Text(mean == "NaN" ? "-" : mean)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Median:")
                        Spacer()
                        Text(median == "NaN" ? "-" : median)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Mode:")
                        Spacer()
                        Text(mode == "NaN" ? "-" : mode)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Standard Deviation:")
                        Spacer()
                        Text(stdev == "NaN" ? "-" : stdev)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button {
                        var textrepresentation = String(focused.debugDescription.description)
                        
                        textrepresentation = textrepresentation.replacingOccurrences(of: "Optional(MathX_Mobile.avFocusable.identifier(id: ", with: "")
                        textrepresentation = textrepresentation.replacingOccurrences(of: "))", with: "")
                        
                        if !textfieldArray[Int(textrepresentation)!].isEmpty {
                            textfieldArray[Int(textrepresentation)!] = (Double(textfieldArray[Int(textrepresentation)!])! * -1).formatted()
                        }
                    } label: {
                        Text("Negative")
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Average Calculator")
        .onChange(of: textfieldArray) { _ in
            calculate()
        }
    }
    
    func calculate() {
        var emptyCount = 0
        
        textfieldArray.forEach { string in
            if string.isEmpty {
                emptyCount += 1
            }
        }
        
        
        if emptyCount < 1 {
            mean = calculateMean(meanString: textfieldArray)
            median = calculateMedian(medianString: textfieldArray)
            mode = calculateMode(modeString: textfieldArray)
            stdev = calculateStandardDeviation(stdevString: textfieldArray)
        } else {
            mean = "-"
            median = "-"
            mode = "-"
            stdev = "-"
        }
    }
    
    func calculateMean(meanString: [String]) -> String {
        var returnResults = ""
        let separatedString = meanString
        
        if !separatedString.isEmpty {
            var meanAdded: Double = 0
            
            separatedString.forEach { string in
                guard let doubleOfString = Double(string) else { return }
                
                meanAdded += doubleOfString
                
                let mean = meanAdded / Double(separatedString.count)
                
                returnResults = mean.formatted()
            }
        } else {
            returnResults = ""
        }
        
        return returnResults
    }
    
    func calculateMedian(medianString: [String]) -> String {
        var returnResults = ""
        let separatedString = medianString
        let sortedString = sortArray(array: separatedString)
        
        if !sortedString.isEmpty {
            let medianPosition: Double = Double(sortedString.count / 2)
            
            if sortedString.count % 2 == 1 {
                // median is integer
                returnResults = Double(sortedString[Int(medianPosition)])!.formatted()
            } else {
                let medianArrNumber1 = Int(floor(medianPosition)) - 1
                let medianArrNumber2 = Int(floor(medianPosition))
                
                let median1: Double = Double(sortedString[medianArrNumber1])!
                let median2: Double = Double(sortedString[medianArrNumber2])!
                
                returnResults = ((median1 + median2) / 2).formatted()
            }
        } else {
            returnResults = ""
        }
        
        return returnResults
    }
    
    func calculateMode(modeString: [String]) -> String {
        let separatedString = modeString
        let sortedString = sortArray(array: separatedString)
        
        if let mostFrequent = sortedString.mostFrequent {
            return "\(sortArray(array: mostFrequent.mostFrequent).joined(separator: ", "))  |  \(mostFrequent.count)"
        }
        
        return ""
    }
    
    func calculateStandardDeviation(stdevString: [String]) -> String {
        var returnResults = ""
        var deviationScoreArray: [Double] = []
        var squaredDeviationScoreArray: [Double] = []
        let separatedString = stdevString
        let sortedString = sortArray(array: separatedString)

        // get mean
        let mean = calculateMean(meanString: textfieldArray)
        
        // find score deviation from mean
        sortedString.forEach { value in
            let deviationScore = Double(value)! - Double(mean.replacingOccurrences(of: ",", with: ""))!
            deviationScoreArray.append(deviationScore)
        }
        
        // square each deviation from mean
        deviationScoreArray.forEach { devScore in
            squaredDeviationScoreArray.append(pow(devScore, 2))
        }
        
        // find sum of squares
        var sumOfSquares: Double = 0
        squaredDeviationScoreArray.forEach { value in
            sumOfSquares += value
        }
        
        // find the variance (n - 1)
        let variance: Double = sumOfSquares / Double((sortedString.count - 1))
        
        // find the square root of the variance
        let rootOfVariance: Double = sqrt(variance)
        returnResults = rootOfVariance.formatted()
        
        return returnResults
    }
    
    func separateArray(string: String) -> [String] {
        if !string.contains(" ") {
            var arrayOfPassedElements: [String] = []
            let separatedString = string.components(separatedBy: ",")
            
            separatedString.forEach { string in
                guard let _ = Double(string) else { return }
                arrayOfPassedElements.append(string)
            }
            
            return arrayOfPassedElements
        } else {
            return []
        }
    }
    
    func sortArray(array: [String]) -> [String] {
        let unsortedArray = array
        var sortedArray: [String] = []
        
        var tempDoubleArray: [Double] = []
        var tempOthersArray: [String] = []
        
        unsortedArray.forEach { element in
            guard let elementNumber = Double(element) else {
                //isnt double
                tempOthersArray.append(element)
                tempOthersArray.sort()
                return
            }
            // is double
            tempDoubleArray.append(elementNumber)
            tempDoubleArray.sort()
        }
        
        tempDoubleArray.forEach { double in
            sortedArray.append(double.formatted())
        }
        
        sortedArray += tempOthersArray
        
        sortedArray.indices.forEach { i in
            let string = sortedArray[i]
            sortedArray[i] = string.replacingOccurrences(of: ",", with: "")
        }
        
        print("sorted array: \(sortedArray)")
        
        return sortedArray
    }
}

struct AverageCalc_Previews: PreviewProvider {
    static var previews: some View {
        AverageCalc()
    }
}

extension Sequence where Element: Hashable {
    var frequency: [Element: Double] { reduce(into: [:]) { $0[$1, default: 0] += 1 } }
    var mostFrequent: (mostFrequent: [Element], count: String)? {
        guard let maxCount = frequency.values.max() else { return nil }
        return (frequency.compactMap { $0.value == maxCount ? $0.key : nil }, maxCount.formatted())
    }
}
