//
//  NotesGridView.swift
//
//
//  Created by Tristan on 06/04/2023.
//

import SwiftUI

enum Focusable: Hashable {
    case none
    case identifier(id: UUID)
}

struct NotesView: View {
    
    @State var searchText = String()
    
    @Binding var notesDeepLinkSource: String
    @Binding var isShowingReceivedNotePopUp: Bool
    
    @State var showingAddNewNoteView = false
    @ObservedObject var noteManager: NoteManager = .shared
    
    @FocusState var focused: Focusable?
    
    var body: some View {
        NavigationStack {
            VStack {
                if noteManager.notes.count > 0 {
                    GeometryReader { geometry in
                        List {
                            ForEach(searchResults, id: \.id) { note in
                                NavigationLink(destination: noteContentView(note: note)) {
                                    VStack(alignment: .leading) {
                                        Text(note.title)
                                            .font(.title3)
                                            .fontWeight(.bold)
                                        
                                        Text(note.dateLastModified, format: .dateTime.day().month().year().hour().minute().second())
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                    }
                                    .padding(.vertical, 5)
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                    ShareLink(item: URL(string: noteURL(base64: convertNoteToBase64(note: note)))!)
                                        .tint(.blue)
                                }
                                .contextMenu {
                                    ShareLink(item: URL(string: noteURL(base64: convertNoteToBase64(note: note)))!)
                                    
                                    Divider()
                                    
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
                                            Label("Delete", systemImage: "trash")
                                        }
                                        .tint(.red)
                                    }
                                } preview: {
                                    NavigationStack {
                                        noteContentView(note: note)
                                            .accentColor(.purple)
                                    }
                                }
                            }
                            .onDelete { indexOffset in
                                withAnimation {
                                    noteManager.notes.remove(atOffsets: indexOffset)
                                }
                            }
                        }
                    }
                    .searchable(text: $searchText)
                } else {
                    VStack {
                        Text("You have no Notes. Create one by tapping the + icon in the top right hand corner!")
                            .padding(.top)
                            .font(.headline)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Notes")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                        .disabled(noteManager.notes.count < 1)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddNewNoteView.toggle()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddNewNoteView) {
            addNewNoteView()
        }
        .sheet(isPresented: $isShowingReceivedNotePopUp) {
            ReceivedNotePopUp(notesDeepLinkSource: $notesDeepLinkSource)
                .presentationDetents([.medium, .large])
        }
    }
    
    func convertNoteToBase64(note: Note) -> String {
        let stringToBeConverted = "\(note.title) ␢␆␝⎠⎡⍰⎀ \(note.content ?? "") ␢␆␝⎠⎡⍰⎀ \(note.latexRendering ? "true" : "false")"
        
        return stringToBeConverted.toBase64()
    }
    
    func noteURL(base64: String) -> String {
        return "mathx:///notes?source=\(base64)"
    }
    
    func removeNote(note: Note) {
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
    
    var searchResults: [Note] {
        if searchText.isEmpty {
            return noteManager.notes
        } else {
            return noteManager.notes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        Text("NotesView()")
    }
}
