//
//  MovieCellBinder.swift
//  Flicks
//
//  Created by Tien on 3/8/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit
import AlamofireImage

extension MovieCell {
    func bindMovieData(movie:Movie) {
        if let posterPath = movie.posterPath {
            self.posterImageView.af_setImageWithURL(NSURL(string: FlickUrlUtils.mediumResolutionPosterPath(posterPath))!, placeholderImage:UIImage(named: "placeholder"))
        }
        
        self.titleLabel.text = movie.title!
        self.overviewLabel.text = movie.overview!
        
        if let vote = movie.voteAverage {
            self.voteAverageLabel.text = String.init(format: "%.1f", vote)
        } else {
            self.voteAverageLabel.text = ""
        }
    }
}

extension MovieCollectionCell {
    func bindMovieData(movie:Movie) {
        if let posterPath = movie.posterPath {
            self.posterImageView.af_setImageWithURL(NSURL(string: FlickUrlUtils.mediumResolutionPosterPath(posterPath))!, placeholderImage:UIImage(named: "placeholder"))
        }
        self.movieTitleLabel.text = movie.title!
    }
}
