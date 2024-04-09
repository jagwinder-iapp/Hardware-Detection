//
//  UIViewExtension.swift
//  Metal Detector
//
//  Created by iapp on 27/02/24.
//

import UIKit


extension UIView {
    func applyGradient(colours: [UIColor]) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = [0.0, 1.0]
        gradient.frame = self.bounds
        self.layer.insertSublayer(gradient, at: 0)
    }
}


extension UILabel {

    // Pass value for any one of both parameters and see result
    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        // Line spacing attribute
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

extension UITableView {
    
    func registerXib(nibName: String) {
        register(UINib(nibName: nibName, bundle: nil), forCellReuseIdentifier: nibName)
    }
}

//MARK: - Load Nib 
extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    //MARK: - Apply Animation on View Dismiss
    func applyAnimationOnDismissView() {
        let transition: CATransition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        self.window!.layer.add(transition, forKey: nil)
    }
}

//MARK: - Opacity Animation
extension CALayer {
    func animateOpacity(fromValue: Float, toValue: Float, duration: TimeInterval) {
        self.opacity = fromValue
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = fromValue
        opacityAnimation.toValue = toValue
        opacityAnimation.duration = duration
        self.add(opacityAnimation, forKey: "opacityAnimation")
        self.opacity = toValue
    }
    
    //MARK: - Rotation Animation
    func animateRotationZ(duration: TimeInterval, forKey key: String) {
           let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
           rotationAnimation.toValue = NSNumber(value: Double.pi * 2)
           rotationAnimation.duration = duration
           rotationAnimation.isCumulative = true
           rotationAnimation.repeatCount = Float.greatestFiniteMagnitude
           self.add(rotationAnimation, forKey: key)
       }
  
}

//MARK: - TextField Placeholder with font and color 
extension UITextField {
    func setPlaceholder(text: String, withFont font: UIFont, andColor color: UIColor, opacity: CGFloat = 0.3) {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color.withAlphaComponent(opacity)
        ]
        attributedPlaceholder = NSAttributedString(string: text, attributes: attributes)
        tintColor = color.withAlphaComponent(opacity)
    }
}

//MARK: - Add border on top of view 
extension UIView {
    func addTopBorder(color: UIColor, thickness: CGFloat, cornerRadius: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: bounds.width, height: thickness)
        layer.addSublayer(border)
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
    }
}

//MARK: - Backspace Event 
extension String {
  var isBackspace: Bool {
    let char = self.cString(using: String.Encoding.utf8)!
    return strcmp(char, "\\b") == -92
  }
}


extension UIView {
    func animateToCenterFromBottom(duration: CFTimeInterval) {
        let screenSize = UIScreen.main.bounds.size
        let offsetY: CGFloat = 300
        let finalPosition = CGPoint(x: screenSize.width / 2, y: screenSize.height  - offsetY)
        let initialPosition = CGPoint(x: finalPosition.x, y: screenSize.height + self.bounds.size.height / 2)
        
        // Set the initial position
        self.layer.position = initialPosition
        
        // Create animation for position
        let positionAnimation = CABasicAnimation(keyPath: "position")
        positionAnimation.fromValue = NSValue(cgPoint: initialPosition)
        positionAnimation.toValue = NSValue(cgPoint: finalPosition)
        positionAnimation.duration = duration
        
        // Ensure the view stays at the final position after animation completes
        positionAnimation.isRemovedOnCompletion = false
        positionAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        // Add animation to the layer
        self.layer.add(positionAnimation, forKey: "positionAnimation")
    }
}
extension UICollectionView {
  var visibleCurrentCellIndexPath: IndexPath? {
    for cell in self.visibleCells {
      let indexPath = self.indexPath(for: cell)
      return indexPath
    }
    
    return nil
  }
}

extension UIView {
    func applyLinearGradientMask(colors: [UIColor], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        let maskLayer = CALayer()
        maskLayer.frame = bounds
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.mask = gradientLayer
        
        layer.mask = maskLayer
    }
}

extension UIViewController {
    func showNewAlert(_ title: String, _ message: String, handler: ((UIAlertAction) -> Void)?) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: handler)
            alertController.addAction(action)
            DispatchQueue.main.async {
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

extension UIApplication {
    
    
    class func topViewController(controller: UIViewController? = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?
        .rootViewController) -> UIViewController? {
            
            if let navigationController = controller as? UINavigationController {
                return topViewController(controller: navigationController.visibleViewController)
            }
            if let tabController = controller as? UITabBarController {
                if let selected = tabController.selectedViewController {
                    return topViewController(controller: selected)
                }
            }
            if let presented = controller?.presentedViewController {
                return topViewController(controller: presented)
            }
            return controller
        }
    
}


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                          documentAttributes: nil)
        } catch {
            print("Error converting HTML to attributed string:", error)
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
