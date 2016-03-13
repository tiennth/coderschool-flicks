//
//  MovieDetailPresenter.swift
//  Flicks
//
//  Created by Tien on 3/12/16.
//  Copyright © 2016 Tien. All rights reserved.
//

// Trying to prevent Massive View Controller :)
extension MovieDetailVC {
    
    func bindMovieToViews() {
        self.movieTitleLabel.text = movie.title!
        
        // Setup release date
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let releaseDate = dateFormatter.dateFromString(self.movie.releaseDate!)
        dateFormatter.dateStyle = .LongStyle
        self.releaseDateLabel.text = dateFormatter.stringFromDate(releaseDate!)
        
        self.popularityLabel.text = String(format: "%.0f%%", self.movie.popularity!)
        
        self.durationLabel.text = "--"
        // Setup overview text.
        self.overviewLabel.text = movie.overview!
        self.overviewLabel.sizeToFit()

        // Setup poster image.
        guard let _ = self.movie.posterPath else {
            return
        }
        
        let lowResImageUrl = NSURL(string: FlickUrlUtils.lowResolutionPosterPath(self.movie.posterPath!))!
        let highResImageUrl = NSURL(string: FlickUrlUtils.highResolutionPosterPath(self.movie.posterPath!))!
        // Do any additional setup after loading the view.
        self.posterImageView.af_setImageWithURL(lowResImageUrl) {
            response in
            // The image should only fade in if it's coming from network, not cache.

            if let _ = response.result.error {
                // Has error, do nothing more
            } else {
                self.posterImageView.alpha = 0.0
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.posterImageView.alpha = 1.0
                    }, completion: { (finished) -> Void in
                        self.posterImageView.af_setImageWithURL(highResImageUrl)
                })
            }
            
        }
    }
    
    func showMovieRuntime() {
        if let runTime = self.movie.runtime {
            var content:String = ""
            if runTime != 0 {
                let hour = runTime / 60
                let min = runTime % 60
                
                if hour > 0 {
                    content.appendContentsOf("\(hour)h ")
                }
                if min > 0 {
                    content.appendContentsOf("\(min)min")
                }
            }
            self.durationLabel.text = content
        } else {
            self.durationLabel.text = "--"
        }
    }

}
