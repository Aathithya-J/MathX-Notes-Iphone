//
//  CalculationsManager.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/06/2023.
//

import SwiftUI
import MathExpression
import Foundation

class CalculationsManager: ObservableObject {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    
    @Published var equationText = ""
    @Published var resultsText = ""
    @Published var errorOccurred = false
    @Published var showingSharingScreen = false
    
    @AppStorage("lastAns", store: .standard) var lastAns = ""
    @AppStorage("secondLastAns", store: .standard) var secondLastAns = ""
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""
    
    @ObservedObject var calculationHistoryManager: CalculationHistoryManager = .shared
    
    
}
