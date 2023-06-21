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
    
    @StateObject private var textViewCoordinator = TextViewCoordinator()
    
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
        .onAppear {
            textViewCoordinator.text = $noteContent
        }
        .padding(.horizontal)
        .padding(.top, editMode?.wrappedValue.isEditing == true ? 15 : 0)
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


struct TextView: UIViewRepresentable {
    @Binding var text: String
    let coordinator: TextViewCoordinator
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.preferredFont(forTextStyle: .body)
        textView.delegate = coordinator
        coordinator.textView = textView
        NotificationCenter.default.addObserver(coordinator, selector: #selector(coordinator.contentSizeCategoryDidChange), name: UIContentSizeCategory.didChangeNotification, object: nil)
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: textView.frame.size.width, height: 44))
        
        let fractionButton = UIButton(type: .custom)
        fractionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        fractionButton.setTitle("Fraction", for: .normal)
        fractionButton.setTitleColor(.white, for: .normal)
        fractionButton.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.5)
        fractionButton.layer.cornerRadius = 8
        fractionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        fractionButton.addTarget(coordinator, action: #selector (coordinator.insertFraction), for: .touchUpInside)
        
        let insertFractionButton = UIBarButtonItem(customView: fractionButton)
        
        let squareRootButton = UIButton(type: .custom)
        fractionButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        squareRootButton.setTitle("Square Root", for: .normal)
        squareRootButton.setTitleColor(.white, for: .normal)
        squareRootButton.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.5)
        squareRootButton.layer.cornerRadius = 8
        squareRootButton.addTarget(coordinator, action: #selector (coordinator.insertSquareRoot), for: .touchUpInside)
        
        let insertsquareRootButton = UIBarButtonItem(customView: squareRootButton)
        
        toolbar.items = [insertFractionButton, insertsquareRootButton]
        textView.inputAccessoryView = toolbar
        
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        
        textView.alwaysBounceVertical = true
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

class TextViewCoordinator: NSObject, UITextViewDelegate, ObservableObject {
    weak var textView: UITextView?
    var text: Binding<String>!
    
    @objc func insertFraction() {
        textView?.replace(textView?.selectedTextRange ?? UITextRange(), withText: "\\frac{1}{2}")
    }
    
    @objc func insertSquareRoot() {
        textView?.replace(textView?.selectedTextRange ?? UITextRange(), withText: "\\sqrt[3]{b^2}")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        text.wrappedValue = textView.text
    }
    
    @objc func contentSizeCategoryDidChange() {
        textView?.font = UIFont.preferredFont(forTextStyle: .body)
    }
}

struct noteContentView_Previews: PreviewProvider {
    static var previews: some View {
        Text("noteContentView()")
    }
}

