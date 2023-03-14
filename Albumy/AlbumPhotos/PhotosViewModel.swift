//
//  PhotosViewModel.swift
//  Albumy
//
//  Created by Ali on 04/03/2023.
//

import Foundation
import RxSwift
import RxCocoa

class PhotosViewModel {
    // MARK: - Input
    var searchValueObserver : AnyObserver<String?> { searchValueBehavior.asObserver() }

    // MARK: - Output
    var filterModelObservable: Observable<[AlbumPhotos]>
    
    private let searchValueBehavior = BehaviorSubject<String?>(value: "")
    private let photos = BehaviorRelay<[AlbumPhotos]>(value: [])
    
    init() {
        filterModelObservable = Observable.combineLatest(
            searchValueBehavior
                .map { $0 ?? "" }
                .startWith("")
                .throttle(.milliseconds(500), scheduler: MainScheduler.instance), photos
            )
        .map { searchValue, photos in
            searchValue.isEmpty ? photos : photos.filter {
                $0.title.lowercased().contains(searchValue.lowercased())
            }
        }
    }
    
    
    func fetchAlbumPhoos(albumId: String) -> Completable {
        return .create { observer in
            return NetworkServiceManager.shared.getAlbumPhotos(with: albumId)
                .subscribe(onSuccess: { [weak self] albumPhotos in
                    guard let self = self else {return}
                    self.photos.accept(albumPhotos)
                    observer(.completed)
                }, onFailure: { error in
                    observer(.error(error))
                })
        }
    }
    
}

