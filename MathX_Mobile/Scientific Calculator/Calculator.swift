import SwiftUI

struct CalculatorView: View {
    
    @State var shiftIndicator = false
    @State var alphaIndicator = false

    @State var calculatorOn = true
    
    @State var equationText = "Math Calculation Equation goes here. Super long scroll wheeeeee."
    @State var resultsText = "Math Calculation Result goes here. This is scrollable too!"
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .top) {
            if colorScheme == .light {
                Color.black.opacity(0.8)
                    .ignoresSafeArea()
            } else {
                Color.gray.opacity(0.35)
                    .ignoresSafeArea()
            }
            
            VStack {
                modeIndicators(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator)
                
                screenView(equationText: $equationText, resultsText: $resultsText)
                
                firstButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, calculatorOn: $calculatorOn, equationText: $equationText, resultsText: $resultsText)
            }
            .padding(.horizontal)
            .padding(.top)
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
    }
}

struct screenView: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.green.opacity(0.4)
            VStack(alignment: .trailing) {
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(equationText)
                        .lineLimit(1)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.top)
                .padding(.horizontal)
                .cornerRadius(16)
                
                Spacer()
                
                
                ScrollView(.horizontal, showsIndicators: false) {
                    Text(resultsText)
                        .lineLimit(1)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(.bottom)
                .padding(.horizontal)
                .frame(width: UIScreen.main.bounds.width / 2)
                .cornerRadius(16)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 30, height: 140)
        .cornerRadius(16)
    }
}

struct modeIndicators: View {
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool

    var body: some View {
        HStack {
            ScrollView(.horizontal) {
                HStack {
                    indicator(indicatorName: "Shift", indicatorColor: .orange, isIndicatorOn: shiftIndicator)
                    indicator(indicatorName: "Alpha", indicatorColor: .red, isIndicatorOn: alphaIndicator)
                }
            }
            
            Text("MathX-97SG X")
                .foregroundColor(.white)
                .font(.headline)
                .fontWeight(.bold)
            
        }
    }
    
    @ViewBuilder
    func indicator(indicatorName: String, indicatorColor: Color, isIndicatorOn: Bool) -> some View {
        HStack {
            Circle()
                .frame(width: 12, height: 12)
            Text(indicatorName)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .foregroundColor(isIndicatorOn ? indicatorColor : .gray)
        .padding(5)
        .background(isIndicatorOn ? indicatorColor.opacity(0.5) : .gray.opacity(0.5))
        .cornerRadius(6)
        
    }
}

struct CalculatorView_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
