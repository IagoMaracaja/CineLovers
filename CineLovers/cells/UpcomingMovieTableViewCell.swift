//
//  UpcomingMovieTableViewCell.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 25/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import UIKit

class UpcomingMovieTableViewCell: UITableViewCell {

    
    @IBOutlet weak var movieGenre: UILabel!
    @IBOutlet weak var movieName: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var moviePoster: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


}
