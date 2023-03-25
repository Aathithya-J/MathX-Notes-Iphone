//
//  firstButton Group.swift
//  MathX_Mobile
//
//  Created by Tristan on 22/03/2023.
//

import SwiftUI

struct firstButtonGroup: View {
    
    @Binding var shiftIndicator: Bool
    @Binding var alphaIndicator: Bool
    
    @Binding var calculatorOn: Bool
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    let generator = UIImpactFeedbackGenerator()
    
    @Environment(\.dismiss) var dismissView
    
    var body: some View {
        HStack(spacing: UIScreen.main.bounds.width / 40) {
            shiftButton
            alphaButton
            
            centerArrows
            
            menuButton
            powerButton
        }
        .padding(.top, 5)
    }
    
    
    /// Shift Button
    var shiftButton: some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)
                
                if calculatorOn {
                    shiftIndicator.toggle() // turns shift indicator on/off
                }
                
                if alphaIndicator {
                    alphaIndicator = false // turns alpha indicator off if it is on
                }
            } label: {
                Text("S")
                    .foregroundColor(.yellow)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8)
                    .background(.black)
            }
            .buttonStyle(.plain)
            .clipShape(Circle())
        }
    }
    
    
    /// Alpha Button
    var alphaButton: some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)

                if calculatorOn {
                    alphaIndicator.toggle() // turns alpha indicator on/off
                }
                
                if shiftIndicator {
                    shiftIndicator = false // turns shift indicator off if it is on
                }
            } label: {
                Text("A")
                    .foregroundColor(.red)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8)
                    .background(.black)
            }
            .buttonStyle(.plain)
            .clipShape(Circle())
        }
    }
    
    
    /// Center 4 arrows view
    var centerArrows: some View {
        HStack {
            Button { // left arrow
                generator.impactOccurred(intensity: 0.7)
                
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .buttonStyle(.plain)
            .padding(.leading, 5)
            .padding(.trailing, 5)
            
            VStack {
                Button { // up arrow
                    generator.impactOccurred(intensity: 0.7)
                    
                } label: {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                .padding(.bottom, UIScreen.main.bounds.height / 50)
                
                Button { // bottom arrow
                    generator.impactOccurred(intensity: 0.7)
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                .padding(.top, UIScreen.main.bounds.height / 50)
            }
            
            Button { // right arrow
                generator.impactOccurred(intensity: 0.7)
                
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .buttonStyle(.plain)
            .padding(.trailing, 5)
            .padding(.leading, 5)
        }
    }
    
    
    /// Menu Button
    var menuButton: some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)
                
            } label: {
                Text(shiftIndicator ? "SETUP" : "MENU")
                    .foregroundColor(shiftIndicator ? .yellow : .white)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding(6)
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8)
                    .background(.black)
                    .clipShape(Circle())
                    .minimumScaleFactor(0.1)
            }
            .buttonStyle(.plain)
        }
    }
    
    
    /// Power Button
    var powerButton: some View {
        VStack {
            Button {
                generator.impactOccurred(intensity: 0.7)
                
                calculatorOn.toggle() // turns calculator on/off
                
                if calculatorOn { // sets equation and results texts to something when calculator is turned on
                    equationText = ""
                    resultsText = ""
                } else { // sets equation and results texts to nothing when calculator is turned off
                    equationText = ""
                    resultsText = ""
                    
                    dismissView.callAsFunction() // uses @Environment to dismiss calculator view/go back
                }
            } label: {
                Image(systemName: "power")
                    .foregroundColor(calculatorOn ? .green : .red)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(width: UIScreen.main.bounds.width / 8, height: UIScreen.main.bounds.width / 8)
                    .background(.black)
            }
            .buttonStyle(.plain)
            .clipShape(Circle())
        }
    }
}

struct firstButton_Group_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
