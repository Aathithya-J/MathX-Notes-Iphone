//
//  FavouritesView.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import SwiftUI

struct FavouritesView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var favouritesManager: FavouritesManager = .shared
    
    var body: some View {
        NavigationStack {
            VStack {
                if favouritesManager.favourites.isEmpty {
                    Image(systemName: "star.slash")
                        .font(.title3)
                    Text("You currently have no favourites.\nSwipe left on a topic to favourite it!")
                        .font(.headline)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                } else {
                    List {
                        ForEach(favouritesManager.favourites, id: \.id) { favourite in
                            NavigationLink(destination: PDFViewer(topicName: favourite.topicName, pdfName: favourite.topicName)) {
                                Text(favourite.topicName)
                                    .padding(.vertical, 5)
                            }
                            .swipeActions(allowsFullSwipe: true) {
                                Button {
                                    if favouritesManager.favourites.description.contains(favourite.topicName) {
                                        removeFavourite(topicName: favourite.topicName)
                                    } else {
                                        favouritesManager.favourites.insert(Favourite(topicName: favourite.topicName), at: 0)
                                    }
                                } label: {
                                        Image(systemName: favouritesManager.favourites.description.contains(favourite.topicName) ? "star.slash" : "star")
                                }
                                .tint(.yellow)
                            }
                        }
                        .onDelete { indexSet in
                            withAnimation {
                                favouritesManager.favourites.remove(atOffsets: indexSet)
                            }
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
            .toolbar {
                Button {
                    dismiss.callAsFunction()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .accentColor(.purple)
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
