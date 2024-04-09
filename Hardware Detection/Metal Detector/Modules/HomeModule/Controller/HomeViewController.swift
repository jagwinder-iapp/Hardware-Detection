//
//  HomeViewController.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit

class HomeViewController: BaseViewController {
    
    //MARK: - Control
    
    class func control() -> HomeViewController {
        let control = self.control(.Home) as? HomeViewController
        return control ?? HomeViewController()
    }
    
    //MARK: - IBoutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tryNowButton: UIButton!
    @IBOutlet weak var topTitleLabel: UILabel!
    
    //MARK: - Properties
    private var homeData: [HomeScreenData]?
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    
    //MARK: - Setup UI
    private func setUpUI() {
        self.registerCell()
        homeData = [.metalDetector,.electroMagneticDetector,.cameraDetector,.studDetector,.mailSecurity]
        tryNowButton.layer.cornerRadius = 20
        self.tableView.contentInset = UIEdgeInsets(top: 0, left:0 , bottom: 10, right: 0)
    }
    
    private func registerCell() {
        tableView.registerXib(nibName: Identifiers.homeTableViewCell)
    }
    
    //MARK: - Buttons Action
    
    @IBAction func tryNowButtonClicked(_ sender: UIButton) {
        self.openSubscription()
    }
    
    @IBAction func settingButtonClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(SettingViewController.control(), animated: true)
    }
    
    @IBAction func infoButtonClicked(_ sender: UIButton) {
        self.navigationController?.pushViewController(InstructionViewController.control(), animated: true)
    }
}


//MARK: - Extension TableView Delegate and Datasource

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData?.count   ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.homeTableViewCell, for: indexPath) as? HomeTableViewCell else {return UITableViewCell()}
        if let data = homeData?[indexPath.item] {
            cell.configureCell(data: data)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let homeData = self.homeData else {return}
        let selectedIndex = homeData[indexPath.item]
        switch selectedIndex {
        case .metalDetector:
            self.navigationController?.pushViewController(MetalDetectorViewController.control(detectorOption: .metalDetector), animated: true)
        case .electroMagneticDetector:
            self.navigationController?.pushViewController(MegnaticViewController.control(), animated: true)
        case .cameraDetector:
            self.navigationController?.pushViewController(CameraDetectorViewController.control(), animated: true)
        case .studDetector:
            self.navigationController?.pushViewController(MetalDetectorViewController.control(detectorOption: .studDetector), animated: true)
        case .mailSecurity:
            self.navigationController?.pushViewController(MailSecurityViewController.control(), animated: true)
        }
    }
}

