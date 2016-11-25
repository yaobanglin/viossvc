//
//  CurrentUserHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/11/24.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class CurrentUserHelper: NSObject {
    static let shared = CurrentUserHelper()
    private let keychainItem:OEZKeychainItemWrapper = OEZKeychainItemWrapper(identifier: "Account", accessGroup: "")
    private var _userInfo:UserInfoModel!
    private var _userPassword:String!
    var userInfo:UserInfoModel! {
        get {
            return _userInfo
        }
    }
    
    func userLogin(phone:String,password:String,complete:CompleteBlock,error:ErrorBlock) {
        _userPassword = password
        
        let loginModel = LoginModel()
        loginModel.phone_num = phone
        loginModel.passwd = password
        
        AppAPIHelper.userAPI().login(loginModel, complete: {  [weak self] (model) in
                self?.loginComplete(model)
                complete(model)
            }, error:error)
    }
    
    func autoLogin(complete:CompleteBlock,error:ErrorBlock) -> Bool {
        let phone = keychainItem.objectForKey(kSecAttrAccount) as? String
        let password = keychainItem.objectForKey(kSecValueData) as? String
        if !NSString.isEmpty(phone) &&  !NSString.isEmpty(password)  {
            userLogin(phone!, password:password!, complete: complete, error: error)
            return true
        }
        return false
    }
    
    private func loginComplete(model:AnyObject?) {
        self._userInfo = model as? UserInfoModel
        keychainItem.setObject(_userInfo.phone_num, forKey: kSecAttrAccount)
        keychainItem.setObject(_userPassword, forKey: kSecValueData)
    }
    
    
    
    
    
    func nodifyPassword(password:String) {
        keychainItem.setObject(password, forKey: kSecValueData)
    }
}
