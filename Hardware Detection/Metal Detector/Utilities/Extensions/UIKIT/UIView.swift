//
//  UIView.swift
//  FreshMeatMarket
//
//  Created by Lakhwinder Singh on 31/03/17.
//  Copyright © 2017 lakh. All rights reserved.
//

import UIKit



extension UIView {
    
    // MARK: FADE ANIMATION

    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 3.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = .zero
    }
    
    var isVisible: Bool {
        get {
            return !isHidden
        }
        set {
            isHidden = !newValue
        }
    }
    
    var height: CGFloat {
        get {
            return bounds.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var width: CGFloat {
        get {
            return bounds.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func circleView(){
        self.layer.cornerRadius = self.height / 2
    }
    
    func noBorder(){
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
    }
    
    func grayBorder(corner:CGFloat,color:UIColor){
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = 3.0
        self.layer.cornerRadius = corner
    }
    
    
    func greyRoundBorder(){
        self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        self.layer.cornerRadius = self.frame.height/2
        self.layer.borderWidth = 1
    }
    
    
    
    func setHidden(_ hidden: Bool, animated: Bool) {
        if !animated {
            isHidden = hidden
        }
        else {
            alpha = isHidden ? 0.0 : 1.0
            isHidden = false
            UIView.animate(withDuration: 0.5, animations: {() -> Void in
                self.alpha = hidden ? 0.0 : 1.0
            }, completion: {(_ finished: Bool) -> Void in
                self.isHidden = hidden
                self.alpha = 1.0
            })
        }
    }
    
    func setVisible(_ visible: Bool, animated: Bool) {
        setHidden(!visible, animated: animated)
    }
    
    func bringSubviewToFront(_ subview: UIView, withSuperviews number: Int) {
        var subview = subview
        for _ in 0...number {
            subview.superview?.bringSubviewToFront(subview)
            subview = subview.superview!
        }
    }
    
    func addSubviews(_ subviews: [UIView]) {
        for view in subviews {
            addSubview(view)
        }
    }
    
    func setDoneOnKeyboard(textview:UITextView) {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textview.inputAccessoryView = keyboardToolbar
    }
    
    @objc func dismissKeyboard() {
        self.endEditing(true)
    }
    
    
    // MARK: BUBBLE ANIMATION
    
    func animationBubbleEffect(duration: Double = 1, delay: Double = 0.5,repeated:Bool = false){
        
        UIView.animateKeyframes(withDuration: duration, delay: delay, options: [.calculationModeCubic,repeated ? .repeat : .calculationModeCubic], animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.20) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.30, relativeDuration: 0.30) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.60, relativeDuration: 0.30) {
                self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            }
        }) { isComplete in
            UIView.animate(withDuration: 0.6) {
                self.transform = CGAffineTransform.identity
            }
        }
    }
    
    // MARK: TRANSFORM ANIMATION
    
    func transformAnimation(y:CGFloat){
        
        UIView.animate(withDuration: 1, delay: 0.5, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.frame = CGRect(x: self.frame.origin.x, y: y, width: self.frame.width, height: self.frame.height)
            
        },completion: nil)
    }
    
}

// MARK: CARD VIEW WITH SHADOW

@IBDesignable
class CardView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 2

    @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
    @IBInspectable var shadowRadius: CGFloat = 0

    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shadowPath = shadowPath.cgPath
    }

}


// MARK: ROUNDED VIEW WITH RADIUS

@IBDesignable
public class RoundedView: UIView {

    @IBInspectable public var topLeft: Bool = false      { didSet { updateCorners() } }
    @IBInspectable public var topRight: Bool = false     { didSet { updateCorners() } }
    @IBInspectable public var bottomLeft: Bool = false   { didSet { updateCorners() } }
    @IBInspectable public var bottomRight: Bool = false  { didSet { updateCorners() } }
    @IBInspectable public var cornerRadius: CGFloat = 0  { didSet { updateCorners() } }

    public override init(frame: CGRect = .zero) {
        super.init(frame: frame)
        updateCorners()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateCorners()
    }
}

private extension RoundedView {
    func updateCorners() {
        var corners = CACornerMask()

        if topLeft     { corners.formUnion(.layerMinXMinYCorner) }
        if topRight    { corners.formUnion(.layerMaxXMinYCorner) }
        if bottomLeft  { corners.formUnion(.layerMinXMaxYCorner) }
        if bottomRight { corners.formUnion(.layerMaxXMaxYCorner) }

        layer.maskedCorners = corners
        layer.cornerRadius = cornerRadius
    }
}



// MARK: VIEW EXTENSION FOR CHAT

extension UIView {
    
    /** Adds Constraints in Visual Formate Language. It is a helper method defined in extensions for convinience usage
     
     - Parameter format: string formate as we give in visual formate, but view placeholders are like v0,v1, etc
     - Parameter views: It is a variadic Parameter, so pass the sub-views with "," seperated.
     */
    
    
    func blurViewEffect(withAlpha alpha: CGFloat = 1.0, cornerRadius: CGFloat = 0){
        
        let blurViews = self.subviews.filter({$0 is UIVisualEffectView})
        blurViews.forEach { blurView in
            blurView.removeFromSuperview()
        }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.isUserInteractionEnabled = false
        blurEffectView.alpha = alpha
        blurEffectView.layer.cornerRadius = cornerRadius
        blurEffectView.layer.masksToBounds = true
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.insertSubview(blurEffectView, at: 0)
    }
    
    func addConstraintsWithVisualStrings(format: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    /** This method binds the view with frame of keyboard frame. So, The View will change its frame with the height of the keyboard's height */
    func bindToTheKeyboard(_ bottomConstaint: NSLayoutConstraint? = nil) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name: UIResponder.keyboardWillChangeFrameNotification, object: bottomConstaint)
    }
    
    
    func backgroudTintView(_ maskView: UIView,cornerRadius: CGFloat = 0){
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.yellow.withAlphaComponent(0.5)
        view.alpha = 0
        view.tag = 1000001
        view.isUserInteractionEnabled = false
        self.addSubview(view)
        //        let frameWithSuper = sender.superview!.convert(sender.frame, from: controller.view)
        let frameWithSuper = maskView.superview!.convert(maskView.frame, to: self)
        debugPrint("frameWithSuper ",frameWithSuper)
        view.mask(withRect: frameWithSuper, cornerRadius: cornerRadius,inverse: true)
        
        UIView.animate(withDuration: 0.2, delay: 0) {
            view.alpha = 1
        }
    }
    
    func mask(withRect maskRect: CGRect, cornerRadius: CGFloat, inverse: Bool = false) {
        let maskLayer = CAShapeLayer()
        let path = CGMutablePath()
        if (inverse) {
            path.addPath(UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath)
        }
        path.addPath(UIBezierPath(roundedRect: maskRect, cornerRadius: cornerRadius).cgPath)
        
        maskLayer.path = path
        if (inverse) {
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }
        self.layer.mask = maskLayer;
    }
    
    
    @objc func keyboardWillChange(_ notification: NSNotification) {
        
        let duration = notification.userInfo![UIResponder.keyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo![UIResponder.keyboardAnimationCurveUserInfoKey] as! UInt
        let curveframe = (notification.userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let deltaY = targetFrame.origin.y - curveframe.origin.y
        
        if let constraint = notification.object as? NSLayoutConstraint {
            constraint.constant = deltaY
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
                self.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIView.KeyframeAnimationOptions.init(rawValue: curve), animations: {
                self.frame.origin.y += deltaY
            }, completion: nil)
        }
    }
    
    // MARK: ADDING SPECIFIC BORDERS

    @discardableResult
    func addBorders(edges: UIRectEdge,
                    color: UIColor,
                    inset: CGFloat = 0.0,
                    thickness: CGFloat = 1.0) -> [UIView] {

        var borders = [UIView]()

        @discardableResult
        func addBorder(formats: String...) -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            addSubview(border)
            addConstraints(formats.flatMap {
                NSLayoutConstraint.constraints(withVisualFormat: $0,
                                               options: [],
                                               metrics: ["inset": inset, "thickness": thickness],
                                               views: ["border": border]) })
            borders.append(border)
            return border
        }


        if edges.contains(.top) || edges.contains(.all) {
            addBorder(formats: "V:|-0-[border(==thickness)]", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            addBorder(formats: "V:[border(==thickness)]-0-|", "H:|-inset-[border]-inset-|")
        }

        if edges.contains(.left) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:|-0-[border(==thickness)]")
        }

        if edges.contains(.right) || edges.contains(.all) {
            addBorder(formats: "V:|-inset-[border]-inset-|", "H:[border(==thickness)]-0-|")
        }

        return borders
    }


}


// MARK: PARENT SCROLL

extension UITableView {
    func registerTableCell(identifier:String)  {
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func scrollToBottom(animated: Bool) {
            let y = contentSize.height - frame.size.height
            if y < 0 { return }
            setContentOffset(CGPoint(x: 0, y: y), animated: animated)
        }
}

extension UIScrollView {
    func scrollToTop() {
        let desiredOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(desiredOffset, animated: true)
   }
    
}

// MARK: button shadow

extension UIButton {
    func addShadow(radius:CGFloat=1.5) {
        self.layer.shadowColor = UIColor.white.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = radius
    }
}
