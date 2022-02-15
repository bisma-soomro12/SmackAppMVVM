//
//  Channels.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 04/02/2022.
//

import Foundation
struct Channels: Equatable{
    public private(set) var channelTitle: String!
    public private(set) var description: String!
    public private(set) var id: String!
    
    static func == (lhs: Channels, rhs: Channels) -> Bool {
        return lhs == rhs
    }
}
