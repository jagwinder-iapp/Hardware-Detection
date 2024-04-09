//
//  OutdoorsTableViewCell.swift
//  Metal Detector
//
//  Created by iapp on 07/03/24.
//

import UIKit

class OutdoorsListTableViewCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconsImageView: UIImageView!
    
    //MARK: - properties
    var infrRedDataModel: InfraRedDataModel?
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }


    //MARK: - Configure Cell
    func configureCell(data: InfraRedDataModel) {
        self.infrRedDataModel = data
        self.titleLabel.text = data.title
        self.iconsImageView.image = UIImage(named: data.imageName)
    }
    
}
