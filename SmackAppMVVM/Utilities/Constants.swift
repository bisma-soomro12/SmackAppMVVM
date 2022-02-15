//
//  Constants.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 31/01/2022.
//

import Foundation
import Alamofire

typealias completionHandler = (_ success: Bool, _ error: Error?) -> ()
typealias completionBlock = ([Channels]) -> ()

// Segues

let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unWindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// user defaults

let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL_KEY = "userEmail"

// URL constansts

let LOCAL_BASE_URL = "http://localhost:3005/v1/"

let URL_LOGIN = "\(LOCAL_BASE_URL)account/login"
let URL_REGISTER = "\(LOCAL_BASE_URL)account/register"
let URL_USER_ADD = "\(LOCAL_BASE_URL)user/add"
let URL_USER_BY_EMAIL = "\(LOCAL_BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(LOCAL_BASE_URL)channel/"
let URL_GET_MESSAGE = "\(LOCAL_BASE_URL)message/byChannel/"

// headers

let HEADER : HTTPHeaders = [
    "Content-Type"  : "application/json; charset=utf-8"
]
let BEARER_HEADER : HTTPHeaders = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type"  : "application/json; charset=utf-8"
]

// Notifications
let NOTIFY_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("channelsLoaded")
let NOTIF_CHANNEL_SELLECTED = Notification.Name("channelSelected")
