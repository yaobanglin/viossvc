//
//  SocketUserAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/22.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class UserSocketAPI:BaseSocketAPI,UserAPI {
    
    
    func login(model: LoginModel, complete: CompleteBlock, error: ErrorBlock) {
        let packet = SocketDataPacket(opcode: .Login, model: model)
        startModelRequest(packet,modelClass:UserInfoModel.classForCoder(), complete: complete, error: error);
    }

    func smsVerify(type:SMSVerifyModel.SMSType,phone:String,complete:CompleteBlock,error:ErrorBlock) {
        let packet = SocketDataPacket(opcode: .SMSVerify, model: SMSVerifyModel(phone:phone,type:type))
        startModelRequest(packet, modelClass: SMSVerifyRetModel.classForCoder(), complete: complete, error: error)
    }
    
    func register(model:RegisterModel,complete:CompleteBlock,error:ErrorBlock) {
        let packet = SocketDataPacket(opcode: .Register, model: model)
        startResultIntRequest(packet, complete: complete, error: error)
    }
    
    func nodifyPasswrod(uid:Int,oldPassword:String,newPasword:String,complete:CompleteBlock,error:ErrorBlock){
        let dict:[String : AnyObject] = ["uid_" : uid , "old_passwd_" : oldPassword, "new_passwd_" : newPasword];
        startRequest(SocketDataPacket(opcode: .NodifyPasswrod,dict: dict), complete: complete, error: error)
    }
}
