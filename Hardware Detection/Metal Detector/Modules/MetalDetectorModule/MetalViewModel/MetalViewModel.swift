//
//  MetalViewModel.swift
//  Metal Detector
//
//  Created by iApp on 11/03/24.
//

import Foundation
import CoreMotion
import Charts
import AVFoundation
import CoreHaptics

class MetalViewModel {
    
    var upperLimit = 500.0
    let lowerLimit = 0.0
    
    let boostArray = [100.0,105.0,110.0,115.0,120.0,125.0,130.0]
    var boostValue = 0.0
    
    let dangerLimit = 50
    
    private let motionManager = CMMotionManager()
    // Number of samples to use for the moving average
    private let bufferSize = 10
    private var magneticFieldBuffer = [(x: Double, y: Double, z: Double)]()
    
    //Property for torch
    private let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
    
    //for vibration
    //    var isVibrationOn = true
    private let impactFeedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
    
    var frequencyClousure : ((_ frequency:Int, _ magnitude:Int)->Void)?
    
    private var isVibrationOn = false
    private var engine: CHHapticEngine?
    private var player: CHHapticPatternPlayer?
    private var currentSoundID: SystemSoundID = 0
    
    private var audioPlayer: AVAudioPlayer?
    
    
    init() {
        self.updateUpperLimitBasedOnDevice()
        do {
            engine = try CHHapticEngine()
            try? engine?.start()
        } catch let error {
            print("Engine Creation Error: \(error)")
        }
        
        // Load the audio file from the app's bundle
        if let soundURL = Bundle.main.url(forResource: "beep_beep", withExtension: "wav") {
            do {
                // Initialize the audio player with the sound file
                audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                
                // Prepare the audio player for playback
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading audio file: \(error.localizedDescription)")
            }
        } else {
            print("Audio file not found in the bundle")
        }
    }
    
    
    private func updateUpperLimitBasedOnDevice() {
        
        switch UIDevice.current.iPhoneModelType {
        case .belowXSeries:
            `upperLimit` = 500.0 // or any other value you want for devices below X series
        case .XSeries:
            upperLimit = 700.0 // or any other value you want for X series
        case .XSeries11:
            upperLimit = 800.0 // or any other value you want for X series 11
        case .XSeries12:
            upperLimit = 1000.0 // or any other value you want for X series 12
        case .XSeries13:
            upperLimit = 1200.0 // or any other value you want for X series 13
        case .XSeries14:
            upperLimit = 13000.0 // or any other value you want for X series 14
        case .XSeries15:
            upperLimit = 1500.0 // or any other value you want for X series 15
        default:
            upperLimit = 500.0 // Default value for unknown devices
        }
    }
    
    func toggleVibration() {
        if isVibrationOn {
            stopVibration()
        } else {
            startVibration()
        }
    }
    
    public func startVibration() {
        guard let engine = engine else { return }
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1.0)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1.0)
        let event = CHHapticEvent(eventType: .hapticContinuous, parameters: [intensity, sharpness], relativeTime: 0, duration: 0.5)
        do {
            let pattern = try CHHapticPattern(events: [event], parameters: [])
            player = try engine.makePlayer(with: pattern)
            try? player?.start(atTime: CHHapticTimeImmediate)
            isVibrationOn = true
        } catch let error {
            print("Error playing haptic: \(error)")
        }
    }
    
    public func stopVibration() {
        isVibrationOn = false
        do {
            try player?.stop(atTime: CHHapticTimeImmediate)
        } catch let error {
            print("Error stopping haptic: \(error)")
        }
    }
    
    func toggleMute(mute: Bool) {
        if !mute {
            audioPlayer?.play()
        }else{
            audioPlayer?.pause()
        }
    }
    
    //MARK: - Torch on Off
    func toggleTorch(on: Bool) {
        guard let captureDevice = captureDevice else { return }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.torchMode = on ? .on : .off
            captureDevice.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    }
    
    
    func startMetalDetection(isMetal:Bool) {
    
    }
    
    
    func applyLowPassFilter(to magneticField: CMMagneticField) -> (x: Double, y: Double, z: Double) {
        // Add the latest magnetic field data to the buffer
        magneticFieldBuffer.append((x: magneticField.x, y: magneticField.y, z: magneticField.z))
        
        // Trim the buffer to the specified size
        if magneticFieldBuffer.count > bufferSize {
            magneticFieldBuffer.removeFirst()
        }
        
        // Calculate the moving average
        let average = magneticFieldBuffer.reduce((0.0, 0.0, 0.0)) { result, element in
            return (result.0 + element.x, result.1 + element.y, result.2 + element.z)
        }
        
        return (
            x: average.0 / Double(magneticFieldBuffer.count),
            y: average.1 / Double(magneticFieldBuffer.count),
            z: average.2 / Double(magneticFieldBuffer.count)
        )
    }
    
    func stopMetalDetection() {
        motionManager.stopMagnetometerUpdates()
    }
}


