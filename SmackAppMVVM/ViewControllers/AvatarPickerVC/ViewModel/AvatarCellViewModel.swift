//
//  AvatarCellViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 10/02/2022.
//

import Foundation

import Foundation

class AvatarCellViewModel{
    
    var cell: AvatarCell?
    var background = Observable<CGColor>()
    var imageName = Observable<String>()
    
    //MARK: - setCellInstance()
    func setCellInstance(cell: AvatarCell) {
        self.cell = cell
    }
    
    // MARK: - setupView()
    func setupView(){
        cell?.layer.backgroundColor = UIColor.lightGray.cgColor
        cell?.layer.cornerRadius = 10
        cell?.clipsToBounds = true
    }
    
    // MARK: - setItemData()
    func setItemData(index: Int, type: AvatarType){
        if type == AvatarType.dark {
            imageName.property = "dark\(index)"
            background.property = UIColor.lightGray.cgColor
        } else {
            imageName.property = "light\(index)"
            background.property = UIColor.gray.cgColor
        }
    }
}
