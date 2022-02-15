//
//  LoginViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 02/02/2022.
//

import Foundation

class LoginViewModel {
    
    var viewController: LoginVC?
    var authenticateSuccesfully = Observable<Bool>()
    var errorMessage = Observable<String>()
    
    //MARK: - setupViewController()
    func setupViewController(view: LoginVC){
        self.viewController = view
        viewController?.spinner.isHidden = true
    }
    
    //MARK: - loggingInUser()
    func loggingInUser(){
        
        viewController?.spinner.isHidden = false
        viewController?.spinner.startAnimating()
        
         let email = viewController?.emailTxt.text
         let password = viewController?.passwordTxt.text
    
        if email == "" || password == "" {
            showingAlertForEmptyFields()
        }
        else{
            AuthService.instance.loginUser(email: email!, password: password!) { success, error in
                if success {
                    AuthService.instance.findUserByEmail { success, error in
                        if success{
                            self.authenticateSuccesfully.property = true
                        } else {
                            self.authenticateSuccesfully.property = false
                            self.errorMessage.property = error?.localizedDescription
                        }
                    }
                } else {
                    self.viewController?.spinner.isHidden = true
                    self.viewController?.spinner.stopAnimating()
                    self.authenticateSuccesfully.property = false
                    self.errorMessage.property = error?.localizedDescription
                }
            }
        }
        
       
    }
    
    // MARK: - showingAlertForInvalidEntries()
    func showingAlertForInvalidEntries(){
        let alert = UIAlertController(title: "Invalid", message: "Enter Correct Email and Password", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again", style: .cancel, handler: { action in
            self.viewController?.emailTxt.text = ""
            self.viewController?.emailTxt.resignFirstResponder()
            self.viewController?.passwordTxt.text = ""
            self.viewController?.passwordTxt.resignFirstResponder()
            print("Try Again")
        }))
        viewController?.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - showingAlertForEmptyFields
    func showingAlertForEmptyFields(){
        self.viewController?.spinner.isHidden = true
        self.viewController?.spinner.stopAnimating()
        let alert = UIAlertController(title: "Invalid", message: "Fields are empty", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))

        viewController?.present(alert, animated: true, completion: nil)
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
}
