//
//  FlicksUrlExt.swift
//  Flicks
//
//  Created by Tien on 3/9/16.
//  Copyright © 2016 Tien. All rights reserved.
//

public class FlickUrlUtils {
    class func lowResolutionPosterPath(posterPath:String) -> String {
        return "https://image.tmdb.org/t/p/w45\(posterPath)"
    }
    
    class func mediumResolutionPosterPath(posterPath:String) -> String {
        return "https://image.tmdb.org/t/p/w342\(posterPath)"
    }
    
    class func highResolutionPosterPath(posterPath:String) -> String {
        return "https://image.tmdb.org/t/p/original\(posterPath)"
    }
}
