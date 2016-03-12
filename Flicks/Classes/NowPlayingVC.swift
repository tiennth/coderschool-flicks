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
    
    // MessageView and its subviews
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var msgViewTitleLabel: UILabel!
    @IBOutlet weak var msgViewDescLabel: UILabel!
    
    var endPoint:MovieEndpoint!
    
    // Navigation bar's buttons
    var leftBarButton:UIBarButtonItem!
    var rightBarButton:UIBarButtonItem!
    var searchBar:UISearchBar!
    var isSearchBarVisible:Bool = false
    
    let refreshControl = UIRefreshControl()
    let collectionViewRefreshControl = UIRefreshControl()
    
    var mbLoadingView:MBProgressHUD?
    
    let moviesLoader = MoviesLoader.sharedInstance;

    var moviesData:Array<Movie>?
    var filteredData:Array<Movie>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.endPoint == MovieEndpoint.NowPlaying {
            self.title = "Now playing"
        } else if self.endPoint == MovieEndpoint.TopRated {
            self.title = "Top rated"
        }

        // Do any additional setup after loading the view.
        self.moviesTable.dataSource = self
        self.moviesTable.delegate = self
        
        self.movieCollection.dataSource = self
        self.movieCollection.delegate = self
        
        // Setup refresh control
        self.setupRefreshControl()
        
        //
        self.createLeftBarButton()
        self.createRightBarButton()
        self.createSearchBarNavigationItem()
        
        self.showLeftBarButton(true)
        self.showRightBarButton(true)
        
        // Load movies data first time
        self.loadMoviesData()
    }

    override func viewWillDisappear(animated: Bool) {
        self.searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.isSearchBarVisible {
            self.searchBar.becomeFirstResponder()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        collectionViewRefreshControl.addTarget(self, action: "refreshData:", forControlEvents: UIControlEvents.ValueChanged)
        self.moviesTable.insertSubview(refreshControl, atIndex: 0)
        self.movieCollection.insertSubview(refreshControl, atIndex: 0)
    }
    
    // MARK: - API call and handling
    private func loadMoviesData() {
        let mbLoadingView = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        mbLoadingView.mode = MBProgressHUDMode.Indeterminate;
        mbLoadingView.labelText = "Loading movies...";
        
        moviesLoader.loadMovies(endPoint) { (movies, error) -> Void in
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
        self.navigationItem.rightBarButtonItem?.enabled = true
        self.navigationItem.leftBarButtonItem?.enabled = true
        self.reloadMoviePresenter()
    }

    private func handleLoadMoviesFailed(error:NSError) {
//        print("Get nowplaying movies failed \(error)")
        self.messageView.hidden = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        self.navigationItem.leftBarButtonItem?.enabled = false
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
    
    // MARK: - Navigation items
    
    private func createSearchBarNavigationItem() {
        self.searchBar = UISearchBar()
        self.searchBar.tintColor = UIColor.redColor()
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        searchBar.sizeToFit()
    }
    
    private func createLeftBarButton() {
        let segmentedControl = UISegmentedControl()
        segmentedControl.insertSegmentWithImage(UIImage(named: "list"), atIndex: 0, animated: false)
        segmentedControl.insertSegmentWithImage(UIImage(named: "grid"), atIndex: 1, animated: false)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.redColor()
        segmentedControl.addTarget(self, action: "segmentControlValueChange:", forControlEvents: .ValueChanged)
        segmentedControl.sizeToFit()
        self.leftBarButton = UIBarButtonItem(customView: segmentedControl)
    }
    
    private func createRightBarButton() {
        self.rightBarButton = UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "barButtonSearchClicked:")
        self.rightBarButton.tintColor = UIColor.redColor()
    }
    
    private func showLeftBarButton(show:Bool) {
        if show {
            self.navigationItem.leftBarButtonItem = self.leftBarButton
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    private func showRightBarButton(show:Bool) {
        if show {
            self.navigationItem.rightBarButtonItem = self.rightBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    private func showSearchBarOnNavigationBar(show:Bool) {
        if (show) {
            self.searchBar.removeFromSuperview()
            self.navigationItem.titleView = self.searchBar
            self.searchBar.becomeFirstResponder()
        } else {
            self.navigationItem.titleView = nil
        }
        self.isSearchBarVisible = show
    }
    
    @objc
    private func barButtonSearchClicked(sender:UIBarButtonItem) {
        self.showLeftBarButton(false)
        self.showRightBarButton(false)
        self.showSearchBarOnNavigationBar(true)
    }
    
    // MARK: -
    
    @objc
    private func refreshData(sender:UIRefreshControl) {
        // Only load data if not searching
        self.loadMoviesData()
    }
    
    @objc
    private func segmentControlValueChange(sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.moviesTable.hidden = false
            self.movieCollection.hidden = true
        } else if sender.selectedSegmentIndex == 1 {
            self.moviesTable.hidden = true
            self.movieCollection.hidden = false
        }
        self.reloadMoviePresenter()
    }
    
    private func displayMessageInMessageView(title title:String, description:String) {
        self.msgViewTitleLabel.text = title
        self.msgViewDescLabel.text = description
    }
    
    private func reloadMoviePresenter() {
        if self.moviesTable.hidden {
            self.movieCollection.reloadData()
        }
        if self.movieCollection.hidden {
            self.moviesTable.reloadData()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        var indexPath:NSIndexPath?

        if segue.identifier == "collection" {
            let cell = sender as! UICollectionViewCell
            indexPath = self.movieCollection.indexPathForCell(cell)
        } else if segue.identifier == "table" {
            let cell = sender as! UITableViewCell
            indexPath = self.moviesTable.indexPathForCell(cell)
        }
        
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

extension NowPlayingVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = self.filteredData {
            return (self.filteredData!.count)
        } else {
            return 0
        }
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieCollectionCell", forIndexPath: indexPath) as! MovieCollectionCell
        cell.bindMovieData(filteredData![indexPath.row])
        return cell
    }
    
    
}

extension NowPlayingVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let totalWidth = collectionView.bounds.size.width
        
        let spacing = 10
        let numberItemsPerRow = 3
        
        let width = (totalWidth - CGFloat(numberItemsPerRow + 1) * CGFloat(spacing)) / CGFloat(numberItemsPerRow)
        let height = width * 156 / 103
        
        return CGSizeMake(width, height)
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
        self.reloadMoviePresenter()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        // Show all movie
        searchBar.text = ""
        self.filteredData = self.moviesData
        self.reloadMoviePresenter()
        
        // Don't focus on searchbar any more
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        
        self.showLeftBarButton(true)
        self.showRightBarButton(true)
        self.showSearchBarOnNavigationBar(false)
        self.movieCollection.insertSubview(refreshControl, atIndex: 0)
        self.moviesTable.insertSubview(refreshControl, atIndex: 0)
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.refreshControl.removeFromSuperview()
        self.collectionViewRefreshControl.removeFromSuperview()
        return true
    }
}


