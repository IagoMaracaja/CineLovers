//
//  UpcomingMoviesViewController.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 24/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import NVActivityIndicatorView

class UpcomingMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    var pageIndex = 1
    var totalPages = 1
    var totalItems = 0
    
    let disposeBag = DisposeBag()
    var appServerClient: ApiService?
    var movieList:[Result] = []
    var filteredList: [Result] = []
    var isSearchingMovie = Variable<Bool>(false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (appServerClient == nil){
            self.appServerClient = AppServerClient()
        }
        self.customizeTableView()
        self.getUpcomingMovies()
        self.searchObservable ()
        
        
        
    }
   
    @IBAction func editingChanged(_ sender: UITextField) {
        
        if sender.text?.count == 0 {
            self.isSearchingMovie.value = false
        } else {
            self.isSearchingMovie.value = true
        }
    }
    @IBAction func onSearchClick(_ sender: Any) {
        isSearchingMovie.value = true
        let text = self.searchTF.text?.lowercased()
        self.filteredList = []
        for movie in self.movieList {
            let movieName = movie.movieName.value.lowercased()
            if (movieName.range(of: text!) != nil){
                filteredList.append(movie)
            }
        }
        
        self.tableView.reloadData()
        
    }
    
    func searchObservable() {
        
        self.isSearchingMovie.asObservable().subscribe(onNext: {
          value in
            if !value {
                self.tableView.reloadData()
            }
            
        }).disposed(by: disposeBag)
    }
    
    func getUpcomingMovies(){
        self.showLoaging()
        appServerClient?.getUpcomingMovie(pageAt: pageIndex).subscribe(onNext: {
            movieResult in
            self.hideLoading()
            if(self.movieList.count == 0){
                self.movieList = movieResult.resultsJson
            } else {
                self.movieList.append(contentsOf: movieResult.resultsJson)
            }
            self.totalPages = movieResult.totalPages.value
            self.totalItems = self.movieList.count
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        
    }
    
    func customizeTableView(){
        self.bindTableView()
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.contentInset = UIEdgeInsets.zero
        
    }
    
    func bindTableView (){
        self.tableView.rx.willDisplayCell.subscribe(onNext: {
            cell, rowAtIndexPath in
            if (rowAtIndexPath.row + 1 == self.totalItems){
                if (self.pageIndex < self.totalPages){
                    self.pageIndex += 1
                    self.getUpcomingMovies()
                }
            }
        }).disposed(by: disposeBag)
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.tableView.rx.setDataSource(self).disposed(by: disposeBag)
       
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 282
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard: UIStoryboard = UIStoryboard(name: "MovieDetail", bundle: nil)
        let movieDetail : MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "movieDetailViewController") as! MovieDetailViewController
        var movie: Result
        if (isSearchingMovie.value) {
            movie = self.filteredList[indexPath.row]
        }else{
            movie = self.movieList[indexPath.row]
        }
        movieDetail.movie = movie
        
        
        self.navigationController?.pushViewController(movieDetail, animated: true)
    }
    
    
    // MARK: UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UpcomingMovieTableViewCell = self.tableView.dequeueReusableCell(withIdentifier: "UpcomingMovieTableViewCellId") as! UpcomingMovieTableViewCell!;
        
        var movie: Result
        
        if (isSearchingMovie.value) {
            movie = self.filteredList[indexPath.row]
        }else{
             movie = self.movieList[indexPath.row]
        }
        
        cell.setupView(withThisMovie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearchingMovie.value){
            return self.filteredList.count
        }
        return self.movieList.count
    }
    
    func callAlertMessages(){
        /*let storyboard: UIStoryboard = UIStoryboard(name: "Alert", bundle: nil)
         let alertVc : AlertViewController = storyboard.instantiateViewController(withIdentifier: "alertViewController") as! AlertViewController
         alertVc.modalPresentationStyle = .overCurrentContext
         alertVc.alertMessageString = "There are no results to display, please try again."
         self.present(alertVc, animated: true, completion: nil)*/
    }
    
    func showLoaging(){
        if (!self.activityIndicator.isAnimating){
            self.activityIndicator.startAnimating()
        }
    }
    
    func hideLoading(){
        if(self.activityIndicator.isAnimating){
            self.activityIndicator.stopAnimating()
        }
    }
    

}
