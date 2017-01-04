//
//  ChatModel.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

enum ChatMsgType:Int {
    case Text = 0
    case Location = 1
}

class ChatMsgModel: BaseDBModel {

    var from_uid : Int = 0
    var to_uid : Int = 0
    var msg_time : Int = 0
    var msg_type:Int = 0
    var content :String = ""
    var status : Int = 0
    
    
    func formatMsgTime() -> String {
        let date = NSDate(timeIntervalSince1970: Double(msg_time))
        let calendar = NSCalendar.currentCalendar()
        
        let last18hours = (-18*60*60 < date.timeIntervalSinceNow)
        let isToday = calendar.isDateInToday(date)
        let isLast7Days = (calendar.compareDate(NSDate(timeIntervalSinceNow: -7*24*60*60), toDate: date, toUnitGranularity: .Day) == NSComparisonResult.OrderedAscending)
        let dateFormatter = NSDateFormatter()
        if last18hours || isToday {
            dateFormatter.dateStyle = .NoStyle
            dateFormatter.timeStyle = .ShortStyle
        } else if isLast7Days {
            dateFormatter.dateFormat = "EEEE hh:mm"
        } else {
            dateFormatter.dateStyle = .ShortStyle
            dateFormatter.timeStyle = .NoStyle
        }
        return dateFormatter.stringFromDate(date)
    }
    
}

enum ChatSessionType:Int {
    case Chat = 0
}

class ChatSessionModel : BaseDBModel {
    var sessionId: Int = 0
    var type:Int = 0
    var title:String = ""
    var icon:String = ""
    var noReading:Int = 0
    var isTop:Bool = false
    var isNotDisturb:Bool = false
    var lastChatMsg:ChatMsgModel!
    override class func debarsByPropertyKey() -> [AnyObject]! {
        return ["lastChatMsg"]
    }
}
