//
//  MDBGenre.swift
//  MyTMDBCollectionView
//
//  Created by Ricardo Venieris on 28/07/19.
//  Copyright © 2019 Ricardo Venieris. All rights reserved.
//

import Foundation

extension MDB {
    typealias Genres = [MDB.Genre]
    struct Genre: Codable {
        let id: Int
        let name: String
    }
}
