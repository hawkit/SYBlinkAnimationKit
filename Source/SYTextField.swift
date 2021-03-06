//
//  SYTextField.swift
//  SYBlinkAnimationKit
//
//  Created by Shohei Yokoyama on 12/13/2015.
//  Copyright © 2015年 Shohei. All rights reserved.
//

import UIKit

public enum SYTextFieldAnimation: Int {
    case Border
    case BorderWithShadow
    case Background
    case Ripple
}

public class SYTextField: UITextField, Animatable {

    @IBInspectable public var animationBorderColor:UIColor = UIColor() {
        didSet {
            syLayer.setAnimationBorderColor(animationBorderColor)
        }
    }
    @IBInspectable public var animationBackgroundColor:UIColor = UIColor() {
        didSet {
            syLayer.setAnimationBackgroundColor(animationBackgroundColor)
        }
    }
    @IBInspectable public var animationRippleColor:UIColor = UIColor() {
        didSet {
            syLayer.setAnimationRippleColor(animationRippleColor)
        }
    }
    
    override public var frame: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            syLayer.resizeSuperLayer()
        }
    }
    
    public var isAnimating = false
    
    @IBInspectable public var stopAnimationWithTouch = true
    
    private var originalBackgroundColor = UIColor.clearColor()
    
    public var animationTimingFunction: SYMediaTimingFunction = .Linear {
        didSet {
            syLayer.setAnimationTimingFunction(animationTimingFunction)
        }
    }
    @IBInspectable public var animationTimingAdapter: Int {
        get {
            return animationTimingFunction.rawValue
        }
        set(index) {
            animationTimingFunction = SYMediaTimingFunction(rawValue: index) ?? .Linear
        }
    }
    
    @IBInspectable public var animationDuration: CGFloat = 1.0 {
        didSet {
            syLayer.setAnimationDuration( CFTimeInterval(animationDuration) )
        }
    }
    
    override public func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent?) -> Bool {
        if stopAnimationWithTouch && isAnimating {
            stopAnimation()
        }
        
        return super.beginTrackingWithTouch(touch, withEvent: event)
    }
    
    override public var borderStyle: UITextBorderStyle {
        didSet {
            switch borderStyle {
            case .Bezel:
                self.layer.cornerRadius = 0.0
            case .Line:
                self.layer.cornerRadius = 0.0
            case .None:
                self.layer.cornerRadius = 5.0
            case .RoundedRect:
                self.layer.cornerRadius = 5.0
            }
        }
    }
    
    override public var backgroundColor: UIColor? {
        didSet {
            guard let bgColor = backgroundColor else { return }
            syLayer.setBackgroundColor(bgColor)
            originalBackgroundColor = bgColor
        }
    }
    
    private lazy var syLayer: SYLayer = SYLayer(sLayer: self.layer)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setLayer()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setLayer()
    }
    
    public var syTextFieldAnimation: SYTextFieldAnimation = .Border {
        didSet {
            switch syTextFieldAnimation {
            case .Border:
                syLayer.syLayerAnimation = .Border
            case .BorderWithShadow:
                syLayer.syLayerAnimation = .BorderWithShadow
            case .Background:
                syLayer.syLayerAnimation = .Background
            case .Ripple:
                syLayer.syLayerAnimation = .Ripple
            
            }
        }
    }
    @IBInspectable public  var syTextFieldAnimationAdapter: Int {
        get {
            return syTextFieldAnimation.rawValue
        }
        set(index) {
            syTextFieldAnimation = SYTextFieldAnimation(rawValue: index) ?? .Border
        }
    }
    
    public func startAnimation() {
        isAnimating = true
        if syTextFieldAnimation == .Background && borderStyle == .RoundedRect {
            backgroundColor = UIColor.clearColor()
        }
        
        syLayer.startAnimation()
    }
    
    public func stopAnimation() {
        isAnimating = false
        if syTextFieldAnimation == .Background &&  borderStyle == .RoundedRect {
            backgroundColor = originalBackgroundColor
        }
        syLayer.stopAnimation()
    }
}

private extension SYTextField {
    
    private func setLayer() {
        syLayer.syLayerAnimation = .Border
        borderStyle = .RoundedRect
    }
}
