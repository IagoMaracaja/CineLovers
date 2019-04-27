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

class UpcomingMoviesViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var pageIndex = 1
    var totalPages = 1
    var totalItems = 0
    
    let disposeBag = DisposeBag()
    var appServerClient: ApiService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (appServerClient == nil){
            self.appServerClient = AppServerClient()
        }
        self.customizeTableView()
        self.getUpcomingMovies()
        
    }
    
    func getUpcomingMovies(){
        appServerClient?.GetUpcomingMovie(pageAt: pageIndex).subscribe(onNext: {
            movieResult in
            let movies: Observable<[Result]> = Observable.just(movieResult.resultsJson)
            self.bindTableView(with: movies)
            self.totalPages = movieResult.totalPages.value
            self.totalItems = movieResult.resultsJson.count
            print("We have a \(self.totalItems) items at this moment.")
        }).disposed(by: disposeBag)
        
    }
    
    func customizeTableView(){
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
    }
    
    func bindTableView (with movies: Observable<[Result]>){
        movies.bind(to: tableView.rx.items(cellIdentifier: "UpcomingMovieTableViewCellId")) {
            indexpath, movie, cell in
            if let thisCell = cell as? UpcomingMovieTableViewCell {
                thisCell.movieGenre.text = "\(movie.movieGenre.value)"
                thisCell.movieName.text = movie.movieName.value
                thisCell.releaseDate.text = movie.releaseDate.value
                let url = getPosterMovieUrl(withUrl: movie.posterUrlString.value)
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                thisCell.moviePoster.image = image
                            }
                        }
                    }
                }
            }
        }.disposed(by: disposeBag)
        
        self.tableView.rx.willDisplayCell.subscribe(onNext: {
            cell, rowAtIndexPath in
            if (rowAtIndexPath.row + 1 == self.totalItems){
                if (self.pageIndex < self.totalPages){
                    self.pageIndex += 1
                    //self.getUpcomingMovies()
                }
            }
        }).disposed(by: disposeBag)
        
        self.tableView.rx.modelSelected(Result.self).subscribe(onNext: {
            movie in
            let storyboard: UIStoryboard = UIStoryboard(name: "MovieDetail", bundle: nil)
            let movieDetail : MovieDetailViewController = storyboard.instantiateViewController(withIdentifier: "movieDetailViewController") as! MovieDetailViewController
            movieDetail.movie = movie
            
            
            self.navigationController?.pushViewController(movieDetail, animated: true)
        }).disposed(by: disposeBag)
        
        
        self.tableView.rx.setDelegate(self).disposed(by: disposeBag)
       
    }
    
    // MARK: UITableViewDelegate Methods
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 282
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.selectionStyle = .none
    }
    
    func callAlertMessages(){
        /*let storyboard: UIStoryboard = UIStoryboard(name: "Alert", bundle: nil)
         let alertVc : AlertViewController = storyboard.instantiateViewController(withIdentifier: "alertViewController") as! AlertViewController
         alertVc.modalPresentationStyle = .overCurrentContext
         alertVc.alertMessageString = "There are no results to display, please try again."
         self.present(alertVc, animated: true, completion: nil)*/
    }
    

}
