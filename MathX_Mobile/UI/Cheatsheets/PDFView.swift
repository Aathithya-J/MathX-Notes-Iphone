//
//  PDFView.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let pdfDocument: PDFDocument

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.document = pdfDocument
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        uiView.document = pdfDocument
    }
}

struct PDFViewer: View {
    
    @State var showErrror = false

    @State var topicName: String
    @State var pdfName: String
    @State var pdfDocument: PDFDocument?

    var body: some View {
        VStack {
            if let pdfDocument = pdfDocument {
                PDFKitView(pdfDocument: pdfDocument)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                VStack {
                    if !showErrror {
                        ProgressView()
                            .font(.title3)
                            .fontWeight(.bold)
                        Text("Loading PDF...")
                            .font(.title)
                            .padding(.top)
                            .fontWeight(.bold)
                    } else {
                        Text("An error has occurred while trying to load PDF.")
                            .font(.title)
                            .multilineTextAlignment(.center)
                            .fontWeight(.bold)
                    }
                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                        showErrror = true
                    }
                }
            }
        }
        .toolbar(.hidden, for: .tabBar)
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle(topicName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let url = Bundle.main.url(forResource: "\(pdfName)", withExtension: "pdf") {
                pdfDocument = PDFDocument(url: url)
            }
        }
    }
}

struct PDFView_Previews: PreviewProvider {
    static var previews: some View {
        Text("PDFView()")
    }
}
