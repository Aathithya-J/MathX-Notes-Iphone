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
    
    @FocusState var firstSetFocused: Bool
    @FocusState var secondSetFocused: Bool
    
    @State var statesetCalculationSelected = 0
    @State var statefirstSetFocused = false
    @State var statesecondSetFocused = false
    
    @State var setType = 0
    
    @State var showingVennDiagram = true
    
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace var animation
    
    var body: some View {
        VStack {
            Form {
                if showingVennDiagram {
                    Section {
                        HStack {
                            Spacer()
                            vennDiagramView()
                                .onChange(of: firstSetFocused) { _ in
                                    withAnimation {
                                        statefirstSetFocused = firstSetFocused
                                    }
                                }
                                .onChange(of: secondSetFocused) { _ in
                                    withAnimation {
                                        statesecondSetFocused = secondSetFocused
                                    }
                                }
                            Spacer()
                        }
                        
                        Picker("", selection: $setCalculationSelected) {
                            Text("Union")
                                .tag(0)
                            Text("Intersection")
                                .tag(1)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: setCalculationSelected) { _ in
                            withAnimation {
                                statesetCalculationSelected = setCalculationSelected
                            }
                        }
                    }
                }
                
                Section(footer: Text("Do not leave a space between elements.")) {
                    if !showingVennDiagram {
                        Picker("", selection: $setCalculationSelected) {
                            Text("Union")
                                .tag(0)
                            Text("Intersection")
                                .tag(1)
                        }
                        .pickerStyle(.segmented)
                        .onChange(of: setCalculationSelected) { _ in
                            withAnimation {
                                statesetCalculationSelected = setCalculationSelected
                            }
                        }
                    }
                    
                    TextField("First Set (separate elements with a comma)", text: $set1)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($firstSetFocused)
                    
                    TextField("Second Set (separate elements with a comma)", text: $set2)
                        .keyboardType(.numbersAndPunctuation)
                        .focused($secondSetFocused)
                }
                
                Section(header: Text("Results")) {
                    Text("{\(result)}")
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: set1) { _ in
                if !set1.isEmpty && !set2.isEmpty {
                    if setCalculationSelected == 0 {
                        result = calculateUnion(setString1: set1, setString2: set2)
                    } else if setCalculationSelected == 1 {
                        result = calculateIntersection(setString1: set1, setString2: set2)
                    }
                } else {
                    result = ""
                }
            }
            .onChange(of: set2) { _ in
                if !set1.isEmpty && !set2.isEmpty {
                    if setCalculationSelected == 0 {
                        result = calculateUnion(setString1: set1, setString2: set2)
                    } else if setCalculationSelected == 1 {
                        result = calculateIntersection(setString1: set1, setString2: set2)
                    }
                } else {
                    result = ""
                }
            }
            .onChange(of: setCalculationSelected) { _ in
                if !set1.isEmpty && !set2.isEmpty {
                    if setCalculationSelected == 0 {
                        result = calculateUnion(setString1: set1, setString2: set2)
                    } else if setCalculationSelected == 1 {
                        result = calculateIntersection(setString1: set1, setString2: set2)
                    }
                } else {
                    result = ""
                }
            }
        }
        .navigationTitle("Set Calculator")
        
    }
    
    @ViewBuilder
    func vennDiagramView() -> some View {
        HStack {
            if setType == 0 { // has common and different elements
                if statefirstSetFocused || statesecondSetFocused { // 1 or more textfields focused
                    ZStack { // set 1
                        Circle()
                            .fill(statefirstSetFocused ? .purple : .clear)
                            .opacity(0.5)
                        
                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 128, height: 128)
                    .offset(x: 20)
                    
                    ZStack { // set 2
                        Circle()
                            .fill(statesecondSetFocused ? .purple : .clear)
                            .opacity(0.5)
                        
                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 128, height: 128)
                    .offset(x: -20)
                } else { // no textfields focused
                    if statesetCalculationSelected == 0 { // union
                        ZStack { // set 1
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 20)
                        
                        ZStack { // set 2
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: -20)
                    } else { // intersection
                        ZStack { // set 1
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 20)
                        
                        ZStack { // set 2 // fix intersection
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: -20)
                    }
                }
            } else if setType == 1 { // set 2 is a proper subset of set 1 (set 2 in set 1)
                if statefirstSetFocused || statesecondSetFocused { // 1 or more textfields focused
                        ZStack { // set 1
                            Circle()
                                .fill(statefirstSetFocused ? .purple : .clear)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 50)
                        
                        ZStack { // set 2
                            Circle()
                                .fill(statesecondSetFocused ? .purple : colorScheme == .light ? .white : Color(red: 28/255, green: 28/255, blue: 30/255))
                                .opacity(statesecondSetFocused ? 0.5 : 1)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 80, height: 80)
                        .offset(x: -50)
                } else { // no textfields focused
                    if statesetCalculationSelected == 0 { // union
                        ZStack { // set 1
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 50)
                        
                        ZStack { // set 2
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 80, height: 80)
                        .offset(x: -50)
                    } else { // intersection
                        ZStack { // set 1
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 50)
                        
                        ZStack { // set 2
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 80, height: 80)
                        .offset(x: -50)
                    }
                }
            } else if setType == 2 { // set 1 is a proper subset of set 2 (set 1 in set 2)
                if statefirstSetFocused || statesecondSetFocused { // 1 or more textfields focused
                    ZStack { // set 2
                        Circle()
                            .fill(statesecondSetFocused ? .purple : .clear)
                            .opacity(0.5)
                        
                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 128, height: 128)
                    .offset(x: 40)
                    
                    ZStack { // set 1
                        Circle()
                            .fill(statefirstSetFocused ? .purple : colorScheme == .light ? .white : Color(red: 28/255, green: 28/255, blue: 30/255))
                            .opacity(statefirstSetFocused ? 0.5 : 1)

                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 80, height: 80)
                    .offset(x: -80)
                } else {
                    if statesetCalculationSelected == 0 { // union
                        ZStack { // set 2
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)

                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 40)
                        
                        ZStack { // set 1
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 80, height: 80)
                        .offset(x: -80)
                    } else { // intersection
                        ZStack { // set 2
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)

                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        .offset(x: 40)
                        
                        ZStack { // set 1
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 80, height: 80)
                        .offset(x: -80)
                    }
                }
            } else if setType == 3 { // no common elements
                if statefirstSetFocused || statesecondSetFocused { // 1 or more textfields focused
                    ZStack { // set 2
                        Circle()
                            .fill(statefirstSetFocused ? .purple : .clear)
                            .opacity(0.5)
                        
                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 128, height: 128)
                    
                    ZStack { // set 1
                        Circle()
                            .fill(statesecondSetFocused ? .purple : .clear)
                            .opacity(0.5)

                        Circle()
                            .strokeBorder(.gray, lineWidth: 2)
                    }
                    .frame(width: 128, height: 128)
                } else {
                    if statesetCalculationSelected == 0 { // union
                        ZStack { // set 2
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)

                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        
                        ZStack { // set 1
                            Circle()
                                .fill(.purple)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                    } else { // intersection
                        ZStack { // set 2
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)

                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                        
                        ZStack { // set 1
                            Circle()
                                .fill(.clear)
                                .opacity(0.5)
                            
                            Circle()
                                .strokeBorder(.gray, lineWidth: 2)
                        }
                        .frame(width: 128, height: 128)
                    }
                }
            } else if setType == 4 { // sets are the same
                ZStack { // set 1
                    Circle()
                        .fill(.purple)
                        .opacity(0.5)
                    
                    Circle()
                        .strokeBorder(.gray, lineWidth: 2)
                }
                .frame(width: 128, height: 128)
//                .matchedGeometryEffect(id: "set1", in: animation)
            }
        }
        .onChange(of: set1) { _ in
            if !set1.isEmpty && !set2.isEmpty {
                if doNotHaveAnyCommonElements() {
                    withAnimation(.spring()) {
                        setType = 3
                    }
                } else if setsAreTheSame() {
                    withAnimation(.spring()) {
                        setType = 4
                    }
                } else if set2IsAProperSubsetOfSet1() {
                    withAnimation(.spring()) {
                        setType = 1
                    }
                } else if set1IsAProperSubsetOfSet2() {
                    withAnimation(.spring()) {
                        setType = 2
                    }
                } else {
                    withAnimation(.spring()) {
                        setType = 0
                    }
                }
            } else {
                withAnimation(.spring()) {
                    setType = 0
                }
            }
        }
        .onChange(of: set2) { _ in
            if !set1.isEmpty && !set2.isEmpty {
                if doNotHaveAnyCommonElements() {
                    withAnimation(.spring()) {
                        setType = 3
                    }
                } else if setsAreTheSame() {
                    withAnimation(.spring()) {
                        setType = 4
                    }
                } else if set2IsAProperSubsetOfSet1() {
                    withAnimation(.spring()) {
                        setType = 1
                    }
                } else if set1IsAProperSubsetOfSet2() {
                    withAnimation(.spring()) {
                        setType = 2
                    }
                } else {
                    withAnimation(.spring()) {
                        setType = 0
                    }
                }
            } else {
                withAnimation(.spring()) {
                    setType = 0
                }
            }
        }
    }
    
    func calculateUnion(setString1: String, setString2: String) -> String {
        var returnValue = ""
        var doops: [String] = []
        
        let set1 = separateSet(setString: setString1)
        let set2 = separateSet(setString: setString2)
        
        if !set1.contains("") && !set2.contains("") {
            let unionUnsortedSet = set1 + set2
            var unionSortedSet: [String] = []
            
            var tempDoubleArray: [Double] = []
            var tempOthersArray: [String] = []
            
            unionUnsortedSet.forEach { element in
                guard let elementNumber = Double(element) else {
                    // isnt double
                    tempOthersArray.append(element)
                    tempOthersArray.sort()
                    return
                }
                // is double
                tempDoubleArray.append(elementNumber)
                tempDoubleArray.sort()
            }
            
            tempDoubleArray.forEach { double in
                unionSortedSet.append(double.formatted())
            }
            
            unionSortedSet += tempOthersArray
            
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
            
            returnValue = unionSortedSet.joined(separator: ", ")
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
            
            returnValue = sortSet(set: intersectedElements).joined(separator: ", ")
        }
                
        return returnValue
    }
    
    func separateSet(setString: String) -> [String] {
        let nonSpacedSet = setString.replacingOccurrences(of: ", ", with: ",")
        if !nonSpacedSet.contains(" ") {
            return nonSpacedSet.components(separatedBy: ",")
        } else {
            return []
        }
    }
    
    func set2IsAProperSubsetOfSet1() -> Bool {
        var returnValue = false
        
        let set1Separated = separateSet(setString: set1)
        let set2Separated = separateSet(setString: set2)
        let set2SeparatedCount = set2Separated.count
        
        var elementMatchCount = 0
        
        set2Separated.forEach { element in
            if set1Separated.contains(element) {
                elementMatchCount += 1
            }
        }
        
        if elementMatchCount == set2SeparatedCount {
            returnValue = true
        }
        
        return returnValue
    }
    
    func set1IsAProperSubsetOfSet2() -> Bool {
        var returnValue = false
        
        let set1Separated = separateSet(setString: set1)
        let set2Separated = separateSet(setString: set2)
        let set1SeparatedCount = set1Separated.count
        
        var elementMatchCount = 0
        
        set1Separated.forEach { element in
            if set2Separated.contains(element) {
                elementMatchCount += 1
            }
        }
        
        if elementMatchCount == set1SeparatedCount {
            returnValue = true
        }
        
        return returnValue
    }
    
    func doNotHaveAnyCommonElements() -> Bool {
        var returnValue = false
        
        let set1Separated = separateSet(setString: set1)
        let set2Separated = separateSet(setString: set2)
        
        var elementMatchCount = 0
        
        set1Separated.forEach { element in
            if set2Separated.contains(element) {
                elementMatchCount += 1
            }
        }
        
        if elementMatchCount == 0 {
            returnValue = true
        }
        
        return returnValue
    }
    
    func setsAreTheSame() -> Bool {
        var returnValue = false
        
        let set1Separated = separateSet(setString: set1)
        let set2Separated = separateSet(setString: set2)
        
        let set1Sorted = sortSet(set: set1Separated)
        let set2Sorted = sortSet(set: set2Separated)

        if set1Sorted == set2Sorted {
            returnValue = true
        }
        
        return returnValue
    }
    
    func sortSet(set: [String]) -> [String] {
        let unsortedSet = set
        var sortedSet: [String] = []
        
        var tempDoubleArray: [Double] = []
        var tempOthersArray: [String] = []
        
        unsortedSet.forEach { element in
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
            sortedSet.append(double.formatted())
        }
        
        sortedSet += tempOthersArray
        
        return sortedSet
    }
}

struct SetsCalc_Previews: PreviewProvider {
    static var previews: some View {
        SetsCalc()
    }
}
