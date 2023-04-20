//
//  SetsCalc.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import SwiftUI

struct SetsCalc: View {
    
    @State var set1 = ""
    @State var set2 = ""
    
    @State var result = ""
    @State var setCalculationSelected = 0
    
    var body: some View {
        VStack {
            Picker("", selection: $setCalculationSelected) {
                Text("Union")
                    .tag(0)
                Text("Intersection")
                    .tag(1)
            }
            .pickerStyle(.segmented)
            
            Spacer()
            Text("Do not leave a space between commas and elements.")
                .font(.subheadline)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
            
            TextField("First Set (separate elements with \",\")", text: $set1)
                .keyboardType(.numbersAndPunctuation)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            TextField("Second Set (separate elements with \",\")", text: $set2)
                .keyboardType(.numbersAndPunctuation)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            Text("{\(result)}")
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            Button {
                if setCalculationSelected == 0 {
                    result = calculateUnion(setString1: set1, setString2: set2)
                } else if setCalculationSelected == 1 {
                    result = calculateIntersection(setString1: set1, setString2: set2)
                }
            } label: {
                Text("Calculate")
                    .padding()
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width - 30, height: 50)
                    .background(.blue)
                    .cornerRadius(16)
            }
            .buttonStyle(.plain)
            .disabled(set1.isEmpty || set2.isEmpty)
            .padding(.top)
            
            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle("Set Calculator")
    }
    
    func calculateUnion(setString1: String, setString2: String) -> String {
        var returnValue = ""
        var doops: [String] = []
        
        let set1 = separateSet(setString: setString1)
        let set2 = separateSet(setString: setString2)
        
        if !set1.contains("") && !set2.contains("") {
            let unionUnsortedSet = set1 + set2
            var unionSortedSet = unionUnsortedSet.sorted()
            
            unionSortedSet.indices.forEach { i in
                if i > 0 {
                    if unionSortedSet[i] == unionSortedSet[i - 1] {
                        doops.append(unionSortedSet[i])
                    }
                }
            }
            
            doops.forEach { doop in
                if let index = unionSortedSet.firstIndex(of: doop) {
                    unionSortedSet.remove(at: index)
                }
            }
            
            returnValue = unionSortedSet.joined(separator: ",")
        }
        
        return returnValue
    }
    
    func calculateIntersection(setString1: String, setString2: String) -> String {
        var returnValue = ""
        var intersectedElements: [String] = []
        
        let set1 = separateSet(setString: setString1)
        let set2 = separateSet(setString: setString2)
        
        if !set1.contains("") && !set2.contains("") {
            set1.forEach { element in
                if set2.contains(element) {
                    intersectedElements.append(element)
                }
            }
            
            returnValue = intersectedElements.joined(separator: ",")
        }
        
        return returnValue
    }
    
    func separateSet(setString: String) -> [String] {
        if !setString.contains(" ") {
            return setString.components(separatedBy: ",")
        }
        
        return []
    }
}

struct SetsCalc_Previews: PreviewProvider {
    static var previews: some View {
        SetsCalc()
    }
}
