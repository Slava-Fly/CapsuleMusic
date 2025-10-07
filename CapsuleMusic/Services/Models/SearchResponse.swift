//
//  SearchResponse.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 07.10.2025.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var trackName: String
    var collectionName: String?
    var artistName: String
    var atworkUrl100: String?
}
