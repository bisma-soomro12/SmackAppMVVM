//
//  ChatVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 29/01/2022.
//

import UIKit

class ChatVC: UIViewController {
    
    var viewModel = ChatViewModel()
    
    // outlets
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var ChannelNameLbl: UILabel!
    @IBOutlet weak var messageBoxTxt: UITextField!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setupViewController(view: self)
        viewModel.settingRevealViewController()
        viewModel.setupTableView()
        viewModel.settingKeyboard()
        viewModel.getMessagesFromSocket()
        viewModel.typingUsers()
        viewModel.findUserByEmail()
        setObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELLECTED, object: nil)
    }
    
    // MARK: - sendBtnPressed(_ sender: Any)
    @IBAction func sendBtnPressed(_ sender: Any) {
        viewModel.sendBtn()
    }
    
    // MARK: - messageBoxEditing(_ sender: Any)
    @IBAction func messageBoxEditing(_ sender: Any) {
        viewModel.messageBoxEditng()
    }
    
    // MARK: - channelSelected(_ notif: Notification)
    @objc func channelSelected(_ notif: Notification){
        viewModel.updatingChannel()
    }
    
    // MARK: - userDataDidChange(_ notif: Notification)
    @objc func userDataDidChange(_ notif: Notification){
        if AuthService.instance.isLoggedIn{
            viewModel.getOnlineMessage()
        }
        else{
            ChannelNameLbl.text = "Please Log In"
            tableView.reloadData()
        }
    }
    
    // MARK: - setObserver()
    func setObserver(){
        viewModel.userDataDidChanged.observe = { success in
            if success {
                NotificationCenter.default.post(name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
            }
            else {
                print("Error")
            }
           
        }
    }
}

