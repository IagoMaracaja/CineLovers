//
//  MovieDetailViewController.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 27/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import UIKit
import RxSwift

class MovieDetailViewController: UIViewController{
    

    var movie: Result!
    
    @IBOutlet weak var posterMovieIV: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieGenreLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fillItemsOfView()
    }

    func fillItemsOfView(){
        self.movieTitleLabel.text = self.movie.movieName.value
        self.releaseDateLabel.text = self.movie.releaseDate.value
        self.overviewLabel.text = self.movie.overview.value
        
        let url = getPosterMovieUrl(withUrl: self.movie.backdropPath.value)
        
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
