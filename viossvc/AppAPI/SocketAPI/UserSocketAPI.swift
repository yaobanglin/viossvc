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
    
    func logout(uid:Int) {
        
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
    func authHeaderUrl(uid: Int, head_url_: String, complete: CompleteBlock, error: ErrorBlock){
        let dict:[String : AnyObject] = [SocketConst.Key.uid:uid, "head_url_":head_url_]
        let packet = SocketDataPacket(opcode: .AuthUserHeader, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //修改用户信息
    func notifyUsrInfo(model: NotifyUserInfoModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .NodifyUserInfo, model: model)
        startModelRequest(packet, modelClass: NotifyUserInfoModel.classForCoder(), complete: complete, error: error)
    }
    
    //获取用户的银行卡信息
    func bankCards(model: BankCardModel, complete: CompleteBlock, error: ErrorBlock){
        
        let pack = SocketDataPacket(opcode: .UserBankCards, dict: ["uid_": CurrentUserHelper.shared.userInfo.uid])
        startModelsRequest(pack, listName: "bank_card_list_", modelClass: BankCardModel.classForCoder(), complete: complete, error: error)
        
    }
    
    //校验提现密码
    func checkDrawCashPassword(uid: Int, password: String, type: Int, complete: CompleteBlock,error: ErrorBlock){
        let dict:[String : AnyObject] = [SocketConst.Key.uid:uid, "passwd_":password, "passwd_type_":type]
        let packet = SocketDataPacket(opcode: .CheckDrawCashPassword, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //提现
    func drawCash(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .DrawCash, model: model)
        startModelRequest(packet, modelClass: DrawCashModel.classForCoder(), complete: complete, error: error)
    }
    //提现详情
    func drawCashDetail(model:DrawCashModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .DrawCashRecord, model: model)
        startModelRequest(packet, modelClass: DrawCashModel.classForCoder(), complete: complete, error: error)
    }
    
    //提现记录
    func drawCashRecord(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock) {
        let packet = SocketDataPacket(opcode: .DrawCashRecord, model: model)
        startModelRequest(packet, modelClass: DrawCashModel.classForCoder(), complete: complete, error: error)
    }
    
    //设置用户默认的银行卡
    func defaultBanKCard(account: String, complete: CompleteBlock, error: ErrorBlock){
        let dict:[String : AnyObject] = ["uid_":CurrentUserHelper.shared.userInfo.uid,
                                         "account_":account]
        let packet = SocketDataPacket(opcode: .DefaultBankCard, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //添加新的银行卡
    func newBankCard(data:Dictionary<String, AnyObject>, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .NewBankCard, dict: data)
        startModelRequest(packet, modelClass: BankCardModel.classForCoder(), complete: complete, error: error)
    }
    
    //查询用户认证状态
    func anthStatus(uid: Int, complete: CompleteBlock, error: ErrorBlock){
        let dict:[String : AnyObject] = [SocketConst.Key.uid:uid]
        let packet = SocketDataPacket(opcode: .AuthStatus, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //上传身份认证信息
    func authUser(uid: Int, frontPic: String, backPic: String, complete: CompleteBlock, error: ErrorBlock) {
        let dict:[String : AnyObject] = [SocketConst.Key.uid:uid,
                                         "front_pic_":frontPic,
                                         "back_pic_":backPic]
        
        let packet = SocketDataPacket(opcode: .AuthUser, dict: dict)
        startRequest(packet, complete: complete, error: error)
    }
    
    //设置/修改提现密码
    func drawcashPassword(model: DrawCashPasswordModel, complete: CompleteBlock, error: ErrorBlock){
        let packet = SocketDataPacket(opcode: .DrawCashPassword, model: model)
        startModelRequest(packet, modelClass: DrawCashPasswordModel.classForCoder(), complete: complete, error: error)
    }
    
    //V领队服务列表
    func serviceList(complete: CompleteBlock, error: ErrorBlock) {
        let pack = SocketDataPacket(opcode: .ServiceList, dict: ["uid_": CurrentUserHelper.shared.userInfo.uid])
        startModelsRequest(pack, listName: "service_list_", modelClass: UserServerModel.classForCoder(), complete: complete, error: error)
    }
    /**
     操作技能标签
     
     - parameter getOrModfy: 0 获取用户技能 1 修改
     - parameter skills:     技能标签id 集合
     - parameter complete:   完成回调
     - parameter error:      失败错误
     */
    func getOrModfyUserSkills(getOrModfy:Int,skills:String,complete: CompleteBlock, error: ErrorBlock) {
        
        let dict:[String : AnyObject] = [SocketConst.Key.change_type : getOrModfy,
                                         SocketConst.Key.skills : skills,
                                         SocketConst.Key.uid : CurrentUserHelper.shared.userInfo.uid]
        let packet = SocketDataPacket(opcode: .HandleSkills, dict: dict)
        startRequest(packet, complete: complete, error: error)
        
    }
}
