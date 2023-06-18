//
//  SharingScreenView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/06/2023.
//

import SwiftUI

struct SharingScreenView: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var showingSharingScreen: Bool
    @Binding var qrCodeImage: UIImage
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.green.opacity(0.4)
            
            VStack(alignment: .center) {
                GeometryReader { geometry in
                    HStack(alignment: .center) {
                        Spacer()
                        VStack {
                            Spacer()
                            Image(uiImage: qrCodeImage)
                                .interpolation(.none)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.height - 30, height: geometry.size.height - 30, alignment: .center)
                            Spacer()
                        }
                        .padding(.leading)
                        
                        VStack(alignment: .leading) {
                            Text("Press [AC] to go back")
                            Text("Press [DEL] to copy link to clipboard")
                                .padding(.top, 2)
                            Text("Press [\(Image(systemName: "square.and.arrow.up"))] to open share sheet")
                                .padding(.top, 2)
                        }
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        Spacer()
                    }
                }
            }
        }
        .cornerRadius(16)
    }
}

