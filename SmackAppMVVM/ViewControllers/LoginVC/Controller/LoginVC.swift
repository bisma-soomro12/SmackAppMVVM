//
//  LoginVc.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 31/01/2022.
//

import UIKit

class LoginVC: UIViewController {
    
    // outlets
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var viewModel = LoginViewModel()
    var viewController: CreateAccountVC?
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupViewController(view: self)
        viewModel.settingKeyboard()
        setObserver()
        
    }
    
    //MARK: - createAccountPressed(_ sender: Any)
    @IBAction func createAccountPressed(_ sender: Any) {
        
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    //MARK: - loginPressed(_ sender: Any)
    @IBAction func loginPressed(_ sender: Any) {
        viewModel.loggingInUser()
    }
    
    //MARK: - closedBtnPressed(_ sender: Any)
    @IBAction func closedBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - setObserver()
    func setObserver(){
        viewModel.authenticateSuccesfully.observe = { status in
            if status{
                print("Logged in")
                NotificationCenter.default.post(name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.dismiss(animated: true, completion: nil)
            }
            else{
                print("invalid user")
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.viewModel.showingAlertForInvalidEntries()
            }
        }
        viewModel.errorMessage.observe = { error in
            print(error)
        }
    }
}
