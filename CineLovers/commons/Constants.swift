//
//  Constants.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 27/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation

struct Constants {
    
    struct ApiClient {
        static let ApiUrlBase = "https://api.themoviedb.org/3"
        static let ApiUrlImageBase = "http://image.tmdb.org/t/p"
        static let ImageSizePath: String = "/w500"
        
        static let UpcomingMovieUrl = "/movie/upcoming"
        static let MovieDetailUrl = "/movie/"
    }
}
