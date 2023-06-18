//
//  ScreenView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/06/2023.
//

import SwiftUI
import LaTeXSwiftUI

struct ScreenView: View {
    
    @Binding var equationText: String
    @Binding var resultsText: String
    
    @Binding var errorOccurred: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.green.opacity(0.4)
            VStack(alignment: .trailing) {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            if equationText.contains("ERROR:") {
                                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                                    Text("\(equationText)")
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    Text("\(equationText)")
                                        .lineLimit(1)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            } else {
                                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                                    LaTeX("\(equationText)")
                                        .parsingMode(.all)
                                        .imageRenderingMode(.template)
                                        .errorMode(.original)
                                        .blockMode(.alwaysInline)
                                        .lineLimit(1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } else {
                                    LaTeX("\(equationText)")
                                        .parsingMode(.all)
                                        .imageRenderingMode(.template)
                                        .errorMode(.original)
                                        .blockMode(.alwaysInline)
                                        .lineLimit(1)
                                        .font(.title3)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                            }
                            
                            HStack {Spacer()}
                                .id(1)
                        }
                    }
                    .padding(.top)
                    .padding(.horizontal)
                    .cornerRadius(16)
                    .onChange(of: equationText, perform: { value in
                        if !equationText.contains("ERROR:") {
                            proxy.scrollTo(1)
                        }
                    })
                }
                
                if errorOccurred {
                    if !equationText.contains("SQRT") {
                        Text("Press [AC key] to restore equation")
                            .lineLimit(1)
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.top, 5)
                            .padding(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Text("Press [any button] to remove equation")
                        .lineLimit(1)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
                if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
                    SubSuperScriptText(inputString: resultsText, bodyFont: .title, subScriptFont: .callout, baseLine: 10.0)
                        .parsingMode(.all)
                        .imageRenderingMode(.template)
                        .errorMode(.original)
                        .blockMode(.alwaysInline)
                        .lineLimit(1)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: .trailing)
                        .cornerRadius(16)
                } else {
                    SubSuperScriptText(inputString: resultsText, bodyFont: .title2, subScriptFont: .callout, baseLine: 6.0)
                        .parsingMode(.all)
                        .imageRenderingMode(.template)
                        .errorMode(.original)
                        .blockMode(.alwaysInline)
                        .lineLimit(1)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.bottom)
                        .padding(.horizontal)
                        .frame(maxWidth: UIScreen.main.bounds.width / 2, alignment: .trailing)
                        .cornerRadius(16)
                }
            }
        }
        .cornerRadius(16)
    }
}
