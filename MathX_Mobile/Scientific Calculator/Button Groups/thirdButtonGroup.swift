//
//  thirdButtonGroup.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct thirdButtonGroup: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var equalsPressed: Bool
    @Binding var errorOccurred: Bool
    
    @AppStorage("lastEquation", store: .standard) var lastEquation = ""

    var body: some View {
        VStack(spacing: 10) {
            HStack(spacing: 12) {
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "7"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "7"
                        resultsText = ""
                    } else {
                        equationText = equationText + "7"
                    }
                } label: {
                    buttonDesign(text: "7", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "8"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "8"
                        resultsText = ""
                    } else {
                        equationText = equationText + "8"
                    }
                } label: {
                    buttonDesign(text: "8", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "9"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "9"
                        resultsText = ""
                    } else {
                        equationText = equationText + "9"
                    }
                } label: {
                    buttonDesign(text: "9", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = ""
                        resultsText = ""
                    } else {
                        if equationText.suffix(3) == "Ans" {
                            equationText = String(equationText.dropLast(3))
                            resultsText = ""
                        } else {
                            equationText = String(equationText.dropLast())
                            resultsText = ""
                        }
                    }
                } label: {
                    buttonDesign(text: "DEL", isOrange: true)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if errorOccurred {
                        errorOccurred = false
                        equationText = lastEquation
                        resultsText = ""
                    } else {
                        equationText = ""
                        resultsText = ""
                    }
                } label: {
                    buttonDesign(text: "AC", isOrange: true)
                }
                .buttonStyle(.plain)
                
            }
            .padding(.top, UIScreen.main.bounds.height / 50)
            
            HStack(spacing: 12) {
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "4"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "4"
                        resultsText = ""
                    } else {
                        equationText = equationText + "4"
                    }
                } label: {
                    buttonDesign(text: "4", isOrange: false)
                }
                .buttonStyle(.plain)
                
               
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "5"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "5"
                        resultsText = ""
                    } else {
                        equationText = equationText + "5"
                    }
                    
                } label: {
                    buttonDesign(text: "5", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "6"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "6"
                        resultsText = ""
                    } else {
                        equationText = equationText + "6"
                    }
                } label: {
                    buttonDesign(text: "6", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "×"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "×"
                        resultsText = ""
                    } else {
                        equationText = equationText + "×"
                    }
                } label: {
                    buttonDesign(text: "×", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "÷"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "÷"
                        resultsText = ""
                    } else {
                        equationText = equationText + "÷"
                    }
                } label: {
                    buttonDesign(text: "÷", isOrange: false)
                }
                .buttonStyle(.plain)
                
            }
            
            HStack(spacing: 12) {
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "1"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "1"
                        resultsText = ""
                    } else {
                        equationText = equationText + "1"
                    }
                } label: {
                    buttonDesign(text: "1", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "2"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "2"
                        resultsText = ""
                    } else {
                        equationText = equationText + "2"
                    }
                } label: {
                    buttonDesign(text: "2", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "3"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "3"
                        resultsText = ""
                    } else {
                        equationText = equationText + "3"
                    }
                } label: {
                    buttonDesign(text: "3", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "+"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "+"
                        resultsText = ""
                    } else {
                        equationText = equationText + "+"
                    }
                } label: {
                    buttonDesign(text: "+", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "-"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "-"
                        resultsText = ""
                    } else {
                        equationText = equationText + "-"
                    }
                } label: {
                    buttonDesign(text: "-", isOrange: false)
                }
                .buttonStyle(.plain)
                
            }
            
            HStack(spacing: 12) {
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "0"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "0"
                        resultsText = ""
                    } else {
                        equationText = equationText + "0"
                    }
                } label: {
                    buttonDesign(text: "0", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "."
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "."
                        resultsText = ""
                    } else {
                        equationText = equationText + "."
                    }
                } label: {
                    buttonDesign(text: ".", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + ""//add smth
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = ""//add smth
                        resultsText = ""
                    } else {
                        equationText = equationText + ""//add smth
                    }
                } label: {
                    buttonDesign(text: "×10^{\u{1D465}}", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText != "" && resultsText != "" {
                        equationText = "Ans" + "Ans"
                        resultsText = ""
                    } else if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = "Ans"
                        resultsText = ""
                    } else {
                        equationText = equationText + "Ans"
                    }
                } label: {
                    buttonDesign(text: "Ans", isOrange: false)
                }
                .buttonStyle(.plain)
                
                
                Button {
                    if equationText.contains("ERROR:") {
                        errorOccurred = false
                        
                        equationText = ""
                        resultsText = ""
                    } else {
                        equalsPressed.toggle()
                    }
                } label: {
                    buttonDesign(text: "=", isOrange: false)
                }
                .buttonStyle(.plain)
                
            }
        }
    }
    
    @ViewBuilder
    func buttonDesign(text: String, isOrange: Bool) -> some View {
        VStack {
            SubSuperScriptText(inputString: text, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(text == "DEL" || text == "AC" ? .black : .white)
                .buttonStyle(.plain)
                .frame(width: UIScreen.main.bounds.width / 6)
                .frame(height: UIScreen.main.bounds.height / 16)
                .background(isOrange ? .orange : .black)
                .cornerRadius(8)
        }
    }
}

struct thirdButtonGroup_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
