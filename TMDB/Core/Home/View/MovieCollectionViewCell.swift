//
//  MovieCollectionViewCell.swift
//  TMDB
//
//  Created by Azis Ramdhan on 01/11/21.
//

import UIKit
import SDWebImage
import CoreData

class MovieCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var posterView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func setupItem(_ movie: Movie) {
        titleLabel.text = movie.title
        guard let path = movie.posterPath, let url = URL(string: "\(AppConstants.baseImageURL)\(path)") else {
            return
        }
        posterView.sd_setImage(with: url, completed: nil)
    }

    func setupItem(_ movie: NSManagedObject) {
        guard let title = movie.value(forKey: "title") as? String,
                let path = movie.value(forKey: "posterPath") as? String,
                let url = URL(string: "\(AppConstants.baseImageURL)\(path)") else {
            return
        }
        titleLabel.text = title
        posterView.sd_setImage(with: url, completed: nil)
    }

}
