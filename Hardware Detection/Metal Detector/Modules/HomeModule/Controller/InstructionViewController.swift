//
//  InstructionViewController.swift
//  Metal Detector
//
//  Created by iapp on 04/03/24.
//

import UIKit

struct HowToUseData{
    let title: String
    let description: String
    var isExpand: Bool
}

class InstructionViewController: BaseViewController {
    
    //MARK: - Control
    class func control() -> InstructionViewController {
        let control = self.control(.Home) as? InstructionViewController
        return control ?? InstructionViewController()
    }
    
    //MARK: - IBoutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    
    //MARK: - Properties
    var howToUseData = [HowToUseData]()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialSetup()

    }
    
    //MARK: - Initial Setup
    func initialSetup() {
//        titleLabel.text = Constants.homeScreenTopTitle
//        titleLabel.setLineSpacing(lineSpacing: -0.1)
        howToUseData = [HowToUseData(title: Constants.metalDetector, description: InfoString.metalDescription, isExpand: false),HowToUseData(title: Constants.electromagneticdetector, description: InfoString.metalDescription, isExpand: false),HowToUseData(title: Constants.cameraDetector, description: InfoString.metalDescription, isExpand: false),HowToUseData(title: Constants.studDetector, description: InfoString.metalDescription, isExpand: false),HowToUseData(title: Constants.mailSecurity, description: InfoString.metalDescription, isExpand: false)]
        self.registerCell()
    }
    
    //MARK: - Register Cell
    func registerCell() {
        tableView.registerXib(nibName: Identifiers.instructionListTableViewCell)
    }
    
    //MARK: - Button Actions
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}


//MARK: - TableView Delegate and Datasource
extension InstructionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return howToUseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Identifiers.instructionListTableViewCell, for: indexPath) as? InstructionListTableViewCell else {return UITableViewCell()}
        cell.configureCell(data: howToUseData[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return howToUseData[indexPath.item].isExpand ? UITableView.automaticDimension : 100// Initial smaller height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        howToUseData[indexPath.item].isExpand.toggle() // Toggle expansion state
        tableView.reloadRows(at: [indexPath], with: .automatic) // Reload the cell to adjust its height
        if let cell = tableView.cellForRow(at: indexPath) as? InstructionListTableViewCell {
            cell.rotateDropdownButton()
        }
    }
}
