
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
    var isAnimating = false
    var maxDetailViewAlpha:CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movie"
        
        self.maxDetailViewAlpha = self.scrollView.alpha
        let tapOnPosterGesture = UITapGestureRecognizer(target: self, action: "posterImageViewDidClick:")
        self.posterImageView.addGestureRecognizer(tapOnPosterGesture)
        
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
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, overviewRect.origin.y + overviewRect.size.height + 10)
    }
    
    @objc
    private func posterImageViewDidClick(sender:UIView) {
        if self.isAnimating {
            return
        }
        
        let isHidden = self.scrollView.hidden
        self.scrollView.hidden = false

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.isAnimating = true
            self.scrollView.alpha = isHidden ? self.maxDetailViewAlpha : 0
            }) { (finished) -> Void in
                self.scrollView.hidden = !isHidden
                self.isAnimating = false
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
