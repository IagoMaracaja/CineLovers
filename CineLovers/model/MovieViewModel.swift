//
//  Movie.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 25/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation
import RxSwift

enum UpcomingMovieKeys: String, CodingKey {
    case movieName = "title"
    case releaseDate = "release_date"
    case posterUrlString = "poster_path"
    case movieGenre = "genre_ids"
    case overview = "overview"
    case backdropPath = "backdrop_path"
    case results = "results"
    case page = "page"
    case totalPages = "total_pages"
    case movieId = "id"
}

struct MovieViewModel: Decodable {
    
    var resultsJson:[Result] = []
    var page = Variable<Int>(0)
    var totalPages = Variable<Int>(0)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UpcomingMovieKeys.self)
        self.resultsJson = try container.decode([Result].self, forKey: .results)
        self.page.value = try container.decode(Int.self, forKey: .page)
        self.totalPages.value = try container.decode(Int.self, forKey: .totalPages)
    }
}
struct Result:Decodable {
    
    var movieName = Variable<String>("")
    var releaseDate = Variable<String>("")
    var posterUrlString:String?
    var movieGenre = Variable<[Int]>([])
    var overview = Variable<String>("")
    var backdropPath:String?
    var movieId = Variable<Int>(0)
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: UpcomingMovieKeys.self)
        
        self.movieName.value = try container.decode(String.self, forKey: .movieName)
        self.releaseDate.value = try container.decode (String.self, forKey: .releaseDate)
        self.posterUrlString = try container.decodeIfPresent(String.self, forKey: .posterUrlString)
        self.movieGenre.value = try container.decode([Int].self, forKey: .movieGenre)
        self.movieId.value = try container.decode(Int.self, forKey: .movieId)
        self.overview.value = try container.decode(String.self, forKey: .overview)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    }
}


