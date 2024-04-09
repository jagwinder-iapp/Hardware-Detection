//
//  BottomSheetView.swift
//  Metal Detector
//
//  Created by iapp on 28/02/24.
//

import UIKit

class BottomSheetView: UIView {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recognizedDeviceCountLabel: UILabel!
    @IBOutlet weak var suspiciousDeviceCountLabel: UILabel!
    @IBOutlet weak var handleView: UIView!
    @IBOutlet weak var topTouchedView: UIView!
    @IBOutlet weak var mainView: UIView!
    
    //MARK: - Properties
    private var initialCenter: CGPoint!
    
    var savedWifi: [String] = []{
        didSet{
            Helper.dispatchMain {
                self.recognizedDeviceCountLabel.text = self.savedWifi.count.description
                self.tableView.reloadData()
            }
        }
    }

    
    //MARK: - Lifecycle
    override  func awakeFromNib() {
        super.awakeFromNib()
        self.setupUI()
    }
    
    //MARK: - Setup UI
    func setupUI() {
        self.handleView.layer.cornerRadius = self.handleView.frame.size.height / 2
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerXib(nibName: Identifiers.wifiListTableViewCell)
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 120, right: 0)
    }
}

// MARK: - Extension Gesture Recognizer
extension BottomSheetView {
    func showFullSheet() {
        let fullRect = CGRect(x: 0, y: UIScreen.main.bounds.height - 800, width: self.bounds.width, height: self.bounds.height)
        UIView.animate(withDuration: 0.5, animations: {
            self.alpha = 1
            self.frame = fullRect
        }, completion: { _ in
        })
    }
    
    //MARK: - Dismiss View
    private func dismissView() {
            UIView.animate(withDuration: 0.3, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
}

// MARK: - TableView Delegate and Datasource
extension BottomSheetView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedWifi.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.wifiListTableViewCell, for: indexPath) as? WifiListTableViewCell else {return UITableViewCell()}
        
        let device = self.savedWifi[indexPath.row]
        cell.configureCell(device: device)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
