//
//  UIViewController+rx.swift
//  Albumy
//
//  Created by Ali on 04/03/2023.
//

import UIKit
import RxSwift

extension UIViewController {
    func alert(title: String, text: String?) -> Completable {
        return .create { [weak self] completable in
            let alertVC = UIAlertController(title: title, message: text, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                completable(.completed)
            }))
            self?.present(alertVC, animated: true, completion: nil)
            return Disposables.create {
                self?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
