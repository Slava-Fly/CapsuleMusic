//
//  SearchModels.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 07.10.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Search {
   
  enum Model {
    struct Request {
      enum RequestType {
        case some
        case getTracks(searchTerm: String)
      }
    }
    struct Response {
      enum ResponseType {
        case some
          case presentTracks(searchResponse: SearchResponse?)
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case some
          case displayTracks(searchViewModel: SearchViewModel)
      }
    }
  }
}


struct SearchViewModel {
    struct Cell: TrackCellViewModel {
        var iconUrlString: String?
        var trackName: String
        var collectionName: String
        var artistName: String
        var previewUrl: String?
    }
    
    let cells: [Cell]
}
