//
//  FavouritesView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI

struct FavouritesView: View {
    
    @ObservedObject var favouritesManager: FavouritesManager = .shared
    
    var body: some View {
        NavigationStack {
            VStack {
                if favouritesManager.favourites.isEmpty {
                    Image(systemName: "star.slash")
                        .font(.title3)
                    Text("You currently have no favourites.")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(favouritesManager.favourites, id: \.id) { favourite in
                            HStack {
                                Text(favourite.topicName)
                                
                                Spacer()
                                
                                Button {
                                    if favouritesManager.favourites.description.contains(favourite.topicName) {
                                        removeFavourite(topicName: favourite.topicName)
                                        
                                    } else {
                                        favouritesManager.favourites.insert(Favourite(topicName: favourite.topicName), at: 0)
                                    }
                                } label: {
                                    if favouritesManager.favourites.description.contains(favourite.topicName) {
                                        Image(systemName: "star.fill")
                                    } else {
                                        Image(systemName: "star")
                                    }
                                }
                            }
                            .swipeActions {
                                Button(role: .destructive) {
                                    removeFavourite(topicName: favourite.topicName)
                                } label: {
                                    Image(systemName: "star.slash")
                                }
                            }
                        }
                        .onDelete { indexSet in
                            favouritesManager.favourites.remove(atOffsets: indexSet)
                        }
                        .onMove { indices, newOffset in
                            favouritesManager.favourites.move(fromOffsets: indices, toOffset: newOffset)
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton()
                        }
                    }
                }
            }
            .navigationTitle("Favourites")
            .navigationBarTitleDisplayMode(favouritesManager.favourites.isEmpty ? .inline : .large)
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

struct FavouritesView_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesView()
    }
}
