//
//  MovieDetailViewModel.swift
//  CineLovers
//
//  Created by Iago Albuquerque on 28/04/19.
//  Copyright © 2019 Andre Iago. All rights reserved.
//

import Foundation
import RxSwift

enum MovieDetailsKeys: String, CodingKey {
    case movieName = "title"
    case releaseDate = "release_date"
    case posterUrlString = "poster_path"
    case movieGenre = "genres"
    case overview = "overview"
    case id = "id"
    case backdropPath = "backdrop_path"
    case genreName = "name"
}

struct MovieDetailViewModel: Decodable {
    var movieName = Variable<String>("")
    var releaseDate = Variable<String>("")
    var posterUrlString:String?
    var movieGenre = Variable<[Genre]>([])
    var overview = Variable<String>("")
    var backdropPath:String?
    var movieId = Variable<Int>(0)
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsKeys.self)
        
        self.movieName.value = try container.decode(String.self, forKey: .movieName)
        self.releaseDate.value = try container.decode (String.self, forKey: .releaseDate)
        self.posterUrlString = try container.decodeIfPresent(String.self, forKey: .posterUrlString)
        self.movieGenre.value = try container.decode([Genre].self, forKey: .movieGenre)
        self.overview.value = try container.decode(String.self, forKey: .overview)
        self.movieId.value = try container.decode(Int.self, forKey: .id)
        self.backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    }
}

struct Genre:Decodable {
    var genreId = Variable<Int>(0)
    var genreName = Variable<String>("")
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: MovieDetailsKeys.self)
        
        self.genreId.value = try container.decode(Int.self, forKey: .id)
        self.genreName.value = try container.decode(String.self, forKey: .genreName)
    }
}
