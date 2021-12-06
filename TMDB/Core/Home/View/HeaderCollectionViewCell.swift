//
//  HeaderCollectionViewCell.swift
//  TMDB
//
//  Created by Azis Ramdhan on 02/11/21.
//

import UIKit

class HeaderCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var headerLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupItem(_ name: String, isActive: Bool) {
        headerLabel.text = name
        headerLabel.textColor = isActive ? UIColor(rgb: 0xF75F47) : .white
    }
}
