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
    var auth_status_: Int = -1 //-1:未认证, 0:认证中, 1:认证通过, 2:认证失败
    var currentBankCardNumber:String?
    var currentBanckCardName:String?
    var has_passwd_: Int = -1 //-1:未设置提现密码 1:已设置提现密码
    
    var skills:String?
    
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
    var invitation_phone_num:String?
    var user_type: Int = UserType.Leader.rawValue;
    var smsType:SMSVerifyModel.SMSType = .Register
}



class NotifyUserInfoModel: UserInfoModel {

}

class UserBankCardsModel: BaseModel {

    
}

class DrawCashRecordModel: BaseModel {
    var cash: Int = 0
    var account: String?
    var request_time: String?
    var status: Int = 0 //0：等待提现 1：已提现 2：失败
    var withdraw_time: String?
    var fail_reason: String?
    var bank_username: String?
    var bank_name: String?
}

class DrawCashModel: BaseModel {
    var uid: Int = 0
    var account: String?
    var cash: Int = 0
    var size: Int = 20
    var num: Int = 0
    var result: Int = 0
    var withdraw_record: [DrawCashRecordModel] = []
    class func withdraw_recordModleClass() -> AnyClass {
        return DrawCashRecordModel.classForCoder()
    }
}

class BankCardModel: BaseModel {
    var account:String?
    var bank_id = 0
    var bank_username:String?
    var is_default = 0
}

class DrawCashPasswordModel: BaseModel {
    var uid: Int = 0
    var new_passwd: String?
    var old_passwd: String?
    var passwd_type: Int = 0
    var change_type: Int = 0
}

class PhotoModel: BaseModel {
    var photo_url: String?
    var thumbnail_url: String?
    var upload_time: String?
}

class PhotoWallModel: BaseModel {
    var photo_list:[PhotoModel] = []
    class func photo_listModleClass() -> AnyClass {
        return PhotoModel.classForCoder()
    }
}

class PhotoWallRequestModel: BaseModel {
    var uid: Int = 0
    var size: Int = 0
    var num: Int = 0
}
    
class UserServerModel: BaseModel {
    var service_id: Int = 0
    var service_name: String?
    var service_start: Int = 0
    var service_end: Int = 0
    var service_price: Int = 0
    var change_type: Int = 0 //0:删除，1:修改，2:新增
    var service_type: Int = 0
}

class UpdateServerModel:  BaseModel{
    var uid: Int = 0
    var service_list: [UserServerModel] = []
}

