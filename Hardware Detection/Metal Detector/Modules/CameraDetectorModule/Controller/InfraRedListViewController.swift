//
//  InfraRedViewController.swift
//  Metal Detector
//
//  Created by iapp on 07/03/24.
//

import UIKit

struct InfraRedDataModel {
    var imageName: String
    var title: String
    var isIndoor: Bool
}


class InfraRedListViewController: BaseViewController {
    
    //MARK: - Control
    class func control() -> InfraRedListViewController {
        let control = self.control(.Camera) as? InfraRedListViewController
        return control ?? InfraRedListViewController()
    }

    //MARK: - IBOutlets
    @IBOutlet weak var moveViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var outdoorButton: UIButton!
    @IBOutlet weak var indoorButton: UIButton!
    @IBOutlet weak var moveableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mainBackgroundView: UIView!
    
    
    
    //MARK: - Properties Declared
    var infraRedArray = [InfraRedDataModel]()
    var indoorData: [InfraRedDataModel] = []
    var outdoorData: [InfraRedDataModel] = []
    
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()
        
       let infraRedArray = [InfraRedDataModel(imageName: InfraRedImages.indoorsSmokeSensor, title: Constants.smokeAlarms, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.indoorsAC, title: Constants.airFilters, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsBooks, title: Constants.books, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsDeskplant, title: Constants.deskPlants, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsPeluches, title: Constants.peluches, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsDVD, title: Constants.dvdCases, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsLamp, title: Constants.lavaLamps, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsSocket, title: Constants.powerSockets, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsTv, title: Constants.TVs, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.IndoorsWardrobes, title: Constants.wardrobes, isIndoor: false),InfraRedDataModel(imageName: InfraRedImages.OutdoorPot, title: Constants.flowerPots, isIndoor: true),InfraRedDataModel(imageName: InfraRedImages.OutdoorLocks, title: Constants.locksOnTheDoor, isIndoor: true),InfraRedDataModel(imageName: InfraRedImages.OutdoorRoof, title: Constants.roofs, isIndoor: true),InfraRedDataModel(imageName: InfraRedImages.OutdoorDoorbell, title: Constants.doorbell, isIndoor: true)]
        
        indoorData = infraRedArray.filter({$0.isIndoor})
        outdoorData = infraRedArray.filter({!$0.isIndoor})
        self.infraRedArray = indoorData
        self.tableView.reloadData()
    }
    
    //MARK: - Initial Method
    func initialSetup() {
        mainBackgroundView.layer.animateOpacity(fromValue: 0.0, toValue: 1.0, duration: 0.8)
        self.registerCell()
    }
    
    func registerCell() {
        tableView.registerXib(nibName: Identifiers.outdoorsListTableViewCell)
    }
    
    //MARK: - Move Line
    private func moveLine(to button: UIButton) {
        if button == indoorButton {
            UIView.animate(withDuration: 0.3) {
                self.moveViewLeadingConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.moveViewLeadingConstraint.constant = UIScreen.main.bounds.width / 2
                self.view.layoutIfNeeded()
            }
        }
    }
    
    //MARK: - Button Actions
    @IBAction func indoorButtonClicked(_ sender: UIButton) {
        infraRedArray = indoorData
        moveLine(to: indoorButton)
        self.tableView.reloadData()
    }
    
    @IBAction func outdoorButtonClicked(_ sender: UIButton) {
        infraRedArray = outdoorData
        moveLine(to: outdoorButton)
        self.tableView.reloadData()
    }
    
    @IBAction func understoodButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
}


//MARK: - Extension
extension InfraRedListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.infraRedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.outdoorsListTableViewCell, for: indexPath) as? OutdoorsListTableViewCell else {return UITableViewCell()}
        let data = infraRedArray[indexPath.item]
        cell.configureCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
