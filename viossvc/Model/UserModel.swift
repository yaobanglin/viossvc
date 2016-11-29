//
//  UserModel.swift
//  viossvc
//
//  Created by yaowang on 2016/11/21.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import XCGLogger

enum UserType: Int {
    case Tourist = 1
    case Leader = 2
}

class LoginModel: BaseModel {
    var phone_num: String?
    var passwd: String?
    var user_type: Int = UserType.Leader.rawValue
}

class UserModel : BaseModel {
    var uid: Int = 0
    var head_url: String?
}

class UserInfoModel: UserModel {
    var address: String?
    var cash_lv: Int = 0
    var credit_lv: Int = 0
    var gender: Int = 0
    var has_recharged: Int = 0
    
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var nickname: String?
    var phone_num: String?
    var praise_lv: Int = 0
    var register_status: Int = 0
    var user_cash_: Int = 0
}

class SMSVerifyModel: BaseModel {

    enum SMSType: Int {
        case Register = 0
        case Login = 1
    }

    var verify_type: Int = 0;
    var phone_num: String?
    init(phone: String, type: SMSVerifyModel.SMSType = .Login) {
        self.verify_type = type.rawValue
        self.phone_num = phone
    }
}

class SMSVerifyRetModel: BaseModel {
    var timestamp: Int64 = 0
    var token: String!
    
}


class RegisterModel: SMSVerifyRetModel {
    var verify_code: Int = 0
    var phone_num: String!
    var passwd: String!
    var user_type: Int = UserType.Leader.rawValue;
    var smsType:SMSVerifyModel.SMSType = .Register
}

class AuthHeaderModel: BaseModel {
    var uid: Int = 0
    var head_: String?
}

class NotifyUserInfoModel: UserInfoModel {

}

class UserBankCardsModel: BaseModel {
    
}

class DrawCashModel: BaseModel {
    
}

class BankCardModel: BaseModel {
    
}
