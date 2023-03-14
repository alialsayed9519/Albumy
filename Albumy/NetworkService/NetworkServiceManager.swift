//
//  NetworkServiceManager.swift
//  Albumy
//
//  Created by Ali on 04/03/2023.
//

import Foundation
import Moya
import RxSwift

class NetworkServiceManager {
    public static let shared = NetworkServiceManager()
    private let provider = MoyaProvider<NetworkService>()
    private init() {}

    func getUserDetailes(with id: String) -> Single<[User]> {
            return provider.rx
            .request(.getUser(id: id))
                .filterSuccessfulStatusAndRedirectCodes()
                .map([User].self)
    }
    
    func getAllAlbums(with userId: String) -> Single<[Album]> {
            return provider.rx
            .request(.getAlbum(userId: userId))
                .filterSuccessfulStatusAndRedirectCodes()
                .map([Album].self)
    }

    func getAlbumPhotos(with albumId: String) -> Single<[AlbumPhotos]> {
            return provider.rx
            .request(.getPhotos(albumId: albumId))
                .filterSuccessfulStatusAndRedirectCodes()
                .map([AlbumPhotos].self)
    }
}
