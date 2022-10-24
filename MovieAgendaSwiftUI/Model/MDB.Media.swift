//
//  MDBMovies.swift
//  MovieConsultor
//
//  Created by Ricardo Venieris on 24/05/18.
//  Copyright © 2018 LES.PUC-RIO. All rights reserved.
//

import Foundation
//import CodableExtensions

    // MARK: - Result
extension MDB {
    struct Media: Codable, Identifiable {
        public let id: Int
        public let name: String?
        public let backdropPath: String?
        public let overview: String?
        public let posterPath: String?
        public let mediaType: MediaType
        public let voteAverage: Double
        public let voteCount: Int
        public let title: String? = nil
        public let originCountry: [String]? = []
        public let originalTitle: String? = nil
        public let releaseDate: String? = nil
        public let video: Bool? = nil
        public let adult: Bool? = false
        public let originalLanguage: String? = nil
        public let originalName: String? = nil
        public let genreIDS: [Int] = []
        public let popularity: Double = 0
        public let firstAirDate: String? = nil
        
        public var posterURL: URL? {return MDB.Request.fullPath(for: posterPath)}
        public var backdropURL: URL? {return MDB.Request.fullPath(for: backdropPath)}
        public var wrappedTitle: String {name ?? originalName ?? title ?? originalTitle ?? "No Title"}

        enum CodingKeys: String, CodingKey {
            case id = "id"
            case name = "name"
            case title = "title"
            case originalTitle = "original_title"
            case releaseDate = "release_date"
            case video = "video"
            case adult = "adult"
            case backdropPath = "backdrop_path"
            case originalLanguage = "original_language"
            case originalName = "original_name"
            case overview = "overview"
            case posterPath = "poster_path"
            case mediaType = "media_type"
            case genreIDS = "genre_ids"
            case popularity = "popularity"
            case firstAirDate = "first_air_date"
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
            case originCountry = "origin_country"
        }
        
        
        
        enum MediaType: String, Codable {
            case movie = "movie"
            case tv = "tv"
        }
    }
}
