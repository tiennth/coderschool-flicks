//
//  ResourcesManager.swift
//  Flicks
//
//  Created by Tien on 3/8/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit
import Alamofire

class MoviesLoader: NSObject {
    let BASE_API = "https://api.themoviedb.org/3/movie/"

    func loadNowplayingMovies(withComplete completehandler: (movies:Array<Movie>?, error:NSError?) -> Void ) {
        let unknownError = NSError(domain: kFlicksErrorDomain, code: kSomethingWentWrongErrorCode, userInfo: [NSLocalizedDescriptionKey:"Can not read API key, please check again"])
        guard let apiKey = readApiKey() else {
            completehandler(movies: nil, error: unknownError)
            return
        }
        
        Alamofire.request(.GET, self.makeNowPlayingMoviesRequestURL(apiKey)).responseJSON {
            response in
            
            // If something went wrong and Alamofire can handle it
            if let _ = response.result.error {
                completehandler(movies: nil, error: response.result.error)
                return
            }
            
            // Now get the movies array
            var moviesArray:[Movie]? = nil
            if let json = response.result.value {
                if let jsonResult = json["results"] {
                    moviesArray = [Movie]()
                    let resultArray = jsonResult as! [Dictionary<String, AnyObject>]
                    for dic in resultArray {
                        moviesArray!.append(Movie(json: dic))
                    }
                }
            }
            
            if let _ = moviesArray {
                completehandler(movies: moviesArray, error: nil)
            } else {
                completehandler(movies: nil, error: unknownError)
            }
        }
    }
    
    func readApiKey() -> String? {
        let plistPath = NSBundle.mainBundle().pathForResource("Keys", ofType: "plist")
        if let uwPlistPath = plistPath {
            let content = NSDictionary.init(contentsOfFile: uwPlistPath)!
            return content["moviesdb_key"] as? String;
        }
        return nil
    }
    
    // Create URLs utilities
    func makeNowPlayingMoviesRequestURL(apiKey:String) -> String {
        return "\(BASE_API)now_playing?api_key=\(apiKey)"
    }
}
