//
//  HomeTableViewCell.swift
//  Metal Detector
//
//  Created by iapp on 27/02/24.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var homeCategoryLabel: UILabel!
    @IBOutlet weak var proButton: UIButton!
    @IBOutlet weak var homeImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    //MARK: - Layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.layer.cornerRadius = 20
        gradientBackgroundView.layer.cornerRadius = 20
    }
    
    //MARK: - Configure Cell
    func configureCell(data: HomeScreenData) {
        homeCategoryLabel.text = data.setTitle()
        homeImageView.image = data.setImage()
        backgroundImageView.image = data.setBackgroundImage()
    }
}
