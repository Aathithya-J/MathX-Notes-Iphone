import SwiftUI

struct UnitConverterView: View {
    @State private var lengthInput = ""
    @State private var selectedUnit = 0
    let units = ["meters", "feet"]
    
    var convertedLength: Double {
        let inputLength = Double(lengthInput) ?? 0
        if selectedUnit == 0 {
            return inputLength * 3.28084
        } else {
            return inputLength / 3.28084
        }
    }
    
    var body: some View {
        VStack {
            TextField("Enter length", text: $lengthInput)
                .keyboardType(.decimalPad)
                .padding()
            Picker(selection: $selectedUnit, label: Text("Unit")) {
                ForEach(0..<units.count) {
                    Text(units[$0])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            Text("\(convertedLength, specifier: "%.2f") \(units[selectedUnit == 0 ? 1 : 0])")
                .padding()
            Spacer()
        }
    }
}

struct UnitConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverterView()
    }
}

