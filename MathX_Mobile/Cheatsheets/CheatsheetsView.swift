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
                                    NavigationLink(destination: PDFViewer(topicName: topic, pdfName: "Electronic Textbook")) { // use a func with switch and case to return pdf name based on topic name
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
                "sec 1 topic 1",
                "sec 1 topic 2",
            ]
        case 2:
            return [
                "sec 2 topic 1",
                "sec 2 topic 2",
            ]
        case 3:
            return [
                "sec 3 topic 1",
                "sec 3 topic 2",
            ]
        case 4:
            return [
                "sec 4 topic 1",
                "sec 4 topic 2",
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
