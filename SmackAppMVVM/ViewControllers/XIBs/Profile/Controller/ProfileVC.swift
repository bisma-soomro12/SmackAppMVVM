//
//  ProfileVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 03/02/2022.
//

import UIKit

class ProfileVC: UIViewController {
 
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var userEmailLbl: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    
    var viewModel = ProfileViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setupViewController(view: self)
        viewModel.settingUpView()
    }

    // MARK: - logoutPressed(_ sender: Any)
    @IBAction func logoutPressed(_ sender: Any) {
        UserDataService.instance.logoutUser()
        NotificationCenter.default.post(name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - closedPressed(_ sender: Any)
    @IBAction func closedPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
