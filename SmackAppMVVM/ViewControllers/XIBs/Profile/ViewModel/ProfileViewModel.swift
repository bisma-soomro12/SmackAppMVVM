//
//  ProfileViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 03/02/2022.
//

import Foundation
class ProfileViewModel{
    
    var viewController: ProfileVC?
    
    // MARK: - setupViewController(view: ProfileVC)
    func setupViewController(view: ProfileVC){
        self.viewController = view
    }
    
    // MARK: - settingUpView()
    func settingUpView(){
        viewController?.userNameLbl.text = UserDataService.instance.name
        viewController?.userEmailLbl.text = UserDataService.instance.email
        viewController?.userImg.image = UIImage(named: UserDataService.instance.avatarName)
        viewController?.userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
    }
}
