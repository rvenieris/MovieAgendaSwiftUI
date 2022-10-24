//
//  MDBRequest.swift
//  MovieAgenda
//
//  Created by Ricardo Venieris on 17/10/22.
//

    // This file was generated from JSON Schema using quicktype, do not modify it directly.
    // To parse the JSON, add this file to your project and do:
    //
    //   let mDBRequest = try? newJSONDecoder().decode(MDBRequest.self, from: jsonData)

    //
    // To read values from URLs:
    //
    //   let task = URLSession.shared.mDBRequestTask(with: url) { mDBRequest, response, error in
    //     if let mDBRequest = mDBRequest {
    //       ...
    //     }
    //   }
    //   task.resume()

import Foundation
//import CodableExtensions

    // MARK: - MDBRequest
struct MDB {
    struct Request: Codable {
        static let imageUrlPrefix = "https://image.tmdb.org/t/p/w500"
        static let dataRequestUrlPrefix = "https://api.themoviedb.org"
        
        
        
        let page: Int
        let results: [MDB.Media]
        let totalPages: Int
        let totalResults: Int
        
        enum CodingKeys: String, CodingKey {
            case page = "page"
            case results = "results"
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
        
        static func fullPath(for imagePath: String?)->URL? {
            guard let path = imagePath,
                  let url = URL(string: Self.imageUrlPrefix+path) else {
                return nil
            }
            return url
        }
        
    }
}

    //
    // To read values from URLs:
    //
    //   let task = URLSession.shared.resultTask(with: url) { result, response, error in
    //     if let result = result {
    //       ...
    //     }
    //   }
    //   task.resume()
