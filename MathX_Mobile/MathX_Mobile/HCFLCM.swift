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
            
            TextField("Enter the first number", text: $number1)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Enter the second number", text: $number2)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                self.calculate()
            }) {
                Text("Calculate")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 10)
            
            Text("Result: \(result)")
                .padding()
            
            Spacer()
        }
        .navigationTitle("HCF & LCM Calculator")
    }
    
    func calculate() {
        guard let num1 = Int(number1), let num2 = Int(number2) else {
            self.result = "Please enter valid numbers"
            return
        }
        
        let gcd = findGCD(num1, num2)
        let lcm = num1 * num2 / gcd
        
        if isHCFSelected {
            self.result = String(gcd)
        } else {
            self.result = String(lcm)
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
