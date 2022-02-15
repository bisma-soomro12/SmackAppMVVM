//
//  channelCellViewModel.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 10/02/2022.
//

import Foundation
import UIKit

class channelCellViewModel{
    var cell: ChannelCell?
    var channelTitle = Observable<String>()
    
    // MARK: - setCellInstance(cell: ChannelCell)
    func setCellInstance(cell: ChannelCell){
        self.cell = cell
    }
    // MARK: - cellSelection(isSelected: Bool)
    func cellSelection(isSelected: Bool){
        if isSelected{
            cell?.layer.backgroundColor = UIColor(white: 1, alpha: 0.2).cgColor
        }
        else {
            cell?.layer.backgroundColor = UIColor.clear.cgColor
        }
    }
    // MARK: - setCellData(channel: Channels)
    func setCellData(channel: Channels){
        let title = channel.channelTitle ?? ""
        //cell?.channelNameLbl.text = "#\(title)"
        channelTitle.property = "#\(title)"
        cell?.channelNameLbl.font = UIFont(name: "HelveticaNeue-Regular", size: 15)
        for id in MessageService.instance.unreadChannel{
            if id == channel.id{
                cell?.channelNameLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 22
                )
            }
        }
    }
}
