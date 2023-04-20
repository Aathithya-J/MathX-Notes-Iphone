//
//  NotesView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI
import PDFKit

struct CheatsheetsView: View {
        
    @State var showingFavouritesView = false
    
    @State var searchText = String()
    
    @ObservedObject var favouritesManager: FavouritesManager = .shared
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(1...4, id: \.self) { level in
                        if !searchResults(for: level).isEmpty {
                            Section(header: Text("Secondary \(level)")) {
                                ForEach(searchResults(for: level), id: \.self) { topic in
                                    NavigationLink(destination: PDFViewer(topicName: topic, pdfName: topic)) { // use a func with switch and case to return pdf name based on topic name
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
            return [
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
        case 2:
            return [
                "Similarity and Congruence Part 1",
                "Similarity and Congruence Part 2",
                "Ratio and Prorortion",
                "Direct and Inverse Proportions",
                "Pythagoras Theorem",
                "Trigonometric Ratios",
            ]
        case 3:
            return [
                "Indices",
                "Surds",
                "Functions and Graphs",
                "Quadratic Funcations, Equations, and Inequalities",
                "Coordinate Geometry",
                "Exponentials and Logarithms",
                "Futher Coordinate Geometry",
                "Linear Law",
            ]
        case 4:
            return [
                "Coming Soon...",
            ]
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

struct CheatsheetsView_Previews: PreviewProvider {
    static var previews: some View {
        CheatsheetsView()
    }
}
