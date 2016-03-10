
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
    var movie:Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movie"

        // Do any additional setup after loading the view.
        self.posterImageView.af_setImageWithURL(NSURL(string: FlickUrlUtils.highResolutionPosterPath(self.movie.posterPath!))!)
    }

    override func viewWillAppear(animated: Bool) {
        let backButton = UIBarButtonItem(title: "Back", style: UIBarButtonItemStyle.Plain, target: self, action: nil)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
