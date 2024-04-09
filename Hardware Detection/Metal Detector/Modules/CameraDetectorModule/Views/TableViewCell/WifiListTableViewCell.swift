//
//  WifiListTableViewCell.swift
//  Metal Detector
//
//  Created by iapp on 28/02/24.
//

import UIKit

class WifiListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addressTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var roundCheck: UIImageView!
    @IBOutlet weak var routerName: UILabel!
    @IBOutlet weak var addressName: UILabel!
    
    //MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func configureCell(device:String){
        
//        if device.isLocalDevice{
//            self.routerName.text = CustomUserDefaults.currentWifi
//        }else{
//            self.routerName.text = device.hostname
//        }
//        self.addressName.text = device.ipAddress
//        self.roundCheck.isHidden = !device.isLocalDevice
//        self.addressTopConstraint.constant = device.isLocalDevice ? 0 : 3.5
    }
    
}
