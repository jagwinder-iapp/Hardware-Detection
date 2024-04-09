//
//  InstructionListTableViewCell.swift
//  Metal Detector
//
//  Created by iapp on 04/03/24.
//

import UIKit

class InstructionListTableViewCell: UITableViewCell {

    
    //MARK: - IBOutlets
    
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var upAndDownArrowImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var howToUseData: HowToUseData!
    var isExpanded: Bool  {
        return howToUseData.isExpand
    }
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        
    }
    
    func configureCell(data: HowToUseData){
        self.howToUseData = data
        if isExpanded{
            self.descriptionLabel.text = data.description
        }else{
            self.descriptionLabel.text = ""
        }
        self.titleLabel.text = data.title
    }
    
    func rotateDropdownButton() {
        // Reset the transform to identity
        upAndDownArrowImageView.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3, delay: 0.1, options: .curveEaseInOut, animations: {
            let piValue: CGFloat = self.howToUseData.isExpand ? CGFloat.pi : 0
            self.upAndDownArrowImageView.transform = CGAffineTransform(rotationAngle: piValue)
        }, completion: nil)
    }


    
    @IBAction func dropDownButtonClicked(_ sender: UIButton) {
//        howToUseData.isExpand.toggle()
//        rotateDropdownButton()
//        if isExpanded{
//            self.descriptionLabel.text = howToUseData.description
//        }else{
//            self.descriptionLabel.text = ""
//        }
//        isExpanded.toggle()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    


}
