//
//  Measure.swift
//  TurtleApp-CoreML
//
//  Created by GwakDoyoung on 03/07/2018.
//  Copyright © 2018 GwakDoyoung. All rights reserved.
//

import UIKit

protocol MeasureDelegate {
    func updateMeasure(inferenceTime: Double, executionTime: Double, fps: Int)
}
// Performance Measurement
class Measure {
    
    var delegate: MeasureDelegate?
    
    var index: Int = -1
    var measurements: [Dictionary<String, Double>]
    
    init() {
        let measurement = [
            "start": CACurrentMediaTime(),
            "end": CACurrentMediaTime()
        ]
        measurements = Array<Dictionary<String, Double>>(repeating: measurement, count: 30)
    }
    
    // start
    func startMeasuring() {
        index += 1
        index %= 30
        measurements[index] = [:]
        
        🏷(for: index, with: "start")
    }
    
    // stop
    func 🎬🤚() {
        🏷(for: index, with: "end")
        
        let beforeMeasurement = getBeforeMeasurment(for: index)
        let currentMeasurement = measurements[index]
        if let startTime = currentMeasurement["start"],
            let endInferenceTime = currentMeasurement["endInference"],
            let endTime = currentMeasurement["end"],
            let beforeStartTime = beforeMeasurement["start"] {
            delegate?.updateMeasure(inferenceTime: endInferenceTime - startTime,
                                    executionTime: endTime - startTime,
                                    fps: Int(1/(startTime - beforeStartTime)))
        }
        
    }
    
    // labeling with
    func 🏷(with msg: String? = "") {
        🏷(for: index, with: msg)
    }
    
    private func 🏷(for index: Int, with msg: String? = "") {
        if let message = msg {
            measurements[index][message] = CACurrentMediaTime()
        }
    }
    
    private func getBeforeMeasurment(for index: Int) -> Dictionary<String, Double> {
        return measurements[(index + 30 - 1) % 30]
    }
    
}

class MeasureLogView: UIView {
    let etimeLabel = UILabel(frame: .zero)
    let fpsLabel = UILabel(frame: .zero)
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class MovingAverageFilter {
    private var arr: [Int] = []
    private let maxCount = 10
    
    public func append(element: Int) {
        arr.append(element)
        if arr.count > maxCount {
            arr.removeFirst()
        }
    }
    
    public var averageValue: Int {
        guard !arr.isEmpty else { return 0 }
        let sum = arr.reduce(0) { $0 + $1 }
        return Int(Double(sum) / Double(arr.count))
    }
}
