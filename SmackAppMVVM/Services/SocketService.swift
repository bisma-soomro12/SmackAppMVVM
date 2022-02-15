//
//  SocketService.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import Foundation
import SocketIO
class SocketService: NSObject{
    static let instance = SocketService()
    
    var msocket = SocketManager(socketURL: URL(string: LOCAL_BASE_URL)!, config: [.log(true), .compress])
    var socket: SocketIOClient? = nil
    
    override init() {
        super.init()
        socket = msocket.defaultSocket
        self.socket?.on(clientEvent: .connect, callback: { data, ack in
            print("Socket Connected")
        })
    }
    
    func establishConnection(){
        self.socket?.connect()
        
    }
    func closedConnection(){
        self.socket?.disconnect()
    }
    
    // MARK: - addChannel
    func addChannel(channelName: String,ChanelDesc: String, completion: @escaping completionHandler){
        if socket?.status == .connected {
            self.socket?.emit("newChannel", channelName, ChanelDesc)
            completion(true, nil)
        }
        else{
            print("Socket not Connected")
        }
    }
    
    // MARK: - getChannel()
    func getChannel(completion: @escaping completionHandler){
        self.socket?.on("channelCreated", callback: { dataArr, ack in
            guard let chName = dataArr[0] as? String else { return }
            guard let chDesc = dataArr[1] as? String else {return }
            guard let chId = dataArr[2] as? String else { return}
            let newChannel = Channels(channelTitle: chName, description: chDesc, id: chId)
            MessageService.instance.channels.append(newChannel)
            completion(true,nil)
        })
    }
    
    // MARK: - addMessage()
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping completionHandler){
        
        let user = UserDataService.instance
        socket?.emit("newMessage", messageBody , userId, channelId, user.name, user.avatarName, user.avatarColor)
        completion(true, nil)
    }
    
    // MARK: - getMessageFromSocketListener()
    func getMessageFromSocketListener(completion: @escaping (_ newMessage: Message) -> Void){
        socket?.on("messageCreated", callback: { msgArray, ack in
            guard let msgBody = msgArray[0] as? String else { return}
            guard let channelId = msgArray[2] as? String else { return }
            guard let userName = msgArray[3] as? String else { return }
            guard let userAvatar = msgArray[4] as? String else { return }
            guard let userAvatarColor = msgArray[5] as? String else { return }
            guard let id = msgArray[6] as? String else { return}
            guard let timeStamp = msgArray[7] as? String else { return }
            
            let newMsg = Message(message: msgBody, userName: userName, userAvatar: userAvatar, channelId: channelId, avatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
            completion(newMsg)
        })
    }
    
    // MARK: - getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void)
    func getTypingUsers(_ completionHandler: @escaping (_ typingUsers: [String: String]) -> Void){
        
        socket?.on("userTypingUpdate") { dataArray, ack in
            guard let typingUsers = dataArray[0] as? [String: String] else { return }
            completionHandler(typingUsers)
        }
    }
}
