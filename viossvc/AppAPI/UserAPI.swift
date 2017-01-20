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
    //登录
    func login(model:LoginModel,complete:CompleteBlock,error:ErrorBlock)
    //获取短信验证码
    func smsVerify(type:SMSVerifyModel.SMSType,phone:String,complete:CompleteBlock,error:ErrorBlock)
    //验证短信验证码
    func verifyCode(paramDic: Dictionary<String, AnyObject>, complete:CompleteBlock,error:ErrorBlock)
    
    func checkInviteCode(phoneNumber:String,inviteCode:String,complete:CompleteBlock,error:ErrorBlock)
    
    //注册
    func register(model:RegisterModel,complete:CompleteBlock,error:ErrorBlock)
    //修改登录密码
    func nodifyPasswrod(uid:Int,oldPassword:String,newPasword:String,complete:CompleteBlock,error:ErrorBlock)
    func logout(uid:Int)
    //获取用户余额
    func userCash(uid:Int, complete:CompleteBlock, error:ErrorBlock)
    //认证用户头像
    func authHeaderUrl(uid: Int, head_url_: String, complete: CompleteBlock, error: ErrorBlock)
    //修改用户信息
    func notifyUsrInfo(model: NotifyUserInfoModel, complete: CompleteBlock, error: ErrorBlock)
    //获取用户的银行卡信息
    func bankCards(model: BankCardModel, complete: CompleteBlock, error: ErrorBlock)
    //校验提现密码//登录密码
    func checkDrawCashPassword(uid: Int, password: String, type: Int, complete: CompleteBlock,error: ErrorBlock)
    //提现
    func drawCash(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock)
    //提现详情
    func drawCashDetail(model:DrawCashModel, complete: CompleteBlock, error: ErrorBlock)
    //设置用户默认的银行卡
    func defaultBanKCard(account: String, complete: CompleteBlock, error: ErrorBlock)
    //添加新的银行卡
    func newBankCard(data:Dictionary<String, AnyObject>, complete: CompleteBlock, error: ErrorBlock)
    //查询用户认证状态
    func anthStatus(uid: Int, complete: CompleteBlock, error: ErrorBlock)
    //上传身份认证信息
    func authUser(uid: Int, frontPic: String, backPic: String, complete: CompleteBlock, error: ErrorBlock)
    //设置/修改提现密码
    func drawcashPassword(model: DrawCashPasswordModel, complete: CompleteBlock, error: ErrorBlock)
    //提现记录
    func drawCashRecord(model: DrawCashModel, complete: CompleteBlock, error: ErrorBlock)
    //请求照片墙
    func photoWallRequest(model: PhotoWallRequestModel, complete: CompleteBlock, error: ErrorBlock)
    //请求上传照片
    func uploadPhoto2Wall(data: [String: AnyObject], complete: CompleteBlock, error: ErrorBlock)
    //V领队服务
    func serviceList(complete: CompleteBlock, error: ErrorBlock)
    //更新V领队服务
    func updateServiceList(model: UpdateServerModel, complete: CompleteBlock, error: ErrorBlock)
    //操作技能标签
    func getOrModfyUserSkills(getOrModfy:Int,skills:String,complete: CompleteBlock, error: ErrorBlock)
    //获取用户信息
    func getUserInfos(uids:[String],complete: CompleteBlock, error: ErrorBlock?)
    //
    func getUserInfo(uid:Int,complete: CompleteBlock, error: ErrorBlock?)
    func updateDeviceToken(uid:Int,deviceToken:String,complete: CompleteBlock?, error: ErrorBlock?)
}