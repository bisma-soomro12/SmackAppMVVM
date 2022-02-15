//
//  AvatarCell.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 02/02/2022.
//

import UIKit
enum AvatarType{
    case dark
    case light
}

class AvatarCell: UICollectionViewCell {
    
    @IBOutlet weak var avatarImg: UIImageView!
    
    let viewModel = AvatarCellViewModel()
    
    override  func awakeFromNib() {
        super.awakeFromNib()
        
        viewModel.setCellInstance(cell: self)
        viewModel.setupView()
        setObservers()
    }
    
    //MARK: - setObservers()
    func setObservers() {
        viewModel.background.observe = { color in
            self.layer.backgroundColor = color
        }
        viewModel.imageName.observe = { name in
            self.avatarImg.image = UIImage(named: name)
        }
    }
}
