//
//  MovieDetailViewController.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 27/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import UIKit
import RxSwift
import NVActivityIndicatorView

class MovieDetailViewController: UIViewController{
    
    @IBOutlet weak var activityIndicator: NVActivityIndicatorView!
    
    var movie: Result!
    
    @IBOutlet weak var posterMovieIV: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    
    var appServerClient: ApiService?
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillItemsOfView()
        
        if (appServerClient == nil){
            self.appServerClient = AppServerClient()
        }
        self.getMovieDetails()
    }

    func getMovieDetails(){
        self.showLoaging()
        appServerClient?.getMovieDetail(movieId: movie.movieId.value).subscribe(onNext: {
            movieResult in
            self.hideLoading()
            self.setMovieDetailsInfo(movieDetailed: movieResult)
        }).disposed(by: disposeBag)
    }
    
    private func setMovieDetailsInfo (movieDetailed movie:MovieDetailViewModel) {
        var genreString:String = "["
        for (index, genre) in movie.movieGenre.value.enumerated() {
            var separator: String = ", "
            if (index == movie.movieGenre.value.count-1) {
                separator = "]"
            }
            genreString += genre.genreName.value + separator
        }
        self.movieGenreLabel.text = genreString
        
        
    }
    
    func fillItemsOfView(){
        self.movieTitleLabel.text = self.movie.movieName.value
        self.releaseDateLabel.text = self.movie.releaseDate.value
        self.overviewLabel.text = self.movie.overview.value
        
        if ((movie.backdropPath) != nil){
            let url = getPosterMovieUrl(withUrl: self.movie.backdropPath!)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.posterMovieIV.image = image
                        }
                    }
                }
            }
        }
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
