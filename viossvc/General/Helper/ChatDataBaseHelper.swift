//
//  ChatDataBaseHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/12/5.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatDataBaseHelper: NSObject {
    static let shared = ChatDataBaseHelper()
    func open(uid:Int) {
        
    }
    
    func close() {
        
    }
    
     class ChatSession {
        class func findHistorySession() ->[ChatSessionModel]! {
            return nil
        }
    }
    
    class ChatMsg {
        class func findHistoryMsg(uid:Int,lastId:Int) -> [ChatMsgModel]! {
            return nil
        }
    }
}
