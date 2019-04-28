//
//  ApiServiceProtocol.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 27/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation
import RxSwift

protocol ApiService {
    func getUpcomingMovie(pageAt page: Int?) -> Observable<MovieViewModel>
    func getMovieDetail (movieId id: Int) -> Observable<MovieDetailViewModel>
}
