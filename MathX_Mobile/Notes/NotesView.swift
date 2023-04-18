//
//  NotesView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI



struct NotesView: View {
    
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
                                    HStack {
                                        Text(topic)
                                        
                                        Spacer()
                                        
                                        Button {
                                            if favouritesManager.favourites.description.contains(topic) {
                                                removeFavourite(topicName: topic)
                                            } else {
                                                favouritesManager.favourites.insert(Favourite(topicName: topic), at: 0)
                                            }
                                        } label: {
                                            if favouritesManager.favourites.description.contains(topic) {
                                                Image(systemName: "star.fill")
                                            } else {
                                                Image(systemName: "star")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .searchable(text: $searchText)
            }
            .navigationTitle("Notes")
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
            return sec1Notes
        case 2:
            return sec2Notes
        case 3:
            return sec3Notes
        case 4:
            return sec4Notes
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

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView()
    }
}
