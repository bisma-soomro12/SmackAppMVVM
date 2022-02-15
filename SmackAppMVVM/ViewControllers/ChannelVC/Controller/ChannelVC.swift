//
//  ChannelVC.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 29/01/2022.
//

import UIKit

class ChannelVC: UIViewController {
    
    let viewModel = ChannelViewModel()
    
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.setViewController(view: self)
        viewModel.settingRevealViewController()
        viewModel.setupTableView()
        viewModel.getChannelSocketListener()
        viewModel.getMessageSocketListener()
        setObserver()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.channelLoaded(_:)), name: NOTIF_CHANNELS_LOADED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelVC.userDataDidChange(_:)), name: NOTIFY_USER_DATA_DID_CHANGE, object: nil)
    }
    
    // MARK: - viewDidAppear(_ animated: Bool)
    override func viewDidAppear(_ animated: Bool) {
        viewModel.setupUserInfo()
    }
    
    // MARK: - prepareforUnWind(segue: UIStoryboardSegue)
    @IBAction func prepareforUnWind(segue: UIStoryboardSegue){
    }
    
    // MARK: - loginPressed(_ sender: Any)
    @IBAction func loginPressed(_ sender: Any) {
        viewModel.loginBtn()
    }
    
    // MARK: - addChannelPressed(_ sender: Any)
    @IBAction func addChannelPressed(_ sender: Any) {
        viewModel.channelBtn()
    }
    
    // MARK: - userDataDidChange(_ notif: Notification)
    @objc func userDataDidChange(_ notif: Notification){
        viewModel.setupUserInfo()
        self.tableView.reloadData()
    }
    // MARK: - channelLoaded(_ notif: Notification)
    @objc func channelLoaded(_ notif: Notification){
        self.tableView.reloadData()
    }
    
    // MARK: - setObserver()
    func setObserver() {
        viewModel.dataAdded.observe = { _ in
            self.tableView.reloadData()
        }
    }
}
