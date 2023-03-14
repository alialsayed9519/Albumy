//
//  PhotoCollectionViewCell.swift
//  Albumy
//
//  Created by Ali on 05/03/2023.
//

import UIKit
import SDWebImage

class PhotoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupImages(url: String) {
        image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
    }
}
