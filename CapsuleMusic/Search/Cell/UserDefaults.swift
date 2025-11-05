//
//  UserDefaults.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 18.10.2025.
//

import Foundation

extension UserDefaults {
    
    static let favouriteTrackKey = "favouriteTrackKey"
    
    func savedTracks() -> [SearchViewModel.Cell] {
        let defaults = UserDefaults.standard
        
        guard let savedTracks = defaults.object(forKey: UserDefaults.favouriteTrackKey) as? Data else {
            print("⚠️ No data found for key: \(UserDefaults.favouriteTrackKey)")
            return []
        }
        
        guard let decodedTracks = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(savedTracks) as? [SearchViewModel.Cell] else {
            print("⚠️ Failed to decode tracks from UserDefaults")
            return []
        }
        
        print("✅ Successfully loaded \(decodedTracks.count) tracks from UserDefaults")
        return decodedTracks
    }
}
