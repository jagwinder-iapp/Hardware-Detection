//
//  MetalDetectorViewController.swift
//  Metal Detector
//
//  Created by iApp on 26/02/24.
//

import UIKit
import Charts

class MetalDetectorViewController: BaseViewController {
    
    class func control(detectorOption : HomeScreenData) -> MetalDetectorViewController {
        let control = self.control(.MetalDetector) as? MetalDetectorViewController
        control?.detectorOption = detectorOption
        return control ?? MetalDetectorViewController()
    }
    
    @IBOutlet weak var centerLineViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var studElippseIamge: UIImageView!
    @IBOutlet weak var readingLabel: UILabel!
    @IBOutlet weak var studBackgroundImageView: UIImageView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var studViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var frequencyViewTop: UIView!
    @IBOutlet weak var signalLabel: UILabel!
    @IBOutlet weak var smallResistantImage: UIImageView!
    @IBOutlet weak var largeResistantImage: UIImageView!
    @IBOutlet weak var metalTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomStudContstraint: NSLayoutConstraint!
    @IBOutlet weak var studTopView: UIView!
    @IBOutlet weak var studView: UIView!
    @IBOutlet weak var metalView: UIView!
    @IBOutlet weak var metalMainImageView: UIImageView!
    @IBOutlet weak var detectionLabel: UILabel!
    @IBOutlet weak var titleName: UILabel!
    @IBOutlet var bottomStackBtns: [UIButton]!
    @IBOutlet weak var chartViewOutlet: LineChartView!
    @IBOutlet weak var linearGauge: CustomGauge!
    
    private var detectorOption : HomeScreenData? = .metalDetector
    private var informationData : InfoType = .info
    private let magneticFieldManager = MetalViewModel()
    private var selectedBtn = [Int]()
    private var maxBars = 37
    private var timer: Timer?
    private var isDanger: Bool = false
    private var infoViewControllerPresented = false
    
    private var vibrate: Bool = false {
        didSet{
            if vibrate {
                self.magneticFieldManager.startVibration()
            } else {
                self.magneticFieldManager.stopVibration()

            }
        }
    }
    
    private var isBoosted : Bool = false {
        didSet {
            if isBoosted {
                magneticFieldManager.boostValue = magneticFieldManager.boostArray.randomElement() ?? 0.0
            } else {
                magneticFieldManager.boostValue = 0.0
            }
        }
    }
    
    private var isMute : Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.magneticFieldManager.startMetalDetection(isMetal: true)
        self.magneticFieldManager.frequencyClousure = { frequency,magnitude in
            self.readingLabel.text = "\(magnitude)μT"
            self.signalLabel.text = "\(magnitude)μT"
            self.barUnits.append(magnitude)
            
            let gaugeValue = Double(self.maxBars) / 100.0 * Double(frequency)
          
            self.linearGauge.value = gaugeValue
            self.updateUIIfFrequencyGoesUptoDanger(isUpdate: frequency > self.magneticFieldManager.dangerLimit)
            self.isDanger = frequency > self.magneticFieldManager.dangerLimit
            self.setChart(chartView: self.chartViewOutlet, isDanger: self.isDanger)

        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        magneticFieldManager.stopVibration()
        self.magneticFieldManager.stopMetalDetection()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let perBarThickness:CGFloat = 1
        let spacing:CGFloat = 5
        let totalWidth = self.linearGauge.bounds.width
        self.maxBars = Int(totalWidth / (perBarThickness + spacing))
        self.linearGauge.numBars = self.maxBars
        self.linearGauge.thickness = Int(perBarThickness)
    }
   
    
    //MARK: - PRIVATE FUNCTIONS
    
    private func updateUIIfFrequencyGoesUptoDanger(isUpdate: Bool) {
        if isUpdate {
            if vibrate{
                self.magneticFieldManager.startVibration()
            }
            if isMute {
                self.magneticFieldManager.toggleMute(mute: false)
            }
            
            centerLineViewBottomConstraint.constant = 16
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            linearGauge.dangerColor = Colors.redMetalColor!
            metalMainImageView.image = UIImage(named: "metalRed")
            studBackgroundImageView.image = UIImage(named: "studRed")
            studElippseIamge.image = UIImage(named: "redElps")
            smallResistantImage.isHidden = true
            largeResistantImage.isHidden = false
        } else {
            centerLineViewBottomConstraint.constant = 32
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            self.magneticFieldManager.stopVibration()
            self.magneticFieldManager.toggleMute(mute: true)
            linearGauge.dangerColor = Colors.greenMetalColor!
            metalMainImageView.image = UIImage(named: "metalGreen")
            studBackgroundImageView.image = UIImage(named: "studGreen")
            studElippseIamge.image = UIImage(named: "greenElps")
            smallResistantImage.isHidden = false
            largeResistantImage.isHidden = true
        }
    }
    
    
    private func setUpUI() {
       
        linearGauge.numBars = maxBars
        linearGauge.thickness = 1
        linearGauge.dangerColor = Colors.greenMetalColor!
        studTopView.grayBorder(corner: 10, color: Colors.metalTextColor!)
        for button in bottomStackBtns{
            button.addShadow()
        }
        
        switch detectorOption {
        case .metalDetector:
            metalTopConstraint.constant = 0
            studTopView.isHidden = true
            studView.isHidden = true
        case .studDetector:
            frequencyViewTop.isHidden = true
            metalTopConstraint.constant = 0
            studTopView.isHidden = false
            studView.isHidden = false
            self.titleName.text = "Stud Detector"
            
        default:break
            
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        studView.addGestureRecognizer(tapGesture)
    }
    
    @objc func repeatScaningTask() {
        self.setChart(chartView: self.chartViewOutlet, isDanger: self.isDanger)
        self.barUnits.removeAll()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        self.studMetalViewAnimation(reverse: true)
    }
    
    private func studMetalViewAnimation(reverse:Bool) {
        self.studViewTopConstraint.constant = 20
        self.bottomStudContstraint?.constant = self.studView.frame.height - 110
        UIView.animate(withDuration: 0.5, delay: 0.3, options: [.curveEaseInOut], animations: {
            self.studTopView.alpha = 0
            self.progressLabel.alpha = 1.0
            self.view.layoutIfNeeded()
        }) { _ in
            self.progressLabel.isHidden = false
            self.metalTopConstraint.constant = 0
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.frequencyViewTop.isHidden = false
                self.studView.isHidden = true
            }
        }
    }
    
    //MARK: - Buttons Action
    
    @IBAction func backBtnAction(_ sender: UIButton) {
        magneticFieldManager.toggleTorch(on: false)
        magneticFieldManager.stopVibration()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func infoBtn(_ sender: UIButton) {
        let infoVC = InfoViewController.control(self.detectorOption == .studDetector ? .stud : .info)
        infoVC.modalPresentationStyle = .overCurrentContext
        self.present(infoVC, animated: false)
    }
    
    @IBAction func bottomStactBtnAction(_ sender: UIButton) {
        if selectedBtn.contains(sender.tag){
            if let idx = selectedBtn.firstIndex(of: sender.tag){
                selectedBtn.remove(at: idx)
            }
        }else{
            selectedBtn.append(sender.tag)
        }
        for (index,button) in bottomStackBtns.enumerated(){
            if selectedBtn.contains(index){
                button.backgroundColor = Colors.buttonSelectionColor!
                
            }else{
                button.backgroundColor = Colors.btnStackColor!
            }
        }
        switch sender.tag {
        case 0:
            isMute = !isMute
        case 1:
            vibrate = !vibrate
        case 2:
            isBoosted = !isBoosted
            if !infoViewControllerPresented {
                presentInfoViewController()
            }
        case 3:
            if selectedBtn.contains(sender.tag){
                magneticFieldManager.toggleTorch(on: true)
            } else {
                magneticFieldManager.toggleTorch(on: false)
            }
        default:
            break
        }
    }
    
    func presentInfoViewController() {
        let infoVC = InfoViewController.control(.wifi)
        infoVC.modalPresentationStyle = .overCurrentContext
        present(infoVC, animated: false)
        infoViewControllerPresented = true
    }
    
}
