import SwiftUI

struct HCF_LCM_CalculatorView: View {
    @State private var number1 = ""
    @State private var number2 = ""
    @State private var result = ""
    @State private var isHCFSelected = true
    
    var body: some View {
        VStack {
            Picker(selection: $isHCFSelected, label: Text("Select Operation")) {
                Text("HCF").tag(true)
                Text("LCM").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            .padding(.top, 20)
            .onChange(of: isHCFSelected) { _ in
                self.calculate()
            }
            
            HStack {
                TextField("Enter the first number", text: $number1)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
                
                TextField("Enter the second number", text: $number2)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .padding()
            }
            
            Text("Result: \(result)")
                .padding()
            
            Spacer()
        }
        .onChange(of: number1) { _ in
            self.calculate()
        }
        .onChange(of: number2) { _ in
            self.calculate()
        }
        .navigationTitle("HCF & LCM Calculator")
        .onAppear {
            self.calculate()
        }
    }
    
    func calculate() {
        guard let num1 = Double(number1), let num2 = Double(number2) else {
            self.result = "Please enter valid numbers"
            return
        }
        
        let gcd = findGCD(Int(num1 * 100), Int(num2 * 100))
        let lcm = Int(num1 * 100 * num2 * 100) / gcd
        
        if isHCFSelected {
            self.result = String(Double(gcd) / 100)
        } else {
            self.result = String(Double(lcm) / 100)
        }
    }
    
    func findGCD(_ num1: Int, _ num2: Int) -> Int {
        if num2 == 0 {
            return num1
        } else {
            return findGCD(num2, num1 % num2)
        }
    }
}

struct HCF_LCM_CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        HCF_LCM_CalculatorView()
    }
}
