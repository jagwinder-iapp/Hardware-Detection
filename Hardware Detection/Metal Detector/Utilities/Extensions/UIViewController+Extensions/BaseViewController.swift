//
//  BaseViewController.swift
//  Metal Detector
//
//  Created by iapp on 23/02/24.
//

import UIKit
import Charts

class BaseViewController: UIViewController {
    class func control(_ storyboard: AppAllStoryBoards) -> BaseViewController {
        return UIStoryboard.storyboard(storyboard).instantiateViewController(withIdentifier: String(describing: self)) as! BaseViewController
    }
    
    var dataEntries: [ChartDataEntry] = []
    var barUnits = [0]

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    final func openSubscription(isRootSet:Bool = false){
        let vc = PurchaseViewController.control(isRootSet: isRootSet)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    public func setChart(chartView: LineChartView, isDanger: Bool) {
        chartView.noDataText = "No data available!"
        var dataEntries = [ChartDataEntry]()

        for i in 0..<barUnits.count {
            print("chart point : \(barUnits[i])")
            let dataEntry = ChartDataEntry(x: Double(i), y: Double(barUnits[i]))
            dataEntries.append(dataEntry)
        }

        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Metal Frequency")
        lineChartDataSet.setCircleColor(UIColor.clear)
        lineChartDataSet.circleRadius = 0.0
        lineChartDataSet.lineWidth = 2.0
        lineChartDataSet.valueTextColor = UIColor.clear
        lineChartDataSet.colors = [NSUIColor(cgColor: isDanger ? Colors.redMetalColor!.cgColor : Colors.greenMetalColor!.cgColor)]
        lineChartDataSet.mode = .cubicBezier
        lineChartDataSet.cubicIntensity = 0.2

        var dataSets = [LineChartDataSet]()
        dataSets.append(lineChartDataSet)
        let lineChartData = LineChartData(dataSets: dataSets)
        
        chartView.xAxis.drawLabelsEnabled = false // Hide the labels on the X-axis
        chartView.leftAxis.labelTextColor = Colors.subtitleColor! // Set the desired text color for Y-axis labels
        chartView.leftAxis.labelFont = Font(.installed(.robotoMonoBold), size: .custom(12)).instance // Set the desired text color for Y-axis labels
        chartView.xAxis.enabled = true //show x axis
        chartView.leftAxis.enabled = true //show/hide left axix (Y axis)
        chartView.rightAxis.enabled = false //show/hide right axis (Y axis)
    //    chartView.animate(xAxisDuration: 1.5) //show animation
        chartView.drawGridBackgroundEnabled = false //show or hide background color
        chartView.xAxis.drawGridLinesEnabled = false //it will show/hide grid background (Verticles lines Y form x axix)
        chartView.xAxis.drawAxisLineEnabled = true //show x axis line
        chartView.xAxis.labelPosition = .bottom // values/labels of x axis - position
        chartView.leftAxis.drawGridLinesEnabled = true //hide/show x axis
        chartView.legend.enabled = false //show.hide legend - below graph

        chartView.data = lineChartData
        chartView.notifyDataSetChanged()
    }
    
    // MARK: PRESENT & DISMISS CONTROLLER

    final func setupPopOverViewWithAnimation(constraint:NSLayoutConstraint,constant:CGFloat) {
        ///Present screen with animation
        self.view.alpha = 0
        UIView.animate(withDuration: 0.1, delay: 0) {
            self.view.alpha = 1
        } completion: { isComplete in}
        constraint.constant = constant
        UIView.animate(withDuration: 0.2, delay: 0.1) {
            self.view.layoutIfNeeded()
        } completion: {_ in }
    }
    
    final func dismissPopOverView(constraint:NSLayoutConstraint,constant:CGFloat,_ completion:@escaping(_ status:Bool)->Void) {
        ///Dismiss screen with animation
        constraint.constant = constant
        UIView.animate(withDuration: 0.2, delay: 0.0) {
            self.view.layoutIfNeeded()
        } completion: {_ in }
        UIView.animate(withDuration: 0.1, delay: 0.2) {
            self.view.alpha = 0
        } completion: { isComplete in
            completion(true)
        }
    }
    
    // MARK: SET ROOT

    func rootControllerByCoordinator(step: AppStoryBoards) {
        let scene = UIApplication.shared.connectedScenes.first
        if let sceneDelegate = scene?.delegate as? SceneDelegate {
            let appCordinator = AppCordinator(window: sceneDelegate.window)
            appCordinator.start()
            appCordinator.step = step
        }
        
    }
}

