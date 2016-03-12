
//
//  MovieDetailVC.swift
//  Flicks
//
//  Created by Tien on 3/9/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit

class MovieDetailVC: UIViewController {

    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movie"
        
        self.bindMovieToViews()
        
        // Load movie detail
        MoviesLoader.sharedInstance.loadMovieDetail(self.movie.movieId!) { (movie, error) -> Void in
            if let _ = movie {
                self.movie = movie
                
                self.showMovieRuntime()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        let overviewRect = self.overviewLabel.frame;
        print(overviewRect)
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, overviewRect.origin.y + overviewRect.size.height + 10)
    }
    
    private func bindMovieToViews() {
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
        let lowResImageUrl = NSURL(string: FlickUrlUtils.lowResolutionPosterPath(self.movie.posterPath!))!
        // Do any additional setup after loading the view.
        self.posterImageView.af_setImageWithURL(lowResImageUrl)
    }
    
    private func showMovieRuntime() {
        if let runTime = self.movie.runtime {
            var content:String = ""
            if runTime == 0 {
                content.appendContentsOf("0")
            } else {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
