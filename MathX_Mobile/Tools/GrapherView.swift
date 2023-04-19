//
//  GrapherView.swift
//  MathX_Mobile
//
//  Created by Tristan on 19/04/2023.
//

import SwiftUI
import WebKit

struct GrapherView: View {
    var body: some View {
        VStack {
            ZStack {
                Text("Loading")
                WebView(url: URL(string: "https://www.desmos.com/calculator")!)
            }
        }
        .navigationTitle("Grapher (Desmos)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

struct GrapherView_Previews: PreviewProvider {
    static var previews: some View {
        GrapherView()
    }
}
