    //
    //  AuthService.swift
    //  SmackAppMVVM
    //
    //  Created by Bisma Soomro on 02/02/2022.
    //

    import Foundation
    import Alamofire
    import Network
    import SwiftyJSON
    import Alamofire

    class AuthService{
        
        static let instance = AuthService()
        
        // creating user defaults
        let defaults = UserDefaults.standard
        var isLoggedIn: Bool{
            get{
                return defaults.bool(forKey: LOGGED_IN_KEY)
            }
            set{
                defaults.set(newValue, forKey: LOGGED_IN_KEY)
            }
        }
        
        var authToken: String {
            get{
                return defaults.value(forKey: TOKEN_KEY) as! String
            }
            set{
                defaults.set(newValue, forKey: TOKEN_KEY)
            }
        }
        
        var userEmail: String {
            get{
                return defaults.value(forKey: USER_EMAIL_KEY) as! String
            }
            set{
                defaults.set(newValue, forKey: USER_EMAIL_KEY)
            }
        }
        
        //MARK: - registerUser()
        func registerUser(email: String, password: String, completion: @escaping completionHandler){
            let lowercasedEmail = email.lowercased()
            let body: [String: Any] = [
                "email" : lowercasedEmail,
                "password" : password
            ]
            AF.request(URL_REGISTER, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).responseString { response in
                if response.error == nil{
                    completion(true, nil)
                    
                } else {
                    completion(false, response.error)
                    debugPrint(response.error as Any)
                }
            }
        }
        //MARK: - loginUser()
        func loginUser(email: String, password: String, completion: @escaping completionHandler){
            let loweredcaseEmail = email.lowercased()
            
            let body : [String: Any] = [
                "email" : loweredcaseEmail,
                "password" : password
            ]
            
            AF.request(URL_LOGIN, method: .post, parameters: body, encoding: JSONEncoding.default, headers: HEADER).response(completionHandler: { response in
                if response.error == nil {
                    guard let data = response.data else {return}
                    let json = try! JSON(data: data)
                    self.userEmail = json["user"].stringValue
                    self.authToken = json["token"].stringValue
                    if self.authToken == ""{
                        self.isLoggedIn = false
                        completion(false, nil)
                    } else{
                        self.isLoggedIn = true
                        completion(true, nil)
                    }
                    
                } else {
                    completion(false, response.error)
                }
            })

            
        }
        
        //MARK: - createUser()
        func creatUser(name: String, email: String, avatarName: String, avatarColor: String, completion: @escaping completionHandler){
            let loweredcaseEmail = email.lowercased()
            
            let body : [String : Any] = [
                "name" : name,
                "email" : loweredcaseEmail,
                "avatarName" : avatarName,
                "avatarColor" : avatarColor
            ]
            AF.request(URL_USER_ADD, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).response { response in
                if response.error == nil{
                    guard let data = response.data else { return }
                    self.setUpUserInfo(data: data)
                    completion(true, nil)
                }
                else {
                    completion(false, response.error)
                }
            }
        }
        
        //MARK: - findUserByEmail()
        func findUserByEmail(completion: @escaping completionHandler) {
            AF.request("\(URL_USER_BY_EMAIL)\(userEmail)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).response { response in
                if response.error == nil {
                    guard let data = response.data else { return }
                    
                    MessageService.instance.findAllChannels { success, error  in
    
                        self.setUpUserInfo(data: data)
                        completion(true, nil)
                    }
                } else {
                    completion(false, response.error)
                }
            }
        }

        //MARK: - setupUserInfo()
        func setUpUserInfo(data: Data){
            let json = try! JSON(data: data)
            let id = json["_id"].stringValue
            let avatarColor = json["avatarColor"].stringValue
            let avatarName = json["avatarName"].stringValue
            let email = json["email"].stringValue
            let name = json["name"].stringValue
            UserDataService.instance.setUserData(id: id, avatarName: avatarName, avatarColor: avatarColor, email: email, name: name)
            
        }
    }
