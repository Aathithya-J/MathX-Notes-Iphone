//
//  MathX_MobileApp.swift
//  MathX_Mobile
//
//  Created by AathithyaJ on 11/3/23.
//

import SwiftUI
import Foundation

@main
struct MathX_MobileApp: App {
    
    let tools = MathXTools
    let calculatorTools = MathXCalculatorTools
    
    @State var path = NavigationPath()
    @State var calculatorDeepLinkSource = String()
    
    @State var notesDeepLinkSource = String()
    @State var isShowingReceivedNotePopUp = false
    
    @AppStorage("tabSelection", store: .standard) var tabSelection = 1
    @AppStorage("isShowingWelcomeScreen", store: .standard) var isShowingWelcomeScreen = true

    var body: some Scene {
        WindowGroup {
            ContentView(tabSelection: $tabSelection, path: $path, calculatorDeepLinkSource: $calculatorDeepLinkSource, notesDeepLinkSource: $notesDeepLinkSource, isShowingReceivedNotePopUp: $isShowingReceivedNotePopUp)
                .onOpenURL { url in
                    if !isShowingWelcomeScreen {
                        handleCalculatorDeepLink(urlString: url.description.replacingOccurrences(of: "mathx:///", with: "mathx://"))
                        handleNotesDeeplink(urlString: url.description.replacingOccurrences(of: "mathx:///", with: "mathx://"))
                    }
                }
        }
    }
    
    func handleCalculatorDeepLink(urlString: String) {
        let url = URL(string: urlString)!
        
        print("Asked to open URL: \(url.description)")

        guard let scheme = url.scheme,
              scheme.localizedCaseInsensitiveCompare("mathx") == .orderedSame
        else { return }

        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }

        guard url.host == "calculator", let source = parameters["source"] else { return }
        guard let sourceConverted = source.fromBase64() else { return }
        
        print(sourceConverted)
        self.calculatorDeepLinkSource = source
        
        tabSelection = 2
        
        path.removeLast(path.count)
        path.append(MathXTools[0])
        path.append(calculatorTools[0])
    }
    
    func handleNotesDeeplink(urlString: String) {
        let url = URL(string: urlString)!
        
        print("Asked to open URL: \(url.description)")

        guard let scheme = url.scheme,
              scheme.localizedCaseInsensitiveCompare("mathx") == .orderedSame
        else { return }

        var parameters: [String: String] = [:]
        URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems?.forEach {
            parameters[$0.name] = $0.value
        }

        guard url.host == "notes", let source = parameters["source"] else { return }
        guard let sourceConverted = source.fromBase64() else { return }
        
        print(sourceConverted)
        self.notesDeepLinkSource = sourceConverted
        
        tabSelection = 0
        isShowingReceivedNotePopUp = true
    }
}
