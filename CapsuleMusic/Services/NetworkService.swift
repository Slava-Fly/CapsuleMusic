//
//  NetworkService.swift
//  CapsuleMusic
//
//  Created by Славка Корн on 07.10.2025.
//

import UIKit
import Alamofire

class NetworkService {
    
    func fetchTracks(searchText: String, completion: @escaping (SearchResponse?) -> Void) {
        let url = "https://itunes.apple.com/search"
        let parametres = [
            "term" : "\(searchText)",
            "limit" : "10"
        ]
        
        AF.request(url, method: .get, parameters: parametres, encoding: URLEncoding.default, headers: nil)
    
            .responseData { dataResponse in
                
            switch dataResponse.result {
            case .success(let data):
                let decoder = JSONDecoder()
                
                do {
                    let objects = try decoder.decode(SearchResponse.self, from: data)
                    print("objects:", objects)
                    completion(objects)

                } catch let jsonDecoder {
                    print("Failed to decode JSON", jsonDecoder.localizedDescription)
                    completion(nil)
                }

            case .failure(let error):
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
