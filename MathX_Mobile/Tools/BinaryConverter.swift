//
//  BinaryConverter.swift
//  MathX_Mobile
//
//  Created by Tristan on 06/05/2023.
//

import SwiftUI

struct BinaryConverter: View {
    
    enum numberCases: CaseIterable, Identifiable {
        var id: Self { self }
        
        case decimal, binary, bcd
        
        var description: String {
            
            switch self {
            case .decimal:
                return "Decimal"
            case .binary:
                return "Binary"
            case .bcd:
                return "Binary-Coded Decimal"
            }
        }
    }
    
    @State var inputString = ""
    @State var inputSelection: numberCases = .decimal
    @State var inputNumberCase: numberCases = .decimal

    @State var decimalResults = "0"
    @State var binaryResults = "0"
    @State var bcdResults = "0"
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        TextField("\(inputNumberCase.description) number", text: $inputString)
                            .keyboardType(.numberPad)
                        
                        Spacer()
                        
                        Picker("", selection: $inputSelection) {
                            Text("Decimal")
                                .tag(numberCases.decimal)
                            
                            Text("Binary")
                                .tag(numberCases.binary)
                            
                            Text("BCD")
                                .tag(numberCases.bcd)
                        }
                        .fixedSize()
                        .onChange(of: inputSelection) { _ in
                            withAnimation {
                                inputNumberCase = inputSelection
                            }
                        }
                    }
                }
                
                Section {
                    if inputNumberCase != .decimal {
                        HStack {
                            Text("Decimal:")
                            Spacer()
                            Text(decimalResults)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    if inputNumberCase != .binary {
                        HStack {
                            Text("Binary:")
                            Spacer()
                            Text(binaryResults)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                    
                    if inputNumberCase != .bcd {
                        HStack {
                            Text("BCD:")
                            Spacer()
                            Text(bcdResults)
                                .multilineTextAlignment(.trailing)
                        }
                    }
                }
            }
            .navigationTitle("Binary Converter")
        }
        .onChange(of: inputString) { _ in
            update()
        }
        .onChange(of: inputNumberCase) { _ in
            update()
        }
    }
    
    func update() {
        if inputNumberCase == .bcd {
            formatInputToBCD()
        } else {
            inputString = inputString.replacingOccurrences(of: " ", with: "")
        }
        
        if !inputString.isEmpty {
            decimalResults = convertToDecimal(for: inputString, convertFrom: inputNumberCase)
            binaryResults = convertToBinary(for: inputString, convertFrom: inputNumberCase)
            bcdResults = convertToBCD(for: inputString, convertFrom: inputNumberCase)
        } else {
            decimalResults = "0"
            binaryResults = "0"
            bcdResults = "0"
        }
    }
    
    func formatInputToBCD() {
        inputString = inputString.replacingOccurrences(of: " ", with: "")
        inputString.insert(separator: " ", every: 4)
    }
    
    func convertToDecimal(for string: String, convertFrom: numberCases) -> String { // done
        switch convertFrom {
        case .decimal:
            return ""
        case .binary:
            return String(Int(string, radix: 2) ?? 0)
        case .bcd:
            var decimalNumber = ""
            let splittedBCD = splitBCD(for: string)
            
            splittedBCD.forEach { fourChar in
                decimalNumber += convertToDecimal(for: fourChar, convertFrom: .binary)
            }
            
            return decimalNumber
        }
    }
    
    func convertToBinary(for string: String, convertFrom: numberCases) -> String { // done
        switch convertFrom {
        case .decimal:
            guard let intFromString = Int(string) else { return "" }
            return String(intFromString, radix: 2)
        case .binary:
            return ""
        case .bcd:
            let decimalNumber = convertToDecimal(for: string, convertFrom: .bcd)
            return convertToBinary(for: decimalNumber, convertFrom: .decimal)
        }
    }
    
    func convertToBCD(for string: String, convertFrom: numberCases) -> String {
        switch convertFrom {
        case .decimal:
            var bcdNumber = ""
            let decimalSplitted = Array(string)
            
            decimalSplitted.forEach { decimal in
                var holdingBCDNumber = convertToBinary(for: "\(decimal)", convertFrom: .decimal)
                for _ in 0..<(4 - holdingBCDNumber.count) {
                    holdingBCDNumber = "0" + holdingBCDNumber
                }
                
                bcdNumber += "\(holdingBCDNumber) "
            }
            
            return bcdNumber
        case .binary:
            let decimalFromBinaryString = convertToDecimal(for: string, convertFrom: .binary)
            return convertToBCD(for: decimalFromBinaryString, convertFrom: .decimal)
        case .bcd:
            return ""
        }
    }
    
    func splitBCD(for string: String) -> [String] {
        return string.components(separatedBy: " ")
    }
}

struct BinaryConverter_Previews: PreviewProvider {
    static var previews: some View {
        BinaryConverter()
    }
}
