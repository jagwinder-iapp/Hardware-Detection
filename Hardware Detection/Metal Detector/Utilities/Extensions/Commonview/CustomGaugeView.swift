//
//  CustomGaugeView.swift
//  Metal Detector
//
//  Created by iApp on 28/02/24.
//

import UIKit

/// A view for showing a single number on an LED display
@IBDesignable open class CustomGauge: UIView {

    /// Whether to maintain a view of local maximums
    @IBInspectable open var holdPeak = false

    /// This applies a gradient style to the rendering
    @IBInspectable open var litEffect = true

    /// If `true` then render top-to-bottom or right-to-left
    @IBInspectable open var reverseDirection = false

    /// The quantity to be rendered
    @IBInspectable open var value = 0.0 {
        didSet {
            var redraw = false
            // Point at which bars start lighting up
            let newOnIdx = (value >= minLimit) ? 0 : numBars
            if onIdx != newOnIdx {
                onIdx = newOnIdx
                redraw = true
            }
            // Point at which bars are no longer lit
            let newOffIdx = Int(((value - minLimit) / (maxLimit - minLimit)) * Double(numBars))
            if newOffIdx != offIdx {
                offIdx = newOffIdx
                redraw = true
            }
            // Are we doing peak?
            if holdPeak && value > peakValue {
                peakValue = value
                peakBarIdx = min(offIdx, numBars - 1)
            }
            // Redraw the display?
            if redraw {
                setNeedsDisplay()
            }
        }
    }

    /// The local maximum for `value`
    @IBInspectable open var peakValue = 0.0

    /// The highest possible amount for `value`
    @IBInspectable open var maxLimit = 1.0

    /// The lowest possible amount for `value`, must be less than `maxLimit`
    @IBInspectable open var minLimit = 0.0

    /// A quantity for `value` which will render in a special color
    @IBInspectable open var warnThreshold = 0.6 {
        didSet {
            if !warnThreshold.isNaN && warnThreshold > 0.0 {
                warningBarIdx = Int(warnThreshold * Double(numBars))
            } else {
                warningBarIdx = -1
            }
        }
    }

    /// A quantity for `value` which will render in a special color
    @IBInspectable open var dangerThreshold = 0.8 {
        didSet {
            if !dangerThreshold.isNaN && dangerThreshold > 0.0 {
                dangerBarIdx = Int(dangerThreshold * Double(numBars))
            } else {
                dangerBarIdx = -1
            }
        }
    }

    /// The number of discrete segments to render
    @IBInspectable open var numBars: Int = 10 {
        didSet {
            peakValue = -.infinity // force it to be updated w/new bar index
            // Update thresholds
            value = 1 * value
            warnThreshold = 1 * warnThreshold
            dangerThreshold = 1 * dangerThreshold
        }
    }

    /// Outside border color
    @IBInspectable open var outerBorderColor = UIColor.clear

    /// Inside border color
    @IBInspectable open var innerBorderColor = UIColor.clear

    /// The rendered segment color before reaching the warning threshold
    @IBInspectable open var normalColor = UIColor.green

    /// The rendered segment color after reaching the warning threshold
    @IBInspectable open var warningColor = UIColor.yellow

    /// The rendered segment color after reaching the danger threshold
    @IBInspectable open var dangerColor = UIColor.red
    
    @IBInspectable open var thickness = 2
    
    @IBInspectable open var spaceBetweenBars = 2.0


    fileprivate var onIdx = 0
    fileprivate var offIdx = 0
    fileprivate var peakBarIdx = -1
    fileprivate var warningBarIdx = 6
    fileprivate var dangerBarIdx = 8

    fileprivate func setup() {
        clearsContextBeforeDrawing = false;
        isOpaque = false;
        backgroundColor = UIColor.clear
    }

    /// UIView initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// UIView initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Resets peak value
    public func resetPeak() {
        peakValue = -.infinity
        peakBarIdx = -1
        self.setNeedsDisplay()
    }

    /// Draw the gauge
    override open func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }

        ctx.clear(self.bounds)
        
        var rectBounds = self.bounds
        let isVertical = rectBounds.size.height >= rectBounds.size.width

        // Increase space between bars by modifying barSize
        let spaceBetweenBars = spaceBetweenBars // Adjust the value as needed
        let barSize: Int

        if isVertical {
            barSize = Int((rectBounds.size.height - spaceBetweenBars * CGFloat(numBars - 1)) / CGFloat(numBars))
            rectBounds.size.height = CGFloat(barSize * numBars) + spaceBetweenBars * CGFloat(numBars - 1)
        } else {
            barSize = Int((rectBounds.size.width - spaceBetweenBars * CGFloat(numBars - 1)) / CGFloat(numBars))
            rectBounds.size.width = CGFloat(barSize * numBars) + spaceBetweenBars * CGFloat(numBars - 1)
        }

        // Compute size of bar
        var rectBar = CGRect(x: 0, y: 0, width: isVertical ? rectBounds.size.width - 2 : CGFloat(barSize), height: isVertical ? CGFloat(barSize) : rectBounds.size.height - 2)

        // Fill background
        ctx.setFillColor(backgroundColor!.cgColor)
        ctx.fill(rectBounds)

        // Draw LED bars
        for iX in 0..<numBars {
            // Adjust position for space between bars
            rectBar.origin.x = (isVertical) ? rectBounds.origin.x + 1 : (rectBounds.minX + CGFloat(iX * (barSize + Int(spaceBetweenBars))))
            rectBar.origin.y = (isVertical) ? (rectBounds.maxY - CGFloat((iX + 1) * (barSize + Int(spaceBetweenBars)))) : rectBounds.origin.y + 1

            // Determine color of bar
            let clrFill: UIColor = (iX < Int(value.rounded())) ? dangerColor : UIColor(hexString: "5F697F")

            // Fill the interior of the bar
            ctx.saveGState()
            let rectFill = rectBar.insetBy(dx: 1.0, dy: 1.0)
            ctx.addRect(rectFill)
            ctx.clip()
            self.drawBar(ctx, withRect: rectFill, andColor: clrFill, lit: false)
            ctx.restoreGState()
            
            // Draw border around the control
            ctx.setStrokeColor(outerBorderColor.cgColor)
            ctx.setLineWidth(CGFloat(thickness))
            ctx.addRect(rectBounds.insetBy(dx: 1, dy: 1))
            ctx.strokePath()
        }
    }


    /// Draw one of the bar segments inside the gauge
    fileprivate func drawBar(_ a_ctx: CGContext, withRect a_rect: CGRect, andColor a_clr: UIColor, lit a_fLit: Bool) {
        // Is the bar lit?
        if a_fLit {
            // Are we doing radial gradient fills?
            if litEffect {
                // Yes, set up to draw the bar as a radial gradient
                let num_locations: size_t = 2
                let locations: [CGFloat] = [0.0, 0.5]
                var aComponents = [CGFloat]()
                let clr: CGColor = a_clr.cgColor
                // Set up color components from passed UIColor object
                if clr.numberOfComponents == 4 {
                    let ci = CIColor(color: a_clr)
                    aComponents.append(ci.red)
                    aComponents.append(ci.green)
                    aComponents.append(ci.blue)
                    aComponents.append(ci.alpha)
                    // Calculate dark color of gradient
                    aComponents.append(aComponents[0] - ((aComponents[0] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[1] - ((aComponents[1] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[2] - ((aComponents[2] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[3])
                }

                // Calculate radius needed
                let width: CGFloat = a_rect.width
                let height: CGFloat = a_rect.height
                let radius: CGFloat = sqrt(width * width + height * height)

                // Draw the gradient inside the provided rectangle
                let myColorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let myGradient: CGGradient = CGGradient(colorSpace: myColorspace, colorComponents: aComponents, locations: locations, count: num_locations)!
                let myStartPoint = CGPoint(x: a_rect.midX, y: a_rect.midY)
                a_ctx.drawRadialGradient(myGradient, startCenter: myStartPoint, startRadius: 0.0, endCenter: myStartPoint, endRadius: radius, options: [])
            }
            else {
                // No, solid fill
                a_ctx.setFillColor(a_clr.cgColor)
                a_ctx.fill(a_rect)
            }
        }
        else {
            // No, draw the bar as background color overlayed with a mostly
            // ... transparent version of the passed color
            let fillClr: CGColor = a_clr.cgColor.copy(alpha: 1)!
            a_ctx.setFillColor(backgroundColor!.cgColor)
            a_ctx.fill(a_rect)
            a_ctx.setFillColor(fillClr)
            a_ctx.fill(a_rect)
        }
    }
}
