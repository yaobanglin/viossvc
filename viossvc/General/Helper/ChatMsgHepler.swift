//
//  ChatManageHepler.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import XCGLogger


class ChatMsgHepler: NSObject {
    static let shared = ChatMsgHepler()
    var chatSessionHelper:ChatSessionHelper?
    override init() {
        super.init()
        AppAPIHelper.chatAPI().setReceiveMsgBlock { [weak self] (msg) in
            let chatModel = msg as? ChatMsgModel
            if chatModel != nil {
                AppAPIHelper.userAPI().getUserInfo(chatModel!.from_uid, complete: { [weak self] (userInfo) in
                    if let user = userInfo as? UserInfoModel {
                        if UIApplication.sharedApplication().applicationState == .Background {
                            let localNotify = UILocalNotification()
                            localNotify.fireDate = NSDate().dateByAddingTimeInterval(0.1)
                            localNotify.timeZone = NSTimeZone.defaultTimeZone()
                            localNotify.applicationIconBadgeNumber += 1
                            localNotify.soundName = UILocalNotificationDefaultSoundName
                            if #available(iOS 8.2, *) {
                                localNotify.alertTitle = "优悦助理"
                            } else {
                                // Fallback on earlier versions
                            }
                            localNotify.alertBody =  user.nickname! + " : " + chatModel!.content
                            UIApplication.sharedApplication().scheduleLocalNotification(localNotify)
                        }
                    }
                    }, error: nil)
                self?.didChatMsg(chatModel!)
            }
        }
    }
    
    func sendMsg(toUid:Int,msg:String, type:Int = 0 ) {
        let chatModel = ChatMsgModel()
        chatModel.content = msg
        chatModel.msg_type = type
        chatModel.from_uid = CurrentUserHelper.shared.uid
        chatModel.to_uid = toUid
        chatModel.msg_time = Int(NSDate().timeIntervalSince1970)
        //发送数据
        AppAPIHelper.chatAPI().sendMsg(chatModel, complete: { (obj) in
            
            }, error: { (error) in
            XCGLogger.debug("\(error)")
        })
        didChatMsg(chatModel)
    }
    
    func offlineMsgs() {
        AppAPIHelper.chatAPI().offlineMsgList(CurrentUserHelper.shared.uid, complete: { [weak self] (chatModels) in
                self?.didOfflineMsgsComplete(chatModels as? [ChatMsgModel])
            }, error: { (error) in
                XCGLogger.debug("\(error)")
        })
    }
    
    func didOfflineMsgsComplete(chatModels:[ChatMsgModel]!) {
        //!!!: 离线消息多时要优化
        for chatModel in chatModels {
//            //base64解码
//            chatModel.content = try! decodeBase64Str(chatModel.content)
            didChatMsg(chatModel)
        }
    }
    
    func decodeBase64Str(base64Str:String) throws -> String{
        //解码
        let data = NSData(base64EncodedString: base64Str, options: NSDataBase64DecodingOptions(rawValue: 0))
        let base64Decoded = String(data: data!, encoding: NSUTF8StringEncoding)
        return base64Decoded!
    }

    
    func findHistoryMsg(uid:Int,offset:Int,pageSize:Int) -> [ChatMsgModel] {
        return ChatDataBaseHelper.ChatMsg.findHistoryMsg(uid, offset: offset, pageSize:pageSize)
    }
    

    func didChatMsg(chatMsgModel:ChatMsgModel)  {
        XCGLogger.debug("\(chatMsgModel)")
        ChatDataBaseHelper.ChatMsg.addModel(chatMsgModel)
        chatSessionHelper?.receiveMsg(chatMsgModel)
//        if chatMsgModel.from_uid != CurrentUserHelper.shared.uid {
//            sendMsg(chatMsgModel.from_uid, msg: chatMsgModel.content)
//        }
        
    }
    
    // 将POIInfoModel转成字符串传给服务端
    func modelToString(poiModel:POIInfoModel)-> String {
        
        if poiModel.name == nil {
            poiModel.name = "位置分享"
        }
        if poiModel.detail == nil {
            poiModel.detail = "位置分享"
        }
        return poiModel.name! + "," + poiModel.detail! + "|" + String(poiModel.latiude) + "," + String(poiModel.longtiude)
    }
    
    // 将服务端传回的字符串转成POIInfoModel
    func stringToModel(content:String) -> POIInfoModel {
        
        let model = POIInfoModel()
        
        let infoArray = content.componentsSeparatedByString("|")
        
        let addressString = infoArray.first
        let locationString = infoArray.last
        
        model.name = addressString?.componentsSeparatedByString(",").first
        model.detail = addressString?.componentsSeparatedByString(",").last
        
        guard locationString != nil else {return model}
        
        if locationString?.componentsSeparatedByString(",").first != nil {
            model.latiude = Double((locationString?.componentsSeparatedByString(",").first)!)!
        }
        if locationString?.componentsSeparatedByString(",").last != nil {
            model.longtiude = Double((locationString?.componentsSeparatedByString(",").last)!)!
        }
        
        return model
        
    }
}
