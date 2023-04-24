//
//  RandView.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import SwiftUI

struct RandView: View {
    
    @State var numGenerated: [String] = []
    @State var numUnique: [Int] = []
    @State var generatedNumber = 0
    
    @State var ceilingNumber = ""
    
    @State var dataSummarySelection = 0
    
    @FocusState var textfieldFocused: Bool
    
    var body: some View {
        VStack {
            ZStack {
                Rectangle()
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .ignoresSafeArea()
                    .onTapGesture {
                        textfieldFocused = false
                        generateNumber()
                    }
                
                VStack {
                    Spacer()
                    Text("\(generatedNumber)")
                        .font(.system(size: 64))
                        .fontWeight(.bold)
                    
                    TextField("Max Number (Inclusive)", text: $ceilingNumber)
                        .focused($textfieldFocused)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(.ultraThickMaterial)
                        .cornerRadius(16)
                        .frame(width: UIScreen.main.bounds.width / 2)
                    Spacer()
                }
                .padding(.horizontal)
                .onTapGesture {
                    textfieldFocused = false
                    generateNumber()
                }
                .frame(height: (UIScreen.main.bounds.height - 120) * 3/5)
            }
            
            Spacer()
            
            Divider()
                .padding(.bottom, 7.5)
            
            VStack {
                Picker("", selection: $dataSummarySelection) {
                    Text("Recent")
                        .tag(0)
                    Text("Occurences")
                        .tag(1)
                }
                .padding(.horizontal)
                .pickerStyle(.segmented)
                
                if dataSummarySelection == 0 {
                    if numGenerated.isEmpty {
                        Spacer()
                        Text("No data yet, try tapping anywhere in the top half to generate a random number!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    } else {
                        List {
                            ForEach(numGenerated, id: \.self) { num in
                                Text(num)
                            }
                        }
                    }
                } else {
                    if numGenerated.isEmpty {
                        Spacer()
                        Text("No data yet, try tapping anywhere in the top half to generate a random number!")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        Spacer()
                    } else {
                        List {
                            ForEach(numUnique, id: \.description) { num in
                                HStack {
                                    Text(String(num))
                                    Spacer()
                                    Text("\(getOccurenceData(number: num))")
                                }
                            }
                        }
                    }
                }
            }
            .frame(height: (UIScreen.main.bounds.height - 120) * 2/5)
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("Randomise")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(role: .destructive) {
                    numGenerated = []
                    numUnique = []
                    generatedNumber = 0
                    ceilingNumber = ""
                } label: {
                    Image(systemName: "arrow.clockwise.circle")
                        .foregroundColor(.red)
                }
            }
        }
    }
    
    func getOccurenceData(number num: Int) -> String {
        var returnValue = ""
        
        var occurenceCount: Double = 0
        var occurencePercentage: Double = 0

        numGenerated.forEach { numg in
            if Int(numg) == num {
                occurenceCount += 1
            }
        }
        
        occurencePercentage = (occurenceCount / Double(numGenerated.count)) * 100
        
        returnValue = "\(occurenceCount.formatted())/\(numGenerated.count) (\((round(occurencePercentage * 100) / 100).formatted())%)"
        
        return returnValue
    }
    
    func generateNumber() {
        if !ceilingNumber.isEmpty {
            let generatedNumber = Int.random(in: 0...(Int(ceilingNumber) ?? 1))
            self.generatedNumber = generatedNumber
            self.numGenerated.insert(String(generatedNumber.formatted()), at: 0)
            
            if !numUnique.contains(generatedNumber) {
                numUnique.append(generatedNumber)
                numUnique = numUnique.sorted()
            }
        }
    }
}

struct RandView_Previews: PreviewProvider {
    static var previews: some View {
        RandView()
    }
}
