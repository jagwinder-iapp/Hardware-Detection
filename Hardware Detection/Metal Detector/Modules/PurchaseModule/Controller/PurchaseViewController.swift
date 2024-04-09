//
//  PurchaseViewController.swift
//  Metal Detector
//
//  Created by iApp on 05/03/24.
//

import UIKit

class PurchaseViewController: BaseViewController {
    
    class func control(isRootSet:Bool) -> PurchaseViewController {
        let control = self.control(.Purchase) as? PurchaseViewController
        control?.isRootSet = isRootSet
        return control ?? PurchaseViewController()
    }
    
    @IBOutlet weak var otherOptionLabel: UILabel!
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var continueBtn: UIButton!
    @IBOutlet weak var trialView: UIView!
    @IBOutlet weak var imageLogo: UIImageView!
    
    private var isRootSet = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    private func setUpUI(){
        mainTitle.underlineText()
        self.imageLogo.layer.shadowColor = UIColor(hexString: "626D83").cgColor
        self.imageLogo.layer.shadowOffset = .zero
        self.imageLogo.layer.shadowRadius = 4.0
        self.imageLogo.layer.shadowOpacity = 0.7
        
        otherOptionLabel.underlineText()
        continueBtn.titleLabel?.underlineText()
        self.trialView.layer.cornerRadius = 16
        self.continueBtn.layer.cornerRadius = self.continueBtn.frame.height/2
    }
    
    @IBAction func continueBtnAction(_ sender:  UIButton) {
        
    }
    
    @IBAction func cancelBtnAction(_ sender: Any) {
//
        if isRootSet{
            self.view.applyAnimationOnDismissView()
            rootControllerByCoordinator(step: .Home)
        }else{
            self.dismiss(animated: true)
        }
    }
}
