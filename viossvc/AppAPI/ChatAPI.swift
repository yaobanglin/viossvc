//
//  ChatAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol ChatAPI {
    /**
     发送消息
     
     - parameter chatModel: 消息model
     - parameter complete:  发送成功回调
     - parameter error:     发送失败回调
     */
    func sendMsg(chatModel:ChatMsgModel,complete:CompleteBlock,error:ErrorBlock)
    
    /**
     获取离线消息列表
     
     - parameter uid:      用户id
     - parameter complete: 成功回调
     - parameter error:    失败回调
     */
    func offlineMsgList(uid:Int,complete:CompleteBlock,error:ErrorBlock)
    
    /**
     设置接收消息回调
     
     - parameter complete: 接收消息回调
     */
    func setReceiveMsgBlock(complete:CompleteBlock)
}
