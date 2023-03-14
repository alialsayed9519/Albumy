//
//  Album.swift
//  Albumy
//
//  Created by Ali on 03/03/2023.
//

import Foundation

// MARK: - AlbumModel
struct Album: Codable {
    let userId: Int
    let id: Int
    let title: String
}
