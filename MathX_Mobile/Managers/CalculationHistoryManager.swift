//
//  CalculationHistoryManager.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import Foundation

struct Calculation: Codable, Identifiable {
    var id = UUID()
    var equationText: String
    var resultsText: String
    var base64encoded: String
}

class CalculationHistoryManager: ObservableObject {
    static let shared: CalculationHistoryManager = .init()
    
    @Published var calculations: [Calculation] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    func getArchiveURL() -> URL {
        let plistName = "calculations.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedCalculations = try? propertyListEncoder.encode(calculations)
        try? encodedCalculations?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
                
        if let retrievedCalculationData = try? Data(contentsOf: archiveURL),
            let calculationDecoded = try? propertyListDecoder.decode([Calculation].self, from: retrievedCalculationData) {
            calculations = calculationDecoded
        }
    }
}

