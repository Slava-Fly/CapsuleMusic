//
//  SearchInteractor.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 07.10.2025.
//

import UIKit

protocol SearchBusinessLogic {
  func makeRequest(request: Search.Model.Request.RequestType)
}

class SearchInteractor: SearchBusinessLogic {
    
    var presenter: SearchPresentationLogic?
    var service: SearchService?
    var networkService = NetworkService()
    
    func makeRequest(request: Search.Model.Request.RequestType) {
        if service == nil {
            service = SearchService()
        }
        
        switch request {
        case .getTracks(let searchTerm):
            print("interactor .getTracks")
            presenter?.presentData(response: Search.Model.Response.ResponseType.presentFooterView)
            
            networkService.fetchTracks(searchText: searchTerm) { [weak self] searchResponse in
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
            }
        }
    }
}
