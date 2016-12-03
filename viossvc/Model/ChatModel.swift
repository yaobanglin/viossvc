//
//  ChatModel.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatModel: BaseModel {

    var from_uid : Int = 0
    var to_uid : Int = 0
    var msg_time : Int = 0
    var content :String!
    var type:Int = 0
    var isReading : Bool = true
    
    
}

class ChatSessionModel : BaseModel {
    var id: String = ""
    var type:Int = 0
    var title:String!
    var icon:String!
    var noReading:Int = 0
    var isTop:Bool = false
    var isNotDisturb:Bool = false
}
