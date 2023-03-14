//
//  ViewController.swift
//  Albumy
//
//  Created by Ali on 03/03/2023.
//

import UIKit
import RxSwift

class ProfileViewController: UIViewController {
    @IBOutlet private weak var userNameLabel: UILabel!
    @IBOutlet private weak var userAdressLabel: UILabel!
    @IBOutlet private weak var albumsTabeleView: UITableView!
    private var viewModel = ProfileViewModel()
    private var albums: [Album] = []
    private let bag = DisposeBag()
    let activityIndicator = UIActivityIndicatorView(style: .large)

    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        setUpActivityIndicator()
        fetchData()
        bindData()
    }
    
    private func initView() {
        albumsTabeleView.dataSource = self
        albumsTabeleView.delegate = self
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func fetchData() {
        viewModel.fetchUserData()
            .subscribe(onError: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            }).disposed(by: bag)
        
        viewModel.fetchAlbums()
            .subscribe(onError: { [weak self] error in
                self?.showMessage("Error", description: error.localizedDescription)
            })
            .disposed(by: bag)
    }
    
    private func bindData() {
        viewModel.observableUser.subscribe(onNext: { [weak self] user in
            self?.handleSuccessfulUserResponse()
            self?.userNameLabel.text = user.first?.username
            self?.userAdressLabel.text = user.first?.address.description
        }).disposed(by: bag)
    }
    
    func setUpActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    private func handleSuccessfulUserResponse() {
        viewModel.observableAlbums.subscribe(onNext: { [weak self] albums in
            self?.activityIndicator.stopAnimating()
            self?.albums = albums
            self?.albumsTabeleView.reloadData()
        }).disposed(by: bag)
    }
    
    func showMessage(_ title: String, description: String? = nil) {
      alert(title: title, text: description)
        .subscribe()
        .disposed(by: bag)
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = albumsTabeleView.dequeueReusableCell(withIdentifier: "ProfileViewController")!
        let album = albums[indexPath.row]
        cell.textLabel?.text = album.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "My Albums"
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVc = ViewController()
        let album = albums[indexPath.row]
        detailsVc.albumId = album.id
        detailsVc.albumTitle = album.title
        self.navigationController?.pushViewController(detailsVc, animated: true)
    }
}

