//
//  ReceivedNotePopUp.swift
//  MathX_Mobile
//
//  Created by Tristan Chay on 22/6/23.
//

import SwiftUI
import LaTeXSwiftUI
import MarkdownUI

struct ReceivedNotePopUp: View {
    
    @State var title = String()
    @State var content = String()
    @State var mathRendering = Bool()
    
    @State var showingEquationsFAQ = false
    
    @Binding var notesDeepLinkSource: String
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var noteManager: NoteManager = .shared
    
    @AppStorage("notesCreated", store: .standard) var notesCreated = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Text(title)
                } header: {
                    Text("Title")
                }
                
                Section {
                    Toggle(isOn: $mathRendering) {
                        HStack {
                            Text("Math Rendering")
                            
                            Button {
                                showingEquationsFAQ.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.headline)
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $showingEquationsFAQ) {
                                mathEquationFAQ()
                            }
                        }
                    }
                } header: {
                    Text("Math Rendering")
                }
                
                Section {
                    if mathRendering {
                        LaTeX(content)
                            .parsingMode(.onlyEquations)
                            .imageRenderingMode(.template)
                            .errorMode(.original)
                            .blockMode(.alwaysInline)
                    } else {
                        Markdown { content }
                            .markdownTheme(.mathx)
                    }
                } header: {
                    Text("Content")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation {
                            var currentNotesList = noteManager.notes
                            
                            currentNotesList.insert(Note(title: title, content: content, latexRendering: mathRendering, dateLastModified: Date()), at: 0)
                            
                            let sortedNewNotesList = currentNotesList.sorted(by: { $0.dateLastModified.compare($1.dateLastModified) == .orderedDescending })
                            
                            noteManager.notes = sortedNewNotesList
                            
                            notesCreated += 1
                            
                            dismiss.callAsFunction()
                        }
                        
                        dismiss.callAsFunction()
                    } label: {
                        Label("Add to Notes", systemImage: "plus")
                    }
                    .tint(.purple)
                }
            }
            .navigationTitle("Preview")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            let noteSource = receivedDeepLinkSource(sourceString: notesDeepLinkSource)
            
            if noteSource.count != 3 {
                dismiss.callAsFunction()
            } else {
                title = noteSource[0]
                content = noteSource[1]
                
                if noteSource[2] == "true" {
                    mathRendering = true
                } else {
                    mathRendering = false
                }
            }
        }
    }
    
    func receivedDeepLinkSource(sourceString: String) -> [String] {
        let sourceStringArray = sourceString.components(separatedBy: " ␢␆␝⎠⎡⍰⎀ ")
        return sourceStringArray
    }
}

//#Preview {
//    ReceivedNotePopUp()
//}
