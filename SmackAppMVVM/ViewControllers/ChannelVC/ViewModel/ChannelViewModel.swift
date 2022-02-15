//
//  ChannelViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 03/02/2022.
//

import Foundation
class ChannelViewModel: NSObject{
    
    var viewController: ChannelVC?
    var dataAdded = Observable<Bool>()
    
    // MARK: - setViewController(view: ChannelVC)
    func setViewController(view: ChannelVC){
        self.viewController = view
    }
    
    // MARK: - settingRevealViewController()
    func settingRevealViewController(){
        viewController?.revealViewController().rearViewRevealWidth = (viewController?.view.frame.size.width)!-60
    }
    // MARK: - setupTableView()
    func setupTableView(){
        viewController?.tableView.delegate = self
        viewController?.tableView.dataSource = self
    }
    
    // MARK: - setupUserInfo()
    func setupUserInfo(){
        if AuthService.instance.isLoggedIn{
            viewController?.loginBtn.setTitle(UserDataService.instance.name, for: .normal)
            viewController?.userImg.image = UIImage(named: UserDataService.instance.avatarName)
            viewController?.userImg.backgroundColor = UserDataService.instance.returnUIColor(components: UserDataService.instance.avatarColor)
        }
        else{
            viewController?.loginBtn.setTitle("Login", for: .normal)
            viewController?.userImg.image = UIImage(named: "menuProfileIcon")
            viewController?.userImg.backgroundColor = UIColor.clear
            viewController?.tableView.reloadData()
        }
    }
    // MARK: - loginBtn()
    func loginBtn(){
        if AuthService.instance.isLoggedIn{
            let profile = ProfileVC()
            profile.modalPresentationStyle = .custom
            viewController?.present(profile, animated: true, completion: nil)
        }
        else{
            viewController?.performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    // MARK: - channelBtn()
    func channelBtn(){
        if AuthService.instance.isLoggedIn{
            let createCh = CreateChannelVC()
            createCh.modalPresentationStyle = .custom
            viewController?.present(createCh, animated: true, completion: nil)
        }
    }
    
    // MARK: - getChannelSocketListener()
    func getChannelSocketListener() {
        SocketService.instance.getChannel { success, error in
            if success{
                self.dataAdded.property = true
            }
            else{
                self.dataAdded.property = false
            }
        }
    }
    // MARK: - getMessageSocketListener()
    func getMessageSocketListener(){
        SocketService.instance.getMessageFromSocketListener { newMessage in
            if newMessage.channelId != MessageService.instance.channelSelected?.id && AuthService.instance.isLoggedIn{
                MessageService.instance.unreadChannel.append(newMessage.channelId)
                self.viewController?.tableView.reloadData()
            }
        }
    }
}

extension ChannelViewModel: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = viewController?.tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelCell {
            let channel = MessageService.instance.channels[indexPath.row]
            //cell.configureCell(channel: channel)
            cell.viewModel.setCellData(channel: channel)
            return cell
        }
        return UITableViewCell()
    }
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return MessageService.instance.channels.count
    }
    
    // MARK: - numberOfSections(in tableView: UITableView)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // MARK: - didSelectRowAt
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let channel = MessageService.instance.channels[indexPath.row]
        MessageService.instance.channelSelected = channel
        
        if MessageService.instance.unreadChannel.count > 0 {
            MessageService.instance.unreadChannel = MessageService.instance.unreadChannel.filter{$0 != channel.id}
        }
        
        let index = IndexPath(row: indexPath.row, section: 0)
        viewController?.tableView.reloadRows(at: [index], with: .none)
        viewController?.tableView.selectRow(at: index, animated: false, scrollPosition: .none)
        
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELLECTED, object: nil)
        self.viewController?.revealViewController().revealToggle(animated: true)
    }
}
