//
//  Movie.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 25/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation
import RxSwift

enum Keys: String, CodingKey {
    case movieName = "title"
    case releaseDate = "release_date"
    case posterUrlString = "poster_path"
    case movieGenre = "genre_ids"
    case overview = "overview"
    case backdropPath = "backdrop_path"
    case results = "results"
    case page = "page"
    case totalPages = "total_pages"
}

struct MovieViewModel: Decodable {
    
    var resultsJson:[Result] = []
    var page = Variable<Int>(0)
    var totalPages = Variable<Int>(0)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        self.resultsJson = try container.decode([Result].self, forKey: .results)
        self.page.value = try container.decode(Int.self, forKey: .page)
        self.totalPages.value = try container.decode(Int.self, forKey: .totalPages)
    }
}
struct Result:Decodable {
    
    var movieName = Variable<String>("")
    var releaseDate = Variable<String>("")
    var posterUrlString = Variable<String>("")
    var movieGenre = Variable<[Int]>([])
    var overview = Variable<String>("")
    var backdropPath = Variable<String>("")
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        self.movieName.value = try container.decode(String.self, forKey: .movieName)
        self.releaseDate.value = try container.decode (String.self, forKey: .releaseDate)
        self.posterUrlString.value = try container.decode(String.self, forKey: .posterUrlString)
        self.movieGenre.value = try container.decode([Int].self, forKey: .movieGenre)
        self.overview.value = try container.decode(String.self, forKey: .overview)
        self.backdropPath.value = try container.decode(String.self, forKey: .backdropPath)
    }
}


