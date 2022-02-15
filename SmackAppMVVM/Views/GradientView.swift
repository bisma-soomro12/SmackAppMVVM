//
//  GradientView.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 31/01/2022.
//

import UIKit
@IBDesignable

class GradientView: UIView {

    @IBInspectable var topColor: UIColor = UIColor.magenta {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor: UIColor = UIColor.cyan {
        didSet {
            self.setNeedsLayout()
        }
    }
    // MARK: - layoutSubviews()
    override func layoutSubviews() {
       customView()
    }
    // MARK: - prepareForInterfaceBuilder()
    override func prepareForInterfaceBuilder() {
        customView()
    }
    
    // MARK: - customView()
    func customView(){
        let gradientLayer =  CAGradientLayer()
        gradientLayer.colors = [ topColor.cgColor,bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

}
