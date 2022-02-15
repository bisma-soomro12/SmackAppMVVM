//
//  CreateAccountVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 31/01/2022.
//

import UIKit

class CreateAccountVC: UIViewController {
    
    // outlets
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    let viewModel = CreateAccountViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setViewController(view: self)
        viewModel.settingKeyboard()
        setObservers()
    }
    //MARK: - viewDidAppear(_ animated: Bool)
    override func viewDidAppear(_ animated: Bool) {
        viewModel.settingUpAvatar()

    }
    
    //MARK: - CreateAccPressed(_ sender: Any)
    @IBAction func CreateAccPressed(_ sender: Any) {
        viewModel.registeringUser()
    }
    
    //MARK: - chooseAvatarPressed(_ sender: Any)
    @IBAction func chooseAvatarPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_AVATAR_PICKER, sender: nil)
    }
    
    //MARK: - generateBgColorPressed(_ sender: Any)
    @IBAction func generateBgColorPressed(_ sender: Any) {
        viewModel.generatingBgColor()
    }
    
    //MARK: - closedBtnPressed(_ sender: Any)
    @IBAction func closedBtnPressed(_ sender: Any) {
        viewModel.clearingAvatar()
        performSegue(withIdentifier: UNWIND, sender: nil)
    }
    
    //MARK: - setObservers()
    func setObservers() {
        viewModel.authenticateSuccesfully.observe = { status in
            if status {
                print("Authenticated")
                NotificationCenter.default.post(name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
                self.spinner.isHidden = true
                self.spinner.stopAnimating()
                self.performSegue(withIdentifier: UNWIND, sender: nil )
            } else {
                print("Invalid User")
            }
        }
        viewModel.errorMessage.observe = { error in
            print(error)
        }
    }
}
