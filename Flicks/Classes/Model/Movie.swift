//
//  Movie.swift
//  Flicks
//
//  Created by Tien on 3/8/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit

class Movie: NSObject {
    /*
    poster_path: "/inVq3FRqcYIRl2la8iZikYYxFNR.jpg",
    adult: false,
    overview: "Based upon Marvel Comics’ most unconventional anti-hero, DEADPOOL tells the origin story of former Special Forces operative turned mercenary Wade Wilson, who after being subjected to a rogue experiment that leaves him with accelerated healing powers, adopts the alter ego Deadpool. Armed with his new abilities and a dark, twisted sense of humor, Deadpool hunts down the man who nearly destroyed his life.",
    release_date: "2016-02-09",
    genre_ids: [
    12,
    28,
    35
    ],
    id: 293660,
    original_title: "Deadpool",
    original_language: "en",
    title: "Deadpool",
    backdrop_path: "/n1y094tVDFATSzkTnFxoGZ1qNsG.jpg",
    popularity: 52.043383,
    vote_count: 1802,
    video: false,
    vote_average: 7.27
    */
    
    var posterPath:String?
    var adult:Bool?
    var overview:String?
    var releaseDate:String?
    var genreIds:[Int]?
    var movieId:Int?
//    var originalTitle:String?
//    var originalLanguage:String?
    var title:String?
    var backdropPath:String?
    var voteCount:Int?
    var video:Bool?
    var voteAverage:Float?
    var popularity:Float?
    var runtime:Int?
    
    init(json:NSDictionary) {
        self.posterPath = json["poster_path"] as? String
        self.adult = json["adult"] as? Bool
        self.overview = json["overview"] as? String
        self.releaseDate = json["release_date"] as? String
        self.genreIds = json["genre_ids"] as? [Int]
        self.movieId = json["id"] as? Int
//        self.originalTitle = json["original_title"] as? String
//        self.originalLanguage = json["original_language"] as? String
        self.title = json["title"] as? String
        self.backdropPath = json["backdrop_path"] as? String
        self.voteCount = json["vote_count"] as? Int
        self.video = json["video"] as? Bool
        self.voteAverage = json["vote_average"] as? Float
        self.popularity = json["popularity"] as? Float
        self.runtime = json["runtime"] as? Int
    }
}










