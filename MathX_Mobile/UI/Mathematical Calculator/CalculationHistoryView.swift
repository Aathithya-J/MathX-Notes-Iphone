//
//  CalculationHistoryView.swift
//  MathX_Mobile
//
//  Created by Tristan on 20/04/2023.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct CalculationHistoryView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var calculationManager: CalculationHistoryManager = .shared
        
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    Section {
                        ForEach(calculationManager.calculations, id: \.id) { calculation in
                            NavigationLink(destination: shareCalculationSubview(calculation: calculation)) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(calculation.equationText)
                                            .font(.title2)
                                            .lineLimit(1)
                                        SubSuperScriptText(inputString: calculation.resultsText, bodyFont: .headline, subScriptFont: .caption, baseLine: 6.0)
                                            .font(.headline)
                                            .foregroundColor(.gray)
                                            .lineLimit(1)
                                    }
                                }
                                .fontWeight(.bold)
                                .padding(.vertical, 7.5)
                            }
                        }
                        .onDelete { indexOffset in
                            calculationManager.calculations.remove(atOffsets: indexOffset)
                        }
                    } header: {
                        HStack {
                            Label("History", systemImage: "clock.arrow.2.circlepath")
                            
                            Spacer()
                            
                            
                            Menu {
                                Button(role: .destructive) {
                                    calculationManager.calculations = []
                                } label: {
                                    Label("Confirm Delete", systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            
                            .textCase(nil)
                        }
                    }
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss.callAsFunction()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}

struct shareCalculationSubview: View {
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var qrCodeImage = UIImage()
    
    @State var copiedToClipboard = false
    @State var savedAns = false

    @State var calculation: Calculation
    @AppStorage("lastAns", store: .standard) var lastAns = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text(calculation.equationText)
                            .font(.title2)
                            .lineLimit(1)
                        SubSuperScriptText(inputString: calculation.resultsText, bodyFont: .headline, subScriptFont: .caption, baseLine: 6.0)
                            .font(.headline)
                            .foregroundColor(.gray)
                            .lineLimit(1)
                    }
                    .fontWeight(.bold)
                    .padding(.vertical, 7.5)
                    
//                    Button {
//                        lastAns = calculation.resultsText
//                        savedAns = true
//                    } label: {
//                        if savedAns {
//                            Label("Saved answer to Ans", systemImage: "checkmark.circle")
//                                .foregroundColor(.green)
//                        } else {
//                            Text("Save answer to Ans")
//                        }
//                    }
//                    .fontWeight(.bold)
                }
                
                Section {
                    HStack {
                        Spacer()
                        Image(uiImage: qrCodeImage)
                            .interpolation(.none)
                            .resizable()
                            .scaledToFit()
                            .frame(width: UIScreen.main.bounds.width - 100)
                            .frame(height: UIScreen.main.bounds.width - 100)
                        Spacer()
                    }
                }
                
                Section {
                    ShareLink(item: URL(string: "\(calculation.base64encoded)")!) {
                        Label("Share link", systemImage: "square.and.arrow.up")
                    }
                    
                    Button {
                        UIPasteboard.general.string = "\(calculation.base64encoded)"
                        copiedToClipboard = true
                    } label: {
                        if copiedToClipboard {
                            Label("Copied to Clipboard", systemImage: "checkmark.circle")
                                .foregroundColor(.green)
                        } else {
                            Text("Copy link to Clipboard")
                        }
                    }
                }
                .fontWeight(.bold)
            }
        }
        .onAppear {
            print(calculation)
            copiedToClipboard = false
            qrCodeImage = generateQRCode(from: "\(calculation.base64encoded)")
        }
    }
    
    func generateQRCode(from string: String) -> UIImage {
        filter.message = Data(string.utf8)

        if let outputImage = filter.outputImage {
            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                return UIImage(cgImage: cgimg)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}

struct CalculationHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        CalculationHistoryView()
    }
}
