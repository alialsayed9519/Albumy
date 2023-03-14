//
//  ProfileViewModel.swift
//  Albumy
//
//  Created by Ali on 04/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

enum LoadingError: Error {
    case Unknown
    case NoConnection
}

class ProfileViewModel {
    private var users = BehaviorRelay<[User]>(value: [])
    private var albums = BehaviorRelay<[Album]>(value: [])
    private let bag = DisposeBag()
    private static var randomUserId: String!
    
    // MARK: - Output
    var observableUser: Observable<[User]> { return users.asObservable() }
    var observableAlbums: Observable<[Album]> { return albums.asObservable() }
    
    init() {
        ProfileViewModel.randomUserId = generateRandomNumber()
    }
     
    func fetchUserData() -> Completable {
        return .create { observer in
            return NetworkServiceManager.shared.getUserDetailes(with: ProfileViewModel.randomUserId)
                .subscribe(onSuccess: { [weak self] user in
                    guard let self = self else {
                        return
                    }
                    self.users.accept(user)
                    observer(.completed)
                }, onFailure: { error in
                    observer(.error(error))
                })
        }
    }
    
    func fetchAlbums() -> Completable {
        return .create { observer in
            return NetworkServiceManager.shared.getAllAlbums(with: ProfileViewModel.randomUserId)
                .subscribe(onSuccess: { [weak self] albums in
                    guard let self = self else {
                        return
                    }
                    self.albums.accept(albums)
                    observer(.completed)
                }, onFailure: { error in
                    observer(.error(error))
                })
        }
    }
    
    private func generateRandomNumber(min: Int = 4, max: Int = 4) -> String {
        return String(Int.random(in: min...max))
    }
}

