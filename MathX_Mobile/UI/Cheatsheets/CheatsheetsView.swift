//
//  NotesView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI
import PDFKit

let sec1NoteNames = [
    "Numbers and Their Operations Part 1",
    "Numbers and Their Operations Part 2",
    "Percentages",
    "Basic Algebra and Algebraic Manipulation",
    "Linear Equations and Inequalities",
    "Functions and Linear Graphs",
    "Basic Geometry",
    "Polygons",
    "Geometrical Construction",
    "Number Sequences",
]

let sec2NoteNames = [
    "Similarity and Congruence Part 1",
    "Similarity and Congruence Part 2",
    "Ratio and Proportion",
    "Direct and Inverse Proportions",
    "Pythagoras Theorem",
    "Trigonometric Ratios",
]

let sec3NoteNames = [
    "Indices",
    "Surds",
    "Functions and Graphs",
    "Quadratic Funcations, Equations, and Inequalities",
    "Coordinate Geometry",
    "Exponentials and Logarithms",
    "Futher Coordinate Geometry",
    "Linear Law",
    "Geometrical Properties of Circles",
    "Polynomials and Partial Fractions"
]

let sec4NoteNames = [
    "Coming soon...",
]

struct CheatsheetsView: View {
    
    enum SidebarItem: String, CaseIterable, Identifiable, Hashable {
        case sec1 = "Secondary 1"
        case sec2 = "Secondary 2"
        case sec3 = "Secondary 3"
        case sec4 = "Secondary 4"

        var id: String { rawValue }
        
        var destination: some View {
            switch rawValue {
            case "Secondary 1":
                return AnyView(iPadDetailView(level: 1))
            case "Secondary 2":
                return AnyView(iPadDetailView(level: 2))
            case "Secondary 3":
                return AnyView(iPadDetailView(level: 3))
            case "Secondary 4":
                return AnyView(iPadDetailView(level: 4))
            default:
                return AnyView(EmptyView())
            }
        }
    }
    
    @State var selection: SidebarItem? = .sec1
            
    @State var showingFavouritesView = false
    
    @State var searchText = String()
    
    @ObservedObject var favouritesManager: FavouritesManager = .shared
    
    var body: some View {
        if UIScreen.main.traitCollection.userInterfaceIdiom == .phone {
            NavigationStack {
                VStack {
                    List {
                        ForEach(1...4, id: \.self) { level in
                            if !searchResults(for: level).isEmpty {
                                Section(header: Text("Secondary \(level)")) {
                                    ForEach(searchResults(for: level), id: \.self) { topic in
                                        if topic != "Coming soon..." {
                                            NavigationLink(destination: PDFViewer(topicName: topic, pdfName: topic)) {
                                                Text(topic)
                                                    .padding(.vertical, 5)
                                            }
                                            .swipeActions(allowsFullSwipe: true) {
                                                Button {
                                                    if favouritesManager.favourites.description.contains(topic) {
                                                        removeFavourite(topicName: topic)
                                                    } else {
                                                        favouritesManager.favourites.insert(Favourite(topicName: topic), at: 0)
                                                    }
                                                } label: {
                                                    Image(systemName: favouritesManager.favourites.description.contains(topic) ? "star.slash" : "star")
                                                }
                                                .tint(.yellow)
                                            }
                                        } else {
                                            Text(topic)
                                                .padding(.vertical, 5)
                                        }
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(.sidebar)
                    .searchable(text: $searchText)
                }
                .navigationTitle("Cheatsheets")
                .toolbar {
                    Button {
                        showingFavouritesView.toggle()
                    } label: {
                        Image(systemName: "star.circle")
                    }
                    .sheet(isPresented: $showingFavouritesView) {
                        FavouritesView()
                    }
                }
            }
        } else if UIScreen.main.traitCollection.userInterfaceIdiom == .pad {
            NavigationView {
                List(selection: $selection) {
                    ForEach(SidebarItem.allCases) { item in
                        NavigationLink(
                            destination: item.destination,
                            tag: item,
                            selection: $selection,
                            label: { Text(item.rawValue) }
                        )
                    }
                }
                .listStyle(.sidebar)
                .navigationTitle("Sidebar")
                
                if let selection = selection {
                    selection.destination
                }
            }
        }
    }
    
    func searchResults(for level: Int) -> [String] {
        if searchText.isEmpty {
            return getLevelNotes(for: level)
        } else {
            return getLevelNotes(for: level).filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func getLevelNotes(for level: Int) -> [String] {
        switch level {
        case 1:
            return sec1NoteNames
        case 2:
            return sec2NoteNames
        case 3:
            return sec3NoteNames
        case 4:
            return sec4NoteNames
        default:
            return [String]()
        }
    }
    
    func removeFavourite(topicName topic: String) {
        if favouritesManager.favourites.description.contains(topic) {
            var index = 0
            var i = Int()
            
            favouritesManager.favourites.forEach { favouritesIteration in
                if favouritesIteration.topicName == topic {
                    i = index
                } else {
                    index += 1
                }
            }
            
            favouritesManager.favourites.remove(at: i)
        } else {
            favouritesManager.favourites.insert(Favourite(topicName: topic), at: 0)
        }
    }
}

struct iPadDetailView: View {
    
    @State var level: Int
    @State var searchText = ""
    
    @State var showingFavouritesView = false
    
    @ObservedObject var favouritesManager: FavouritesManager = .shared

    var body: some View {
        List {
            if !searchResults(for: level).isEmpty {
                Section {
                    ForEach(searchResults(for: level), id: \.self) { topic in
                        NavigationLink(destination: PDFViewer(topicName: topic, pdfName: topic)) {
                            Text(topic)
                                .padding(.vertical, 5)
                        }
                        .swipeActions(allowsFullSwipe: true) {
                            Button {
                                if favouritesManager.favourites.description.contains(topic) {
                                    removeFavourite(topicName: topic)
                                } else {
                                    favouritesManager.favourites.insert(Favourite(topicName: topic), at: 0)
                                }
                            } label: {
                                Image(systemName: favouritesManager.favourites.description.contains(topic) ? "star.slash" : "star")
                            }
                            .tint(.yellow)
                        }
                    }
                }
            }
        }
        .navigationTitle("Secondary \(level)")
        .toolbar {
            Button {
                showingFavouritesView.toggle()
            } label: {
                Image(systemName: "star.circle")
            }
            .sheet(isPresented: $showingFavouritesView) {
                FavouritesView()
            }
        }

    }
    
    func searchResults(for level: Int) -> [String] {
        if searchText.isEmpty {
            return getLevelNotes(for: level)
        } else {
            return getLevelNotes(for: level).filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }
    
    func removeFavourite(topicName topic: String) {
        if favouritesManager.favourites.description.contains(topic) {
            var index = 0
            var i = Int()
            
            favouritesManager.favourites.forEach { favouritesIteration in
                if favouritesIteration.topicName == topic {
                    i = index
                } else {
                    index += 1
                }
            }
            
            favouritesManager.favourites.remove(at: i)
        } else {
            favouritesManager.favourites.insert(Favourite(topicName: topic), at: 0)
        }
    }
    
    func getLevelNotes(for level: Int) -> [String] {
        switch level {
        case 1:
            return sec1NoteNames
        case 2:
            return sec2NoteNames
        case 3:
            return sec3NoteNames
        case 4:
            return sec4NoteNames
        default:
            return [String]()
        }
    }
}

struct CheatsheetsView_Previews: PreviewProvider {
    static var previews: some View {
        CheatsheetsView()
    }
}
