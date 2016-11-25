//
//  AppConfig.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class AppConst {
    
    class Color {
        static let C0 = UIColor(RGBHex:0x131f32)
        static let CR = UIColor(RGBHex:0xb82525)
        static let C1 = UIColor.blackColor()
        static let C2 = UIColor(RGBHex:0x666666)
        static let C3 = UIColor(RGBHex:0x999999)
        static let C4 = UIColor(RGBHex:0xaaaaaa)
        static let C5 = UIColor(RGBHex:0xe2e2e2)
        static let C6 = UIColor(RGBHex:0xf2f2f2)
    };
     class SystemFont {
        static let S1 = UIFont.systemFontOfSize(18)
        static let S2 = UIFont.systemFontOfSize(15)
        static let S3 = UIFont.systemFontOfSize(13)
        static let S4 = UIFont.systemFontOfSize(12)
        static let S5 = UIFont.systemFontOfSize(10)
    };
    class Network {
        #if true //是否测试环境
        static let TcpServerIP:String = "61.147.114.78";
        static let TcpServerPort:UInt16 = 10001;
        static let TttpHostUrl:String = "http://61.147.114.78";
        #else
        static let TcpServerIP:String = "61.147.114.78";
        static let TcpServerPort:UInt16 = 10001;
        static let HttpHostUrl:String = "http://61.147.114.78";
        #endif
        static let TimeoutSec:UInt16 = 10
    }
    class Text {
        static let PhoneFormatErr = "请输入正确的手机号"
        static let VerifyCodeErr  = "请输入正确的验证码"
        static let SMSVerifyCodeErr  = "获取验证码失败"
        static let PasswordTwoErr = "两次密码不一致"
        static let ReSMSVerifyCode = "重新获取"
        static let ErrorDomain = "com.yundian.viossvc"
        static let PhoneFormat = "^1[3|4|5|7|8][0-9]\\d{8}$"
        static let RegisterPhoneError = "输入的手机号已注册"
    }
    static let DefaultPageSize = 15
    
    enum Action:UInt {
        case CallPhone = 10001
    }
}
