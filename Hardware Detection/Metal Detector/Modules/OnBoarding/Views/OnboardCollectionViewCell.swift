//
//  OnbaordCollectionViewCell.swift
//  Metal Detector
//
//  Created by iApp on 04/03/24.
//

import UIKit

class OnboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var subtitle: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    
    static let identifier = "OnboardCollectionViewCell"
    
    func configureCell(onbaordData:OnboardModel){
        
        self.mainImage.image = UIImage(named: onbaordData.data.imageName)
        self.mainTitle.text = onbaordData.data.title
        self.subtitle.text = onbaordData.data.subTitle
        
    }
    
}
