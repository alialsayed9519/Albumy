//
//  ViewController.swift
//  Albumy
//
//  Created by Ali on 13/03/2023.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var searchInput: UITextField!
    @IBOutlet private weak var navigationItemTitle: UINavigationItem!
    private var albumPhotos: [AlbumPhotos] = []
    private var viewModel = PhotosViewModel()
    private let bag = DisposeBag()
    var albumId: Int!
    var albumTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        fetchData()
        bindData()
    }
    
    private func initView() {
        self.collectionView.register(UINib(nibName: "PhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.rx.setDelegate(self).disposed(by: bag)
        self.navigationItemTitle.title = albumTitle
    }
    
    private func fetchData() {
        viewModel.fetchAlbumPhoos(albumId: String(albumId))
            .subscribe()
            .disposed(by: bag)
        
        //MARK: - Search
        searchInput.rx.text.asObservable()
            .bind(to: viewModel.searchValueObserver)
            .disposed(by: bag)
    }
    
    private func bindData() {
        viewModel.filterModelObservable.subscribe(onNext: { [weak self] photos in
            self?.albumPhotos = photos
            self?.collectionView.reloadData()
        }).disposed(by: bag)
        
        // MARK: - Collection view
        viewModel.filterModelObservable
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items(cellIdentifier: "PhotoCollectionViewCell")) { (_, model, cell: PhotoCollectionViewCell) in
                cell.setupImages(url: model.thumbnailUrl)
            }.disposed(by: bag)
       
        // MARK: - Model Selected
//        collectionView.rx.modelSelected(AlbumPhotos.self)
//            .asObservable()
//            .subscribe(onNext: { albumPhoto in
//                print("modelSelected")
//            }).disposed(by: bag)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3
        let spacing: CGFloat = 1.5
        let totalHorizontalSpacing = (columns - 1) * spacing
        let itemWidth = (collectionView.bounds.width - totalHorizontalSpacing) / columns
        let itemSize = CGSize(width: itemWidth, height: itemWidth)
        return itemSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }

     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 0
     }
}


