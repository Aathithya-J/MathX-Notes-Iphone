//
//  noteContentView.swift
//
//
//  Created by Tristan on 08/04/2023.
//

import SwiftUI

struct noteContentView: View {
    
    @State var note: Note
    @State var noteTitle = String()
    @State var noteContent = String()
    
    @State var showingSubjectSeletionView = false
    
    @FocusState var titleFocused
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.editMode) var editMode
    
    @ObservedObject var noteManager: NoteManager = .shared
    
    var body: some View {
        VStack {
            if editMode?.wrappedValue.isEditing == true {
                VStack {
                    HStack {
                        TextField("\(noteTitle)", text: $noteTitle)
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
            }
            
            TextEditor(text: $noteContent)
                .padding(.vertical)
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton()
            }
        }
        .onDisappear {
            updateNote()
        }
        .onAppear {
            noteTitle = note.title
            
            guard let notesContent = note.content else { return }
            noteContent = notesContent
        }
        .padding()
        .navigationTitle(editMode?.wrappedValue.isEditing == true ? "" : noteTitle)
        .navigationBarTitleDisplayMode(.inline)
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
                if noteManager.notes[i].title == noteTitle && noteManager.notes[i].content == noteContent {
                    
                } else {
                    noteManager.notes[i] = Note(title: noteTitle, content: noteContent, dateLastModified: Date())
                    
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

struct noteContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("noteContentView()")
    }
}

