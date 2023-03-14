//
//  AlbumPhotos.swift
//  Albumy
//
//  Created by Ali on 03/03/2023.
//

import Foundation

// MARK: - AlbumPhotosModel
struct AlbumPhotos: Decodable {
    let albumId, id: Int
    let title: String
    let url, thumbnailUrl: String
}
