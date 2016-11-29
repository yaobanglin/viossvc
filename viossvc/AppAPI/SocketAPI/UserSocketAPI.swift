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
    
    //修改用户密码
    func nodifyPasswrod(uid:Int,oldPassword:String,newPasword:String,complete:CompleteBlock,error:ErrorBlock){
        let dict:[String : AnyObject] = [SocketConst.Key.uid : uid , "old_passwd_" : oldPassword, "new_passwd_" : newPasword];
        startRequest(SocketDataPacket(opcode: .NodifyPasswrod,dict: dict), complete: complete, error: error)
    }
    
    //获取用户余额
    func userCash(uid:Int,complete:CompleteBlock,error:ErrorBlock){
        let dict: [String : AnyObject] = [SocketConst.Key.uid : uid]
        startRequest(SocketDataPacket(opcode: .UserCash, dict: dict), complete: complete, error: error)
    }
    
    //认证用户头像
    func authHeaderUrl(model: AuthHeaderModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .AuthUserHeader, model: model)
        startModelRequest(packet, modelClass: AuthHeaderModel.classForCoder(), complete: complete, error: error)
    }
    
    //修改用户信息
    func notifyUsrInfo(model: NotifyUserInfoModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .NodifyUserInfo, model: model)
        startModelRequest(packet, modelClass: NotifyUserInfoModel.classForCoder(), complete: complete, error: error)
    }
    
    //获取用户的银行卡信息
    func bankCards(model: UserBankCardsModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .UserBankCards, model: model)
        startModelRequest(packet, modelClass: UserBankCardsModel.classForCoder(), complete: complete, error: error)
    }
    
    //校验提现密码
    func checkDrawCashPassword(uid: Int, password: String,complete: CompleteBlock,error: ErrorBlock){
        let dict:[String : AnyObject] = ["uid":uid, "password":password]
        let packet = SocketDataPacket(opcode: .CheckDrawCashPassword, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //提现
    func drawCash(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .DrawCash, model: model)
        startModelRequest(packet, modelClass: DrawCashModel.classForCoder(), complete: complete, error: error)
    }
    
    //提现详情
    func drawCashDetail(drawCashId: Int, complete: CompleteBlock, error: ErrorBlock){
        let dict:[String : AnyObject] = ["drawCashId":drawCashId]
        let packet = SocketDataPacket(opcode: .DrawCashDetail, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //设置用户默认的银行卡
    func defaultBanKCard(bankCardId: Int, complete: CompleteBlock, error: ErrorBlock){
        let dict:[String : AnyObject] = ["bankCardId":bankCardId]
        let packet = SocketDataPacket(opcode: .DefaultBankCard, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //添加新的银行卡
    func newBankCard(model: BankCardModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .NewBankCard, model: model)
        startModelRequest(packet, modelClass: BankCardModel.classForCoder(), complete: complete, error: error)
    }
}
