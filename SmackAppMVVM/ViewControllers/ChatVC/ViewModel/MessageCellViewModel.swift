//
//  MessageCellViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 10/02/2022.
//

import Foundation

class MessageCellViewModel{
    
    var cell : MessageCell?
    var imageName = Observable<String>()
    var userName = Observable<String>()
    var message = Observable<String>()
    var timeStamp = Observable<String>()
    var background = Observable<String>()
    
    // MARK: - setCellInstance(cell: MessageCell)
    func setCellInstance(cell: MessageCell){
        self.cell = cell
    }
    
    // MARK: - setCellData(message: Message)
    func setCellData(message: Message){
        
        self.userName.property = message.userName
        self.imageName.property = message.userAvatar
        self.message.property = message.message
        self.background.property = message.avatarColor
        
        let formatter = RelativeDateTimeFormatter()
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d h:mm a"
        
        guard var isoDate = message.timeStamp as? String else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = isoDate.substring(to: end)
        
        let isoFormtter = ISO8601DateFormatter()
        let chatDate = isoFormtter.date(from: isoDate.appending("Z"))
        
        
        if let finalDate = chatDate {
            let secondsAgo = Int(Date().timeIntervalSince(finalDate
                                                         ))
            let minute = 60
            let hour = 60 * minute
            let day = 24 * hour
            let week = 7 * day
            
            if secondsAgo < minute {
                self.timeStamp.property = "Just Now"
              }
            else if secondsAgo < hour {
                self.timeStamp.property = "\(secondsAgo / minute) minutes ago"
              }
            else if secondsAgo < day {
                self.timeStamp.property = "\(secondsAgo / hour) hours ago"
              }
            else if secondsAgo < week {
                let yesterday = secondsAgo / day
                if yesterday == 1 {
                    self.timeStamp.property = "Yesterday"
                }
                let finalDate = newFormatter.string(from: finalDate)
                self.timeStamp.property = finalDate
             }
            else {
                let finalDate = newFormatter.string(from: finalDate)
                self.timeStamp.property = finalDate
            }
            }
        }
    
    }

