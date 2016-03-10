//
//  NowPlayingVC.swift
//  Flicks
//
//  Created by Tien on 3/8/16.
//  Copyright © 2016 Tien. All rights reserved.
//

import UIKit
import MBProgressHUD

class NowPlayingVC: BaseVC {
    
    @IBOutlet weak var moviesTable: UITableView!
    @IBOutlet weak var movieCollection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MessageView and its subviews
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgViewTitleLabel: UILabel!
    @IBOutlet weak var msgViewDescLabel: UILabel!
    
    let segmentedControl = UISegmentedControl()
    let refreshControl = UIRefreshControl()
    
    var mbLoadingView:MBProgressHUD?
    
    let moviesLoader = MoviesLoader()
    
    var moviesData:Array<Movie>?
    var filteredData:Array<Movie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Now playing"

        // Do any additional setup after loading the view.
        self.moviesTable.dataSource = self
        self.moviesTable.delegate = self
        
        // Setup refresh control
        self.setupRefreshControl()
        
        //
        self.setupRightBarButton()
        
        // Load movies data first time
        self.loadMoviesData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTable.insertSubview(refreshControl, atIndex: 0)
    }
    
    // MARK: - API call and handling
    private func loadMoviesData() {
        let mbLoadingView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        mbLoadingView.mode = MBProgressHUDMode.Indeterminate;
        mbLoadingView.labelText = "Loading";
        
        moviesLoader.loadNowplayingMovies { (movies, error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            
            if error != nil {
                self.handleLoadMoviesFailed(error!)
            }
            
            if movies != nil {
                self.moviesData = movies
                self.filteredData = self.moviesData
                self.handleLoadMoviesSucess()
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    
    private func handleLoadMoviesSucess() {
        self.messageView.hidden = true
        self.moviesTable.reloadData()
    }

    private func handleLoadMoviesFailed(error:NSError) {
        print("Get nowplaying movies failed \(error)")
        self.messageView.hidden = false
        
        var title = ""
        var description = ""
        if error.domain == NSURLErrorDomain {
            title = "Network error"
            description = "Please check your internet connection"
        } else {
            title = "Something failed"
            description = "Please contact thanhtien2302@gmail.com"
        }
        self.displayMessageInMessageView(title: title, description: description)
    }
    
    // MARK: - Others
    private func setupRightBarButton() {
        self.segmentedControl.insertSegmentWithImage(UIImage(named: "rating-star"), atIndex: 0, animated: false)
        self.segmentedControl.insertSegmentWithImage(UIImage(named: "rating-star"), atIndex: 1, animated: false)
        self.segmentedControl.selectedSegmentIndex = 0
        self.segmentedControl.tintColor = UIColor.redColor()
        self.segmentedControl.addTarget(self, action: "segmentControlValueChange:", forControlEvents: .ValueChanged)
        self.segmentedControl.sizeToFit()
        let rightBarButton = UIBarButtonItem(customView: segmentedControl)
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc
    private func refreshData(sender:UIRefreshControl) {
        print("Start refresh data")
        
        self.loadMoviesData()
    }
    
    @objc
    private func segmentControlValueChange(sender:UISegmentedControl) {
        print("Selected \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            self.moviesTable.hidden = false
            self.movieCollection.hidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.moviesTable.hidden = true
            self.movieCollection.hidden = false
        }
    }
    
    private func displayMessageInMessageView(title title:String, description:String) {
        self.msgViewTitleLabel.text = title
        self.msgViewDescLabel.text = description
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.moviesTable.indexPathForCell(cell)
        let movie = self.filteredData![indexPath!.row]
        
        let detailVc = segue.destinationViewController as! MovieDetailVC
        detailVc.movie = movie
    }
}

// MARK: - UITableView stuffs
extension NowPlayingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let _ = self.filteredData {
            return (self.filteredData!.count)
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movieCell = tableView.dequeueReusableCellWithIdentifier("MovieCell") as! MovieCell
        movieCell.bindMovieData(filteredData![indexPath.row])
        return movieCell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}

// MARK: - UISearchbar stuffs
extension NowPlayingVC: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        guard let _ = self.moviesData else {
            return
        }
        
        if searchText.characters.count == 0 {
            self.filteredData = self.moviesData
        } else {
            self.filteredData = self.moviesData?.filter({(movie: Movie) -> Bool in
                if movie.title?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil || movie.overview?.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                    return true
                }
                return false
            })
        }
        self.moviesTable.reloadData()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Show all movie
        searchBar.text = ""
        self.filteredData = self.moviesData
        self.moviesTable.reloadData()
        
        // Don't focus on searchbar any more
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }
}


