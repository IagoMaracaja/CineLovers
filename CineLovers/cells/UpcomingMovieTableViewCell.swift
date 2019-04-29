//
//  UpcomingMovieTableViewCell.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 25/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieAverage: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setupView(withThisMovie movie : Result) {
        self.movieAverage.text = "IMDb \(movie.voteAverage.value)"
        self.movieName.text = movie.movieName.value
        self.releaseDate.text = movie.releaseDate.value
        if ((movie.posterUrlString) != nil){
            let url = getPosterMovieUrl(withUrl: movie.posterUrlString!)
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    if let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.moviePoster.image = image
                        }
                    }
                }
            }
        } else {
            self.moviePoster.image = UIImage(named: "not_found.png")
        }
        
    }

}
