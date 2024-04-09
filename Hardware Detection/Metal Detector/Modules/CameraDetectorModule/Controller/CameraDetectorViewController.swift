//
//  CameraDetectorViewController.swift
//  Metal Detector
//
//  Created by iapp on 27/02/24.
//

import UIKit
import AVFoundation

enum InfraRedSelectionState {
    case infraRed
    case wifiDetector
}

class CameraDetectorViewController: BaseViewController{
    
    //MARK: - Control
    class func control() -> CameraDetectorViewController {
        let control = self.control(.Camera) as? CameraDetectorViewController
        return control ?? CameraDetectorViewController()
    }
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var navigationTopView: UIView!
    @IBOutlet weak var wifiDetectorButton: UIButton!
    @IBOutlet weak var infraRedButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var greenBackgroundImage: UIImageView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var imagesBackgroundView: UIView!
    @IBOutlet weak var detectorMainBackgroundView: UIView!
    @IBOutlet weak var detectorSearchedLabel: UILabel!
    @IBOutlet weak var detectorSearchedBackgroundView: UIView!
    @IBOutlet weak var bottomBackgroundView: UIView!
    @IBOutlet weak var startButtonBackgroundView: UIView!
    @IBOutlet weak var centerRotateImageView: UIImageView!
    @IBOutlet weak var scannerImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var buttonBackgroundImageView: UIImageView!
    @IBOutlet weak var greenViewBottomConstraint: NSLayoutConstraint!
    
    //MARK: - Properties
    
    private var wifiVM = WifiViewModel()
  
    private var myContext = 0
    
    private var cameraDetectorPhase : CameraDetectorPhase = .initialState {
        didSet {
            switch cameraDetectorPhase {
            case .initialState:
                self.initialState()
            case .scanningState:
                self.rotateImageView()
            case .result:
                self.showBottomSheetViewWithOpacityAnimation()
            }
        }
    }
    
    private var infraRedSelectionState : InfraRedSelectionState = .infraRed {
        didSet {
            switch infraRedSelectionState {
            case .infraRed:
                infraRedButton.titleLabel?.textColor = Colors.AppTextColor
                infraRedButton.alpha = 1.0
                wifiDetectorButton.alpha = 0.2
                wifiDetectorButton.titleLabel?.textColor =  Colors.AppTextColor
            case .wifiDetector:
                wifiDetectorButton.titleLabel?.textColor = Colors.AppTextColor
                wifiDetectorButton.alpha = 1.0
                infraRedButton.alpha = 0.2
                infraRedButton.titleLabel?.textColor =  Colors.AppTextColor
            }
        }
    }
    
    //MARK: - Load Bottom Sheet View
    private lazy var bottomDrawerView: BottomSheetView = {
        let bottomSheetView:BottomSheetView = BottomSheetView.fromNib()
        let yAxis = navigationTopView.frame.maxY + 60 //UIScreen.main.bounds.height + 20
        let height = self.view.bounds.height
        let bottomViewHeight = self.bottomBackgroundView.frame.height - 10
        bottomSheetView.layer.opacity = 0.0
        bottomSheetView.frame = CGRect(x: 0, y: yAxis, width: UIScreen.main.bounds.width, height: height - bottomViewHeight)
        return bottomSheetView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
//        self.presenter = LANPresenter(delegate:self)
//        self.addObserversForKVO()
    }
    
    //MARK: - SetupUI
    private  func setupUI() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        detectorSearchedBackgroundView.addGestureRecognizer(tapGesture)
        detectorSearchedLabel.text = Constants.detectorSearch
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        //  cameraDetectorPhase = .result
    }
    
    //MARK: - Initial State
    private func initialState() {
        self.startButtonBackgroundView.isHidden = false
        self.bottomBackgroundView.isHidden = false
        self.detectorMainBackgroundView.isHidden = true
        greenViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
        infoButton.isHidden = false
        self.centerRotateImageView.layer.removeAllAnimations()
        self.imagesBackgroundView.isHidden = false
        self.bottomDrawerView.isHidden = true
        self.bottomDrawerView.layer.animateOpacity(fromValue: 1.0, toValue: 0.0, duration: 0.8)
        
    }
    
    //MARK: - Rotate ImageView 360
    private func rotateImageView() {
        bottomBackgroundView.isHidden = true
        startButtonBackgroundView.isHidden = true
        detectorMainBackgroundView.isHidden = false
        centerRotateImageView.isHidden = false
        infoButton.isHidden = true
        centerRotateImageView.layer.animateRotationZ(duration: 2, forKey: AnimationKey.forKey)
    //   self.presenter?.scanButtonClicked()
    }
    
    //MARK: - Show Bottom Sheet View With Opacity Animation
    private func showBottomSheetViewWithOpacityAnimation() {
        self.startButtonBackgroundView.isHidden = true
        self.imagesBackgroundView.isHidden = true
        self.mainImageView.isHidden = false
        self.detectorMainBackgroundView.isHidden = true
        self.bottomBackgroundView.alpha = 1.0
        self.bottomBackgroundView.isHidden = false
        infoButton.isHidden = true
        self.bottomDrawerView.alpha = 1.0
        greenViewBottomConstraint.constant = self.bottomDrawerView.bounds.height - navigationTopView.frame.height
        UIView.animate(withDuration: 0.8) {
            self.view.layoutIfNeeded()
        }
        self.bottomDrawerView.isHidden = false
        self.bottomDrawerView.layer.animateOpacity(fromValue: 0.0, toValue: 1.0, duration: 0.8)
        self.view.insertSubview(self.bottomDrawerView, belowSubview: bottomBackgroundView)
    }
    
    
    //MARK: - Buttons Action
    @IBAction func backButtonClicked(_ sender: UIButton) {
        
        switch cameraDetectorPhase{
        case .initialState:
            self.navigationController?.popViewController(animated: true)
        case .scanningState:
            self.cameraDetectorPhase = .initialState
        case .result:
            self.cameraDetectorPhase = .initialState
        }
    }
    
    @IBAction func startButtonAction(_ sender: UIButton) {
        cameraDetectorPhase = .scanningState
    }
    
    @IBAction func infoButtonClicked(_ sender: UIButton) {
        
        let infoVC = InfoViewController.control(.camera)
        infoVC.modalPresentationStyle = .overCurrentContext
        self.present(infoVC, animated: false)
    }
    
    @IBAction func wifiDetectorButtonClicked(_ sender: UIButton) {
        infraRedSelectionState = .wifiDetector
    }
    
    @IBAction func infraredButtonClicked(_ sender: UIButton) {
        
        let cameraVC = CameraViewController.control()
        cameraVC.modalPresentationStyle = .fullScreen
        self.present(cameraVC, animated: true)
    }
    
}


