//
//  CameraViewController.swift
//  Metal Detector
//
//  Created by iapp on 08/03/24.
//

import UIKit
import AVFoundation
import Vision

class CameraViewController: BaseViewController {
    
    //MARK: - Control
    class func control() -> CameraViewController {
        let control = self.control(.Camera) as? CameraViewController
        return control ?? CameraViewController()
    }
    
    //MARK: - Properties
    private var cameraSelectionState : InfraRedSelectionState = .infraRed
    private let magneticFieldManager = MetalViewModel()
    
    private var request: VNCoreMLRequest?
    private var visionModel: VNCoreMLModel?
    private var isInferencing = false
    private var isCameraSetUp = false
    private let measureModel = Measure()
    
    private var videoCapture: VideoCapture!
    private let semaphore = DispatchSemaphore(value: 1)
    private var lastExecution = Date()
    
    
    //MARK: - IBOutlets
    @IBOutlet weak var torchButton: UIButton!
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var cameraBackgroundView: UIView!
    @IBOutlet weak var infrRedButton: UIButton!
    @IBOutlet weak var wifiDetectorButton: UIButton!
    
    @IBOutlet weak var boxViews: DrawingBoundingBoxView!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        Helper.dispatchBackground {
            self.setUpModel()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCameraAuthorization()
        Helper.dispatchDelay(deadLine: .now() + 3.0) {
            let infoVC = InfraRedListViewController.control()
            infoVC.modalPresentationStyle = .overCurrentContext
            //  self.present(infoVC, animated: false)
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resizePreviewLayer()
        Helper.dispatchMain {
            self.infrRedButton.titleLabel?.textColor = Colors.AppTextColor
            self.infrRedButton.alpha = 1.0
            self.wifiDetectorButton.alpha = 0.2
            self.wifiDetectorButton.titleLabel?.textColor =  Colors.AppTextColor
        }
    }
    
    func resizePreviewLayer() {
        if isCameraSetUp{
            videoCapture.previewLayer?.frame = cameraBackgroundView.bounds
        }
    }
    
    //MARK: - Initial Setup
    
    func setupUI() {
        checkCameraAuthorization()
        Helper.dispatchDelay(deadLine: .now() + 3.0) {
            let infoVC = InfraRedListViewController.control()
            infoVC.modalPresentationStyle = .overCurrentContext
            //   self.present(infoVC, animated: false)
        }
        self.measureModel.delegate = self
    }
    
    // MARK: - Setup Core ML
    func setUpModel() {
        Helper.dispatchMain {
//            guard let objectDectectionModel = self.objectDectectionModel else { fatalError("fail to load the model") }
//            if let visionModel = try? VNCoreMLModel(for: objectDectectionModel.model) {
//                self.visionModel = visionModel
//                self.request = VNCoreMLRequest(model: visionModel, completionHandler: self.visionRequestDidComplete)
//                self.request?.imageCropAndScaleOption = .scaleFill
//            } else {
//                fatalError("fail to create vision model")
//            }
        }
    }
    
    // MARK: - SetUp Video
    func setUpCamera() {
        videoCapture = VideoCapture()
        videoCapture.delegate = self
        videoCapture.fps = 30
        videoCapture.setUp(sessionPreset: .vga640x480) { success in
            
            if success {
                // add preview view on the layer
                if let previewLayer = self.videoCapture.previewLayer {
                    previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    self.cameraBackgroundView.layer.addSublayer(previewLayer)
                    self.isCameraSetUp = true
                    self.resizePreviewLayer()
                }
                // start video preview when setup is done
                self.videoCapture.start()
            }
        }
    }
    
    
    //MARK: - Button Actions
    @IBAction func infraRedButton(_ sender: Any) {
        
    }
    
    @IBAction func wifiDetectorButtonClicked(_ sender: Any) {
        self.videoCapture.stop()
        magneticFieldManager.toggleTorch(on: false)
        self.dismiss(animated: true)
    }
    
    @IBAction func infoButtonClicked(_ sender: UIButton) {
        let infoVC = InfoViewController.control(.camera)
        infoVC.modalPresentationStyle = .overCurrentContext
        self.present(infoVC, animated: false)
    }
    
    @IBAction func torchButtonClicked(_ sender: UIButton) {
        torchButton.isSelected = !torchButton.isSelected
        if torchButton.isSelected {
            magneticFieldManager.toggleTorch(on: true)
        } else {
            magneticFieldManager.toggleTorch(on: false)
        }
    }
}

//MARK: - Extension
extension CameraViewController {
    //MARK: - Show Camera Alert
    func showSettingsAlert() {
        let alert = UIAlertController(title: "Camera Access Denied",
                                      message: "To take photos, please allow access to the camera in Settings.",
                                      preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) in
            // Open app settings
            if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(settingsAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera not available")
        }
    }
    
    func checkCameraAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
        case .authorized:
            // Camera access authorized
            self.setUpCamera()
        case .denied, .restricted:
            // Camera access denied or restricted
            showSettingsAlert()
        case .notDetermined:
            // Request camera access
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    Helper.dispatchMain {
                        self?.setUpCamera()
                    }
                }
            }
        @unknown default:
            fatalError("New status is added in AVCaptureDevice.AuthorizationStatus")
        }
    }
}

extension CameraViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let _ = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // Do something with the image, for example, display it in an image view
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    // Delegate method to handle when the user cancels taking a picture
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension CameraViewController: VideoCaptureDelegate, MeasureDelegate {
    
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int) {
        print(executionTime, fps)
    }
    
    func videoCapture(_ capture: VideoCapture, didCaptureVideoFrame pixelBuffer: CVPixelBuffer?, timestamp: CMTime) {
        // the captured image from camera is contained on pixelBuffer
        if !self.isInferencing, let pixelBuffer = pixelBuffer {
            self.isInferencing = true
            // start of measure
            self.measureModel.startMeasuring()
            Helper.dispatchMain {
                // predict!
                self.predictUsingVision(pixelBuffer: pixelBuffer)
            }
        }
    }
    
    func predictUsingVision(pixelBuffer: CVPixelBuffer) {
//        guard let request = request else { fatalError() }
//        // vision framework configures the input size of image following our model's input configuration automatically
//        self.semaphore.wait()
//        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer)
//        try? handler.perform([request])
    }
    
    // MARK: - Post-processing
    func visionRequestDidComplete(request: VNRequest, error: Error?) {
        self.measureModel.🏷(with: "endInference")
        if let predictions = request.results as? [VNRecognizedObjectObservation] {
    
             self.boxViews.predictedObjects = predictions
            // self.labelsTableView.reloadData()
            // end of measure
//            let confidence = predictions[0].labels.first?.confidence ?? -1
//            let confidenceString = String(format: "%.3f", confidence/*Math.sigmoid(confidence)*/)
//            
//            print("confidence score \(confidenceString)")
//            
            self.measureModel.🎬🤚()
            
            self.isInferencing = false
            
        } else {
            // end of measure
            self.measureModel.🎬🤚()
            
            self.isInferencing = false
        }
        self.semaphore.signal()
    }
}
