//
//  FavouritesManager.swift
//  MathX_Mobile
//
//  Created by Tristan on 18/04/2023.
//

import Foundation

struct Favourite: Codable, Identifiable {
    var id = UUID()
    var topicName: String
}

class FavouritesManager: ObservableObject {
    static let shared: FavouritesManager = .init()
    
    @Published var favourites: [Favourite] = [] {
        didSet {
            save()
        }
    }
        
    init() {
        load()
    }
    
    func getArchiveURL() -> URL {
        let plistName = "favourites.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedFavourites = try? propertyListEncoder.encode(favourites)
        try? encodedFavourites?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
                
        if let retrievedFavouriteData = try? Data(contentsOf: archiveURL),
            let favouritesDecoded = try? propertyListDecoder.decode([Favourite].self, from: retrievedFavouriteData) {
            favourites = favouritesDecoded
        }
    }
}

