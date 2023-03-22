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
    
    @Environment(\.dismiss) var dismissView
    
    var body: some View {
        HStack {
            shiftButton
            alphaButton
            
            centerArrows
            
            menuButton
            powerButton
        }
        .padding(.top)
    }
    
    
    /// Shift Button
    var shiftButton: some View {
        VStack {
            Button {
                if calculatorOn {
                    shiftIndicator.toggle() // turns shift indicator on/off
                }
                
                if alphaIndicator {
                    alphaIndicator = false // turns alpha indicator off if it is on
                }
            } label: {
                Text("S")
                    .foregroundColor(.orange)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
            }
            .frame(width: 48, height: 48)
            .buttonStyle(.plain)
            .background(.black)
            .clipShape(Circle())
        }
    }
    
    
    /// Alpha Button
    var alphaButton: some View {
        VStack {
            Button {
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
            }
            .frame(width: 48, height: 48)
            .buttonStyle(.plain)
            .background(.black)
            .clipShape(Circle())
        }
    }
    
    
    /// Center 4 arrows view
    var centerArrows: some View {
        HStack {
            Button { // left arrow
                
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .buttonStyle(.plain)
            .padding(.leading)
            .padding(.trailing, 5)
            
            VStack {
                Button { // up arrow
                    
                } label: {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                
                Button { // bottom arrow
                    
                } label: {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                .buttonStyle(.plain)
                .padding(.top, 50)
            }
            
            Button { // right arrow
                
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .buttonStyle(.plain)
            .padding(.trailing)
            .padding(.leading, 5)
        }
    }
    
    
    /// Menu Button
    var menuButton: some View {
        VStack {
            Button {
                
            } label: {
                Image(systemName: "list.dash")
                    .foregroundColor(.white)
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
            }
            .frame(width: 48, height: 48)
            .buttonStyle(.plain)
            .background(.black)
            .clipShape(Circle())
        }
    }
    
    
    /// Power Button
    var powerButton: some View {
        VStack {
            Button {
                calculatorOn.toggle() // turns calculator on/off
                
                if calculatorOn { // sets equation and results texts to something when calculator is turned on
                    equationText = "Math Calculation Equation goes here. Super long scroll wheeeeee."
                    resultsText = "Math Calculation Result goes here. This is scrollable too!"
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
            }
            .frame(width: 48, height: 48)
            .buttonStyle(.plain)
            .background(.black)
            .clipShape(Circle())
        }
    }
}

struct firstButton_Group_Previews: PreviewProvider {
    static var previews: some View {
        CalculatorView()
    }
}
