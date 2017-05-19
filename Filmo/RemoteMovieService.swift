//
//  RemoteMovieService.swift
//  Filmo
//
//  Created by jorgemoniz on 19/5/17.
//  Copyright © 2017 Jorge Moñiz. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class RemoteMovieService {
    
    // Método para buscar películas y otro para el Top con callbacks
    func getTopMovies(completionHandler : @escaping (_ arrayDiccionario : [[String : String]]?) -> ()) {
        let urlData = URL(string: "https://itunes.apple.com/es/rss/topmovies/limit=99/json")!
        
        Alamofire.request(urlData, method: .get).validate().responseJSON { (responseData) in
            switch responseData.result {
            case .success:
                if let valorData = responseData.result.value {
                    let json = JSON(valorData)
                    var resultData = [[String : String]]()
                    
                    let entries = json["feed"]["entry"].arrayValue
                    for c_entry in entries {
                        var movieDiccionario = [String : String]()
                        movieDiccionario["id"] = c_entry["id"]["attributes"]["im:id"].stringValue
                        movieDiccionario["title"] = c_entry["im:name"]["label"].stringValue
                        movieDiccionario["summary"] = c_entry["summary"]["label"].stringValue
                        movieDiccionario["image"] = c_entry["im:image"][0]["label"].stringValue.replacingOccurrences(of: "60x60", with: "500x500")
                        movieDiccionario["category"] = c_entry["category"]["attributes"]["label"].stringValue
                        movieDiccionario["director"] = c_entry["im:artist"]["label"].stringValue
                        
                        resultData.append(movieDiccionario)
                    }
                    completionHandler(resultData)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                completionHandler(nil)
            }
        }
    }
}
