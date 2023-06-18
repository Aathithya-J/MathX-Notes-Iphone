//
//  ScientificCalculatorView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/06/2023.
//

import SwiftUI

struct ScientificCalculatorView: View {
    
    @State private var orientation = UIDeviceOrientation.unknown
    @Binding var path: NavigationPath
    
    @State var shiftIndicator = false
    @State var alphaIndicator = false
    
    @State var equalsPressed = false
    @State var sqrtPressed = false
    
    @State var errorOccurred = false
    
    @State var calculatorOn = true
    
    @State var equationText = ""
    @State var resultsText = ""
    
    @State var showingSharingScreen = false
    @State var qrCodeImage = UIImage()
    
    @State var encodedDeepLink = String()
    @Binding var deepLinkSource: String
    
    @Environment(\.dismiss) var dismiss
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
            
            VStack(alignment: .center) {
                
                Spacer()
                Spacer()
                Spacer()
                
                
                CalculatorModeIndicators(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator)
                    .padding(.horizontal, 5)
                
                if !showingSharingScreen {
                    ScreenView(equationText: $equationText, resultsText: $resultsText, errorOccurred: $errorOccurred)
                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 6)
                } else {
                    SharingScreenView(equationText: $equationText, resultsText: $resultsText, showingSharingScreen: $showingSharingScreen, qrCodeImage: $qrCodeImage)
                        .frame(width: UIScreen.main.bounds.width - 30, height: UIScreen.main.bounds.height / 6)
                }
                
                firstButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, calculatorOn: $calculatorOn, equationText: $equationText, resultsText: $resultsText, showingQRScreen: $showingSharingScreen)
                
                secondButtonGroup(qrCodeImage: $qrCodeImage, shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred, encodedDeepLink: $encodedDeepLink, showingQRScreen: $showingSharingScreen)
                
                thirdButtonGroup(shiftIndicator: $shiftIndicator, alphaIndicator: $alphaIndicator, equationText: $equationText, resultsText: $resultsText, equalsPressed: $equalsPressed, errorOccurred: $errorOccurred, showingQRScreen: $showingSharingScreen, encodedDeepLink: $encodedDeepLink)
                    .padding(.bottom, 5)
                
                Spacer()
                Spacer()
            }
            .padding(.horizontal)
            .onChange(of: equalsPressed) { value in
//                equalsButtonPressed()
            }
            .onAppear {
//                receivedDeepLinkSource()
            }
            .onChange(of: deepLinkSource) { newValue in
//                receivedDeepLinkSource()
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
        .statusBar(hidden: true)
        .onRotate { newOrientation in
            if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                orientation = newOrientation
                dismiss.callAsFunction()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500)) {
                    path.append(MathXCalculatorTools[0])
                }
            }
        }
    }
}
