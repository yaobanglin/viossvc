//
//  SockOpcode.swift
//  viossvc
//
//  Created by yaowang on 2016/11/22.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class SocketConst: NSObject {
    enum OPCode:UInt16 {
        // 心跳包
        case Heart = 1000
        // 请求登录
        case Login = 1001
        //验证手机短信
        case SMSVerify = 1019
        //注册
        case Register = 1021
        //重置密码
        case NodifyPasswrod = 1011
        //修改用户信息
        case NodifyUserInfo = 1023
        //获取图片token
        case GetImageToken = 1047
        //获取用户余额
        case UserCash = 1067
        //认证用户头像
        case AuthUserHeader = 0000
        //获取用户的银行卡信息
        case UserBankCards = 1097
        //校验提现密码
        case CheckDrawCashPassword = 0002
        //提现
        case DrawCash = 0003
        //提现详情
        case DrawCashDetail = 0004
        //设置默认银行卡
        case DefaultBankCard = 1099
        //添加新的银行卡
        case NewBankCard = 1095
        //获取身份认证进度
        case AuthStatus = 1057
        //上传身份认证信息
        case AuthUser = 1055
        
        case SkillShareList = 1071
        
        case SkillShareDetail = 1073
        
        case SkillShareComment = 1075
        
        case SkillShareEnroll = 1077
        
        case TourShareType = 1059
        
        case TourShareList = 1061
        
        case TourShareDetail = 1065
        
    }
    enum type:UInt8 {
        case Error = 0
        case User = 1
        case Chat = 2
    }
    
    class Key {
        static let last_id = "last_id_"
        static let count = "count_"
        static let share_id = "share_id_"
        static let page_type = "page_type_"
        static let uid = "uid_"
    }
}
