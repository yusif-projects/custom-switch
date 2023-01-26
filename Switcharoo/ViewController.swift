//
//  ViewController.swift
//  Switcharoo
//
//  Created by Yusif Aliyev on 11.01.23.
//

import UIKit

class ViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle { return .darkContent }
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation { return .portrait }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overrideUserInterfaceStyle = .light
        
        // 🍏
    }
    
}

@IBDesignable
class Switcharoo: UIView {
    
    var backgroundView: UIView!
    var circleView: UIView!
    var fillView: UIView!
    
    var distance: NSLayoutConstraint!
    var shadowHeight: NSLayoutConstraint!
    
    @IBInspectable public var isOn: Bool = false
    @IBInspectable public var padding: CGFloat = 8
    @IBInspectable public var dotColor: UIColor = .white
    @IBInspectable public var onColor: UIColor = .green
    @IBInspectable public var offColor: UIColor = .gray
    
    private var height: CGFloat!
    private var onDistance: CGFloat!
    private var offDistance: CGFloat!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        height = self.frame.size.height - padding * 2
        onDistance = self.frame.size.width - (padding + height)
        offDistance = padding
        
        createBackground()
        createCircle()
        createFill()
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tapHandler))
        backgroundView.addGestureRecognizer(tapGR)
        
        let swipeLeftGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeLeftGR.direction = .left
        circleView.addGestureRecognizer(swipeLeftGR)
        
        let swipeRightGR = UISwipeGestureRecognizer(target: self, action: #selector(swipeHandler))
        swipeRightGR.direction = .right
        circleView.addGestureRecognizer(swipeRightGR)
    }
    
    private func createBackground() {
        backgroundView = UIView()
        backgroundView.backgroundColor = offColor
        backgroundView.layer.cornerRadius = self.frame.size.height / 2
        backgroundView.clipsToBounds = true
        
        self.addSubview(backgroundView)
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        if let backgroundView = backgroundView {
            NSLayoutConstraint(item: backgroundView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: backgroundView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    private func createCircle() {
        circleView = UIView()
        circleView.backgroundColor = dotColor
        circleView.layer.cornerRadius = height / 2
        
        backgroundView.addSubview(circleView)
        
        circleView.translatesAutoresizingMaskIntoConstraints = false
        
        if let circleView = circleView {
            distance = NSLayoutConstraint(item: circleView, attribute: .leading, relatedBy: .equal, toItem: backgroundView, attribute: .leading, multiplier: 1, constant: 0)
            distance.isActive = true
            
            setupDistance()
            
            NSLayoutConstraint(item: circleView, attribute: .centerY, relatedBy: .equal, toItem: backgroundView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: circleView, attribute: .height, relatedBy: .equal, toItem: backgroundView, attribute: .height, multiplier: 1, constant: -2 * padding).isActive = true
            NSLayoutConstraint(item: circleView, attribute: .width, relatedBy: .equal, toItem: circleView, attribute: .height, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    private func createFill() {
        fillView = UIView()
        fillView.backgroundColor = onColor
        
        backgroundView.addSubview(fillView)
        backgroundView.sendSubviewToBack(fillView)
        
        fillView.translatesAutoresizingMaskIntoConstraints = false
        
        if let circleShadowView = fillView {
            NSLayoutConstraint(item: circleShadowView, attribute: .centerX, relatedBy: .equal, toItem: circleView, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
            NSLayoutConstraint(item: circleShadowView, attribute: .centerY, relatedBy: .equal, toItem: circleView, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
            
            shadowHeight = NSLayoutConstraint(item: circleShadowView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
            shadowHeight.isActive = true
            
            setupScale()
            
            circleShadowView.layer.cornerRadius = shadowHeight.constant / 2
            
            NSLayoutConstraint(item: circleShadowView, attribute: .height, relatedBy: .equal, toItem: circleShadowView, attribute: .width, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    private func setupDistance() {
        if isOn {
            distance.constant = onDistance
        } else {
            distance.constant = offDistance
        }
    }
    
    private func setupScale() {
        if isOn {
            shadowHeight.constant = self.frame.size.width * 2
        } else {
            shadowHeight.constant = height - 1
        }
    }
    
    @objc private func tapHandler(_ tap: UITapGestureRecognizer) {
        if tap.location(in: self).x >= self.frame.size.width / 2 {
            isOn = true
        } else {
            isOn = false
        }
        
        animateTransiton()
    }
    
    @objc private func swipeHandler(_ swipe: UISwipeGestureRecognizer) {
        let direction = swipe.direction
        
        if isOn && direction == .left {
            isOn.toggle()
            animateTransiton()
        } else if !isOn && direction == .right {
            isOn.toggle()
            animateTransiton()
        }
    }
    
    private func animateTransiton() {
        setupDistance()
        setupScale()
        
        UIView.animate(withDuration: 1/5, delay: 0, options: .curveLinear) {
            self.fillView.layer.cornerRadius = self.shadowHeight.constant / 2
            self.layoutIfNeeded()
        }
    }
    
    private func toggle() {
        isOn.toggle()
        
        animateTransiton()
    }
    
}
