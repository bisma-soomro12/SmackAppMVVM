//
//  CreateChannelVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import UIKit

class CreateChannelVC: UIViewController {
    var viewModel = CreateChannelViewModel()
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.settingViewController(view: self)
    }
    // MARK: - closedPressed(_ sender: Any)
    @IBAction func closedPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - CreateChannelPressed(_ sender: Any)
    @IBAction func CreateChannelPressed(_ sender: Any) {
        viewModel.creatingChannel()
    }
}
