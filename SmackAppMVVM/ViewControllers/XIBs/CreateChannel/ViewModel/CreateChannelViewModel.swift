//
//  CreateChannelViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import Foundation
class CreateChannelViewModel {
    var viewController: CreateChannelVC?
    
    func settingViewController(view: CreateChannelVC){
        self.viewController = view
    }
    
    // MARK: - creatingChannel()
    func creatingChannel(){
        guard let chName = viewController?.nameTxt.text , viewController?.nameTxt.text != "" else { return }
        guard let chDesc = viewController?.descriptionTxt.text else {return}
        
        SocketService.instance.addChannel(channelName: chName, ChanelDesc: chDesc) { success, error in
            if success{
                self.viewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
}
