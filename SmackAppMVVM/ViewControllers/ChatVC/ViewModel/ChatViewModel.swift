//
//  ChatViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 07/02/2022.
//

import Foundation
class ChatViewModel: NSObject{
    
    var viewController: ChatVC?
    var isTyping = false
    var userDataDidChanged = Observable<Bool>()
    
    // MARK: setupViewController
    func setupViewController(view: ChatVC){
        self.viewController = view
    }
    
    // MARK: - setupTableView()
    func setupTableView(){
        viewController?.tableView.delegate = self
        viewController?.tableView.dataSource = self
        
        viewController?.tableView.estimatedRowHeight = 80
        viewController?.tableView.rowHeight = UITableView.automaticDimension
        
        viewController?.sendBtn.isHidden = true
        
    }
    
    // MARK: - settingRevealViewController()
    func settingRevealViewController(){
        viewController?.menuBtn.addTarget(viewController?.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        viewController?.view.addGestureRecognizer((viewController?.revealViewController().panGestureRecognizer())!)
        viewController?.view.addGestureRecognizer((viewController?.revealViewController().tapGestureRecognizer())!)
        viewController?.view.bindToKeyboard()
    }
    
    // MARK: - updatingChannel()
    func updatingChannel(){
        let channelName = MessageService.instance.channelSelected?.channelTitle ?? ""
        viewController?.ChannelNameLbl.text = "#\(channelName)"
        getMessageFromChannel()
    }
    
    // MARK: - sendBtn()
    func sendBtn(){
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.channelSelected?.id else { return }
            guard let msg = viewController?.messageBoxTxt.text else { return }
            SocketService.instance.addMessage(messageBody: msg, userId: UserDataService.instance.id, channelId: channelId) { success, error in
                if success {
                    self.viewController?.messageBoxTxt.text = ""
                    self.viewController?.messageBoxTxt.resignFirstResponder()
                    self.viewController?.sendBtn.isHidden = true
                    self.viewController?.typingLbl.text = ""
                    SocketService.instance.socket?.emit("stopType", UserDataService.instance.name, channelId)
                }
            }
        }
    }
    
    // MARK: - getMessageFromChannel()
    func getMessageFromChannel(){
        guard let channelId = MessageService.instance.channelSelected?.id else { return }
        MessageService.instance.findAllMsgFromChannel(channelId: channelId) { success, error in
            if success{
            
                self.viewController?.tableView.reloadData()
//                if MessageService.instance.messages.count > 0 {
//                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
//                    self.viewController?.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
//                }
            }
            else{
                
                print(error ?? "")
            }
        }
    }
    
    // MARK: - getMessagesFromSocket()()
    func getMessagesFromSocket(){
        SocketService.instance.getMessageFromSocketListener { newMessage in
            if newMessage.channelId == MessageService.instance.channelSelected?.id && AuthService.instance.isLoggedIn{
                MessageService.instance.messages.append(newMessage)
                self.viewController?.tableView.reloadData()

                if MessageService.instance.messages.count > 0 {
                    let endIndex = IndexPath(row: MessageService.instance.messages.count - 1, section: 0)
                    self.viewController?.tableView.scrollToRow(at: endIndex, at: .bottom, animated: false)
                }
            }
        }
    }
    
    // MARK: - messageBoxEditng()
    func messageBoxEditng(){
        guard let channelId = MessageService.instance.channelSelected?.id else { return }
        self.viewController?.sendBtn.isHidden = true
        
        if viewController?.messageBoxTxt.text == ""{
            isTyping = false
            viewController?.sendBtn.isHidden = true
            SocketService.instance.socket?.emit("stopType", UserDataService.instance.name, channelId)
        }
        else{
            viewController?.sendBtn.isHidden = false
            if isTyping == false{
                SocketService.instance.socket?.emit("startType", UserDataService.instance.name, channelId)
            }
            isTyping = true
        }
    }
    
    // MARK: - getOnlineMessage()
    func getOnlineMessage(){
        MessageService.instance.findAllChannels { success, error in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.channelSelected = MessageService.instance.channels[0]
                    self.updatingChannel()
                }
                else {
                    self.viewController?.ChannelNameLbl.text = "No channels yet"
                }
            }
        }
    }
    
    // MARK: - typingUsers()
    func typingUsers(){
        SocketService.instance.getTypingUsers { typingUsers in
            guard let channelId = MessageService.instance.channelSelected?.id else { return }
            //print(channelId)
            var names = ""
            var numOfTypers = 0
            
            for(typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId{
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numOfTypers += 1
                }
            }
            
            if numOfTypers > 0 && AuthService.instance.isLoggedIn == true{
                var verb = "is"
                if numOfTypers > 1 {
                    verb = "are"
                }
                self.viewController?.typingLbl.text = "\(names) \(verb) typing a message"
            }
            else{
                self.viewController?.typingLbl.text = ""
            }
        }
    }
    
    // MARK: - findUserByEmail()
    func findUserByEmail(){
        if AuthService.instance.isLoggedIn{
            AuthService.instance.findUserByEmail { success, error in
                if success {
                    self.userDataDidChanged.property = true
                }
                else{
                    self.userDataDidChanged.property = false
                }

            }
        }
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

extension ChatViewModel: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - numberOfRowsInSection
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    // MARK: - cellForRowAt
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = viewController?.tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageCell{
            let message = MessageService.instance.messages[indexPath.row]
            cell.viewModel.setCellData(message: message)
            return cell
        }
        else{
            return UITableViewCell()
        }
    }
    
    // MARK: - numberOfSections(in tableView: UITableView)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
