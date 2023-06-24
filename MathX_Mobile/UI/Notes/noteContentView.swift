//
//  noteContentView.swift
//
//
//  Created by Tristan on 08/04/2023.
//

import SwiftUI
import MarkdownUI
import LaTeXSwiftUI

struct noteContentView: View {
    
    @State var note: Note
    @State var noteTitle = String()
    @State var noteContent = String()
    @State var noteLatexRendering = Bool()
    
    @State var showingSubjectSeletionView = false
    
    @State var showingEquationsFAQ = false
    
    @FocusState var titleFocused
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    @ObservedObject var noteManager: NoteManager = .shared
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue.isEditing == true {
//                ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    VStack {
                        HStack {
                            TextField("\(note.title)", text: $noteTitle)
                                .font(.largeTitle)
                                .fontWeight(.heavy)
                                .focused($titleFocused)
                                .disabled(editMode?.wrappedValue.isEditing == false)
                            
                            Spacer()
                            
                            Menu {
                                Button(role: .destructive) {
                                    withAnimation {
                                        removeNote(note: note)
                                    }
                                } label: {
                                    Label("Confirm Delete", systemImage: "trash")
                                }
                            } label: {
                                Button(role: .destructive) {
                                    
                                } label: {
                                    Image(systemName: "trash")
                                        .font(.title2)
                                }
                            }
                        }
                        
                        HStack {
                            Image(systemName: "sum")
                                .foregroundColor(.gray)
                                .padding(.horizontal, 3)
                            
                            Text("**Math Rendering**")
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .foregroundColor(.gray)
                            
                            Button {
                                showingEquationsFAQ.toggle()
                            } label: {
                                Image(systemName: "questionmark.circle.fill")
                                    .foregroundColor(.blue)
                                    .font(.title3)
                            }
                            .buttonStyle(.plain)
                            .sheet(isPresented: $showingEquationsFAQ) {
                                mathEquationFAQ()
                            }
                            
                            Toggle("", isOn: $noteLatexRendering)
                        }
                        
                        HStack {
                            Image(systemName: "text.append")
                                .foregroundColor(.gray)
                            Text("**Last Modified**")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(note.dateLastModified, format: .dateTime.day().month().year().hour().minute().second())
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.trailing)
                        }
                        .padding(.vertical, 7.5)
                        
                        Divider()
                            .padding(.vertical, 7.5)
                    }
                    .padding(.horizontal)
                    
                    TextEditor(text: $noteContent)
                        .scrollIndicators(.hidden)
//                        .scrollDisabled(true)
//                    TextView(text: $noteContent, coordinator: textViewCoordinator)
                }
            } else {
                if noteLatexRendering {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            LaTeX(noteContent)
                                .parsingMode(.onlyEquations)
                                .imageRenderingMode(.template)
                                .errorMode(.original)
                                .blockMode(.alwaysInline)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.bottom, editMode?.wrappedValue.isEditing == false ? 15 : 0)
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        HStack {
                            Markdown(noteContent)
                                .markdownTheme(.mathx)
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding(.bottom, editMode?.wrappedValue.isEditing == false ? 15 : 0)
//                    TextView(text: $noteContent, coordinator: textViewCoordinator)
                }
            }
            
        }
        .toolbar(.hidden, for: .tabBar)
        .toolbar(.hidden, for: .bottomBar)
        .ignoresSafeArea(edges: .bottom)
        .ignoresSafeArea(.keyboard)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: URL(string: noteURL(base64: convertNoteToBase64(note: note)))!)
                    .tint(.purple)
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onChange(of: editMode?.wrappedValue.isEditing) { value in
            if editMode?.wrappedValue.isEditing == false {
                if noteTitle.isEmpty {
                    noteTitle = note.title
                }
            }
        }
        .onChange(of: editMode?.wrappedValue.isEditing) { newValue in
            if newValue == false {
                updateNote()
                print("updated")
            }
        }
        .onDisappear {
            updateNote()
        }
        .onAppear {
            noteTitle = note.title
            noteLatexRendering = note.latexRendering
            
            guard let notesContent = note.content else { return }
            noteContent = notesContent
        }
        .padding(.horizontal)
        .padding(.top, editMode?.wrappedValue.isEditing == true ? 15 : 0)
        .navigationTitle(editMode?.wrappedValue.isEditing == true ? "" : noteTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func convertNoteToBase64(note: Note) -> String {
        let stringToBeConverted = "\(note.title) ␢␆␝⎠⎡⍰⎀ \(note.content ?? "") ␢␆␝⎠⎡⍰⎀ \(note.latexRendering ? "true" : "false")"
        
        return stringToBeConverted.toBase64()
    }
    
    func noteURL(base64: String) -> String {
        return "mathx:///notes?source=\(base64)"
    }
    
    func updateNote() {
        var index = 0
        var i = Int()
        
        noteManager.notes.forEach { note in
            if note.id == self.note.id {
                i = index
            } else {
                index += 1
            }
        }
        
        if noteManager.notes.count > 0 {
            if noteManager.notes[i].id == note.id {
                if noteManager.notes[i].title == noteTitle && noteManager.notes[i].content == noteContent && note.latexRendering == noteLatexRendering {
                    
                } else {
                    noteManager.notes[i] = Note(title: noteTitle.isEmpty ? note.title : noteTitle, content: noteContent, latexRendering: noteLatexRendering, dateLastModified: Date())
                    
                    let currentNotesList = noteManager.notes
                    
                    let sortedNewNotesList = currentNotesList.sorted(by: { $0.dateLastModified.compare($1.dateLastModified) == .orderedDescending })
                    
                    noteManager.notes = sortedNewNotesList
                }
            }
        }
    }
    
    func removeNote(note: Note) {
        dismiss.callAsFunction()
        
        var index = 0
        var i = Int()
        
        noteManager.notes.forEach { noteIteration in
            if noteIteration.id == note.id {
                i = index
            } else {
                index += 1
            }
        }
        
        noteManager.notes.remove(at: i)
    }
}
