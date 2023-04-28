//
//  AverageCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 26/04/2023.
//

import SwiftUI

struct AverageCalc: View {
    
    @State var textfieldString = ""
    
    @State var results = ""
    @State var averageSelection = 0
    
    var body: some View {
        VStack {
            Form {
                Section(footer: Text("Separate numbers with a comma, do not leave a space between commas and numbers. Characters and numbers with characters will not be counted.")) {
                    TextField("Enter values", text: $textfieldString)
                        .keyboardType(.numbersAndPunctuation)
                        .onChange(of: textfieldString) { _ in
                            calculate()
                        }
                }
                
                Section(header: Text("Results")) {
                    Picker("", selection: $averageSelection) {
                        Text("Mean")
                            .tag(0)
                        Text("Median")
                            .tag(1)
                        Text("Mode")
                            .tag(2)
                        Text("STDEV")
                            .tag(3)
                    }
                    .pickerStyle(.segmented)
                    
                    HStack {
                        Text(averageSelection == 0 ? "Mean:" : averageSelection == 1 ? "Median:" : averageSelection == 2 ? "Mode:" : "Standard Deviation:")
                        Spacer()
                        Text(results == "NaN" ? "-" : results)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
        }
        .navigationTitle("Average Calculator")
        .onChange(of: averageSelection) { _ in
            calculate()
        }
    }
    
    func calculate() {
        if !textfieldString.isEmpty {
            if averageSelection == 0 {
                results = calculateMean(meanString: textfieldString)
            } else if averageSelection == 1 {
                results = calculateMedian(medianString: textfieldString)
            } else if averageSelection == 2 {
                results = calculateMode(modeString: textfieldString)
            } else if averageSelection == 3 {
                results = calculateStandardDeviation(stdevString: textfieldString)
            }
        }
    }
    
    func calculateMean(meanString: String) -> String {
        var returnResults = ""
        let separatedString = separateArray(string: meanString)
        
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
    
    func calculateMedian(medianString: String) -> String {
        var returnResults = ""
        let separatedString = separateArray(string: medianString)
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
    
    func calculateMode(modeString: String) -> String {
        let separatedString = separateArray(string: modeString)
        let sortedString = sortArray(array: separatedString)
        
        if let mostFrequent = sortedString.mostFrequent {
            return "\(sortArray(array: mostFrequent.mostFrequent).joined(separator: ", "))  |  \(mostFrequent.count)"
        }
        
        return ""
    }
    
    func calculateStandardDeviation(stdevString: String) -> String {
        var returnResults = ""
        var deviationScoreArray: [Double] = []
        var squaredDeviationScoreArray: [Double] = []
        let separatedString = separateArray(string: stdevString)
        let sortedString = sortArray(array: separatedString)

        // get mean
        let mean = calculateMean(meanString: stdevString)
        
        // find score deviation from mean
        sortedString.forEach { value in
            let deviationScore = Double(value)! - Double(mean)!
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
                guard let doubledstring = Double(string) else { return }
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
