//
//  ReviewCollectionViewCell.swift
//  TMDB
//
//  Created by Azis Ramdhan on 02/11/21.
//

import UIKit

class ReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupItem(_ result: Result) {
        contentLabel.text = result.content
        guard var avatarPath = result.authorDetails?.avatarPath else {
            avatarImageView.image = UIImage(named: "Placeholder")
            return
        }
        if avatarPath.contains("https") {
            avatarPath.remove(at: avatarPath.startIndex)
            guard let url = URL(string: avatarPath) else {
                avatarImageView.image = UIImage(named: "Placeholder")
                return
            }
            avatarImageView.sd_setImage(with: url, completed: nil)
        } else {
            let path = "\(AppConstants.baseImageURL)/\(avatarPath)"
            guard let url = URL(string: path) else {
                avatarImageView.image = UIImage(named: "Placeholder")
                return
            }
            avatarImageView.sd_setImage(with: url, completed: nil)
        }
    }
}
