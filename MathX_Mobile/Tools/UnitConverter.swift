import SwiftUI

struct UnitConverterView: View {
    
    @State private var lengthInput = ""
    @State private var selectedUnit = 0
    
    let units = ["Metres", "Feet"]
    
    var body: some View {
        VStack {
            Spacer()
            TextField("Enter length", text: $lengthInput)
                .keyboardType(.decimalPad)
                .padding()
                .background(.ultraThickMaterial)
                .cornerRadius(16)
            
            Picker("", selection: $selectedUnit) {
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
        .padding(.horizontal)
        .navigationTitle("Unit Converter")
    }
    
    var convertedLength: Double {
        let inputLength = Double(lengthInput) ?? 0
        if selectedUnit == 0 {
            return inputLength * 3.28084
        } else {
            return inputLength / 3.28084
        }
    }
}

struct UnitConverterView_Previews: PreviewProvider {
    static var previews: some View {
        UnitConverterView()
    }
}

