//
//  CircleImage.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 03/02/2022.
//

import UIKit
@IBDesignable
class CircleImage: UIImageView {

    override func awakeFromNib() {
        setUpView()
    }
    
    // MARK: - setUpView()
    func setUpView(){
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    // MARK: - prepareForInterfaceBuilder()
    override func prepareForInterfaceBuilder() {
        setUpView()
    }

}
