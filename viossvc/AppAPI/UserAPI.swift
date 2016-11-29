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
    //获取用户余额
    func userCash(uid:Int, complete:CompleteBlock, error:ErrorBlock)
    //认证用户头像
    func authHeaderUrl(uid: Int, head_url_: String, complete: CompleteBlock, error: ErrorBlock)
    //修改用户信息
    func notifyUsrInfo(model: NotifyUserInfoModel, complete: CompleteBlock, error: ErrorBlock)
    //获取用户的银行卡信息
    func bankCards(model: UserBankCardsModel, complete: CompleteBlock, error: ErrorBlock)
    //校验提现密码
    func checkDrawCashPassword(uid: Int, password: String,complete: CompleteBlock,error: ErrorBlock)
    //提现
    func drawCash(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock)
    //提现详情
    func drawCashDetail(drawCashId: Int, complete: CompleteBlock, error: ErrorBlock)
    //设置用户默认的银行卡
    func defaultBanKCard(bankCardId: Int, complete: CompleteBlock, error: ErrorBlock)
    //添加新的银行卡
    func newBankCard(model: BankCardModel, complete: CompleteBlock, error: ErrorBlock)
    //查询用户认证状态
    func anthStatus(uid: Int, complete: CompleteBlock, error: ErrorBlock)
    //上传身份认证信息
    func authUser(uid: Int, frontPic: String, backPic: String, complete: CompleteBlock, error: ErrorBlock)
    //设置/修改提现密码
    func drawcashPassword(model: DrawCashPasswordModel, complete: CompleteBlock, error: ErrorBlock)
}