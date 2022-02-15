//
//  MessageService.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService{
    static let instance = MessageService()
    
    var channels = [Channels]()
    var messages = [Message]()
    var unreadChannel = [String]()
    var channelSelected : Channels?
   
    
    // MARK: - findAllChannels()
    func findAllChannels(completion: @escaping completionHandler){
        AF.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).response { response in
            if response.error == nil {
                guard let data = response.data else { return }
                if let json = try? JSON(data: data).array {
                    self.channels.removeAll()
                    for item in json {
                        let name = item["name"].stringValue
                        let channelDescription = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channels(channelTitle: name, description: channelDescription, id: id)
                        self.channels.append(channel)
                    }
                    NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                    // adding notification here
                    completion(true, nil)
                }
            }
            else {
                completion(false, response.error)
            }
        }
        }
    
    // MARK: - findAllMsgFromChannel(channelId: String, completion: @escaping completionHandler)
    func findAllMsgFromChannel(channelId: String, completion: @escaping completionHandler){
        AF.request("\(URL_GET_MESSAGE)\(channelId)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).response { response in
            if response.error == nil {
                self.clearMessages()
                guard let data = response.data else { return }
                if let json = try? JSON(data: data).array{
                    for item  in json{
                        let msgBody = item["messageBody"].stringValue
                        let channelId = item["channelId"].stringValue
                        let id = item["_id"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timeStamp = item["timeStamp"].stringValue
                        
                        let message = Message(message: msgBody, userName: userName, userAvatar: userAvatar, channelId: channelId, avatarColor: userAvatarColor, id: id, timeStamp: timeStamp)
                        self.messages.append(message)
                    }
                    completion(true, nil)
                }
            } else{
                    completion(false, response.error)
                }
            }
    }
    // MARK: - clearChannels()
    func clearChannels() {
        channels.removeAll()
    }
    
    //MARK: - clearMessages()
    func clearMessages(){
        messages.removeAll()
    }
    }
    
    
