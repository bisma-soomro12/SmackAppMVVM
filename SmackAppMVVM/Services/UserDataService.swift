//
//  UserDataService.swift
//  SmackAppMVVM
//
//  Created by Bisma Soomro on 02/02/2022.
//

import Foundation

class UserDataService{
    static let instance = UserDataService()
    
    public private(set) var id = ""
    public private(set) var avatarName = ""
    public private(set) var avatarColor = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    // MARK: - setUserData
    func setUserData(id: String, avatarName: String, avatarColor: String, email: String, name: String){
        self.id = id
        self.avatarName = avatarName
        self.avatarColor = avatarColor
        self.email = email
        self.name = name
    }
    // MARK: - setupAvatarName
    func setupAvatarName(avatarName: String){
        self.avatarName = avatarName
    }
    
    // MARK: - returnUIColor
    func returnUIColor(components: String) -> UIColor {
        // [0.5882352941176471, 0.6941176470588235, 0.9176470588235294, 1]
        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")
        scanner.charactersToBeSkipped = skipped
        
        var r, g, b, a : NSString?
        
        scanner.scanUpToCharacters(from: comma, into: &r)
        scanner.scanUpToCharacters(from: comma, into: &g)
        scanner.scanUpToCharacters(from: comma, into: &b)
        scanner.scanUpToCharacters(from: comma, into: &a)
        
        let defaultColor = UIColor.lightGray
        
        guard let rUnwrapped = r else { return defaultColor}
        guard let gUnwrapped = g else { return defaultColor}
        guard let bUnwrapped = b else { return defaultColor}
        guard let aUnwrapped = a else { return defaultColor}
        
        let rfloat = CGFloat(rUnwrapped.doubleValue)
        let gfloat = CGFloat(gUnwrapped.doubleValue)
        let bfloat = CGFloat(bUnwrapped.doubleValue)
        let afloat = CGFloat(aUnwrapped.doubleValue)
        
        let newUIColor = UIColor(red: rfloat, green: gfloat, blue: bfloat, alpha: afloat)
        return newUIColor
    }
    
    // MARK: - logoutUser()
    func logoutUser(){
        self.id = ""
        self.name = ""
        self.email = ""
        self.avatarColor = ""
        self.avatarName = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.authToken = ""
        AuthService.instance.userEmail = ""
        MessageService.instance.clearChannels()
        MessageService.instance.clearMessages()
    }
}
