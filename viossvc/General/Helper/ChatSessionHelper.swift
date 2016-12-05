//
//  ChatSessionHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/12/3.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

protocol ChatSessionsProtocol : NSObjectProtocol {
    func updateChatSessions(chatSession:[ChatSessionModel])
}

protocol ChatSessionProtocol : NSObjectProtocol {
    
    func receiveMsg(chatMsgModel:ChatMsgModel)
    
    func sessionUid() ->Int
}


class ChatSessionHelper: NSObject {
    static let shared = ChatSessionHelper()
    private var _chatSessions:[ChatSessionModel] = []
    var chatSessions:[ChatSessionModel] {
        return _chatSessions
    }
    weak var chatSessionsDelegate:ChatSessionsProtocol?
    weak private var currentChatSessionDelegate:ChatSessionProtocol?
    
    
    
    
    func findHistorySession() {
        
        _chatSessions = ChatDataBaseHelper.ChatSession.findHistorySession()
        
//        
//        
//        let chatSession = ChatSessionModel()
//        chatSession.sessionId = 100
//        chatSession.title = "180"
//        chatSession.icon = "http://pic55.nipic.com/file/20141208/19462408_171130083000_2.jpg"
//        chatSession.lastChatMsg = ChatMsgModel()
//        chatSession.lastChatMsg.content = "臊堪堪骚登峰街道看开点机房监控大丰街道空间的肯德基打击打击"
//        chatSession.lastChatMsg.msg_time = Int(NSDate().timeIntervalSince1970)
//        chatSession.lastChatMsg.from_uid = CurrentUserHelper.shared.uid
//        chatSession.lastChatMsg.to_uid = 100
////        ChatDataBaseHelper.ChatSession.addModel(chatSession)
////        ChatDataBaseHelper.ChatMsg.addModel(chatSession.lastChatMsg)
//        _chatSessions.append(chatSession)
        
        chatSessionSort()
    }
    
    func openChatSession(chatSessionDelegate:ChatSessionProtocol) {
        currentChatSessionDelegate = chatSessionDelegate
        let chatSession = findChatSession(currentChatSessionDelegate!.sessionUid())
        chatSession.noReading = 0
        updateChatSession(chatSession)
        updateChatSessionUserInfo(currentChatSessionDelegate!.sessionUid())
    }
    
    func  closeChatSession()  {
        currentChatSessionDelegate = nil
    }
    
    func receiveMsg(chatMsgModel:ChatMsgModel)  {
        var chatSession = findChatSession(chatMsgModel.from_uid)
        if chatSession == nil {
            chatSession = createChatSession(chatMsgModel.from_uid)
            chatSession.lastChatMsg = chatMsgModel
        }
        else if chatSession.lastChatMsg == nil
            || chatSession.lastChatMsg.msg_time < chatMsgModel.msg_time {
            chatSession.lastChatMsg = chatMsgModel
            chatSessionSort()
        }
        
        if currentChatSessionDelegate != nil && currentChatSessionDelegate?.sessionUid() == chatMsgModel.from_uid {
            currentChatSessionDelegate?.receiveMsg(chatMsgModel)
        }
        else if chatMsgModel.to_uid != CurrentUserHelper.shared.uid {
            chatSession.noReading += 1
        }
        
        updateChatSession(chatSession)
    }
    
    
    
    func updateUserInfo(uid:Int,userInfo:UserInfoModel!) {
        if userInfo != nil {
            let chatSession = findChatSession(uid)
            chatSession.title = userInfo.nickname!
            chatSession.icon = userInfo.head_url!
            updateChatSession(chatSession)
        }
    }
    
    
    func updateChatSession(chatSession:ChatSessionModel) {
        ChatDataBaseHelper.ChatSession.updateModel(chatSession)
        chatSessionsDelegate?.updateChatSessions(_chatSessions)
    }
    
    private func chatSessionSort() {
        _chatSessions.sortInPlace({ (chatSession1, chatSession2) -> Bool in
            return chatSession1.lastChatMsg?.msg_time > chatSession2.lastChatMsg?.msg_time
        })
    }
    private func updateChatSessionUserInfo(uid:Int) {
        AppAPIHelper.userAPI().getUserInfo(uid, complete: { [weak self](model) in
            self?.updateUserInfo(uid, userInfo: model as? UserInfoModel)
            }, error: {(error) in})
    }
    
    private func createChatSession(uid:Int) -> ChatSessionModel {
        let chatSession = ChatSessionModel()
        chatSession.sessionId = uid
        _chatSessions.insert(chatSession, atIndex: 0)
        updateChatSessionUserInfo(uid)
        ChatDataBaseHelper.ChatSession.addModel(chatSession)
        return chatSession

    }
    
    private func findChatSession(uid:Int) ->ChatSessionModel! {
        for  chatSession in _chatSessions {
            if chatSession.sessionId == uid {
                return chatSession
            }
        }
        return nil
    }
}
