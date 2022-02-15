//
//  CreateAccountViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 02/02/2022.
//

import Foundation
class CreateAccountViewModel{
    
    var viewController: CreateAccountVC?
    var authenticateSuccesfully = Observable<Bool>()
    var errorMessage = Observable<String>()
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var avatarName = "defaultProfile"
    var avatarColor = "[0.5,0.5,0.5,1]"
    var bgColor: UIColor?
    
    //MARK: - setViewController()
    func setViewController(view: CreateAccountVC) {
        self.viewController = view
        view.spinner.isHidden = true
    }
    
    //MARK: - settingKeyboard()
    func settingKeyboard(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapHandle))
        self.viewController?.view.addGestureRecognizer(tap)
    }
    
    //MARK: - tapHandle()
    @objc func tapHandle(){
        self.viewController?.view.endEditing(true)
    }
    
    //MARK: - registeringUser()
    func registeringUser(){
        viewController?.spinner.isHidden = false
        viewController?.spinner.startAnimating()
        
        if viewController?.userNameTxt.text != ""
            && viewController?.emailTxt.text != ""
            && viewController?.passwordTxt.text != "" {
            name = viewController?.userNameTxt.text ?? ""
            password = viewController?.passwordTxt.text ?? ""
            email = viewController?.emailTxt.text ?? ""
        }
        
        if name == "" || password == "" || email == "" {
            
            showingAlertForEmptyFields()
        }
        else {
            
            AuthService.instance.registerUser(email: email, password: password) { success, error in
                
                self.viewController?.spinner.isHidden = true
                self.viewController?.spinner.stopAnimating()
                
                if success {
                    AuthService.instance.loginUser(email: self.email, password: self.password) { [self] success, error in
                        if success {
                            AuthService.instance.creatUser(name: self.name, email: self.email, avatarName: self.avatarName, avatarColor: self.avatarColor) { success, error in
                                if success {
                                    self.authenticateSuccesfully.property = true
                                } else {
                                    self.authenticateSuccesfully.property = false
                                    self.errorMessage.property = error?.localizedDescription
                                }
                            }
                        } else {
                            self.authenticateSuccesfully.property = false
                            self.errorMessage.property = error?.localizedDescription
                        }
                    }
                } else {
                    self.authenticateSuccesfully.property = false
                    self.errorMessage.property = error?.localizedDescription
                }
            }
        }
        
 
    }
    
    //MARK: - settingUpAvatar()
    func settingUpAvatar(){
        if UserDataService.instance.avatarName != ""{
            viewController?.userImg.image = UIImage(named: UserDataService.instance.avatarName)
            self.avatarName = UserDataService.instance.avatarName
            if avatarName.contains("light") && bgColor == nil{
                viewController?.userImg.backgroundColor = UIColor.lightGray
            }
        }
    }
    
    //MARK: - generatingBgColor()
    func generatingBgColor(){
        
        let r = CGFloat(arc4random_uniform(225)) / 225
        let g = CGFloat(arc4random_uniform(225)) / 225
        let b = CGFloat(arc4random_uniform(225)) / 225
        
        bgColor = UIColor(red: r, green: g, blue: b, alpha: 1)
        avatarColor = "[\(r), \(g), \(b), 1]"
        UIView.animate(withDuration: 0.2) {
            self.viewController?.userImg.backgroundColor = self.bgColor
        }
    }
    
    // MARK: - clearingAvatar()
    func clearingAvatar(){
        UserDataService.instance.setupAvatarName(avatarName: "profileDefault")
    }
    
    // MARK: - showingAlertForEmptyFields
    func showingAlertForEmptyFields(){
        self.viewController?.spinner.isHidden = true
        self.viewController?.spinner.stopAnimating()
        let alert = UIAlertController(title: "Invalid", message: "Fields are empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        viewController?.present(alert, animated: true, completion: nil)
    }
}

