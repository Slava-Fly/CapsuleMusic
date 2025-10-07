//
//  SearchInteractor.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 07.10.2025.
//  Copyright (c) 2025 ___ORGANIZATIONNAME___. All rights reserved.
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
        case .some:
            print("interactor .some")
            presenter?.presentData(response: Search.Model.Response.ResponseType.some)
        case .getTracks(let searchTerm):
            print("interactor .getTracks")
            
            networkService.fetchTracks(searchText: searchTerm) { [weak self] searchResponse in
                self?.presenter?.presentData(response: Search.Model.Response.ResponseType.presentTracks(searchResponse: searchResponse))
            }
        }
    }
}
