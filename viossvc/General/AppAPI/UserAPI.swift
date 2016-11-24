//
//  UserAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/22.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

typealias CompleteBlock = (AnyObject?) ->()
typealias ErrorBlock = (NSError) ->()


protocol UserAPI {
    func login(model:LoginModel,complete:CompleteBlock,error:ErrorBlock)
    func smsVerify(type:SMSVerifyModel.SMSType,phone:String,complete:CompleteBlock,error:ErrorBlock)
    func register(model:RegisterModel,complete:CompleteBlock,error:ErrorBlock)
    func nodifyPasswrod(uid:Int,oldPassword:String,newPasword:String,complete:CompleteBlock,error:ErrorBlock)
}