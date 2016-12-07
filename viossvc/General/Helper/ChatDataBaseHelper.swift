//
//  ChatDataBaseHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/12/5.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import FMDB
import XCGLogger
class ChatDataBaseHelper: NSObject {
    static let shared = ChatDataBaseHelper()
    
    var database:FMDatabase!
    func open(uid:Int) {
        let dirPaths =
            NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
                                                .UserDomainMask, true)
        let dbName = "\(uid)_chat.db"
        let databasePath = (dirPaths[0] as NSString).stringByAppendingPathComponent(dbName)
        database = FMDatabase(path: databasePath)
        database.open()
        ChatSession.initTable()
        ChatMsg.initTable()
    }
    
    func close() {
        database.close()
    }
    
    func resultSetToModel(resultSet:FMResultSet,modelClass:AnyClass) ->AnyObject! {
        let dict = resultSet.resultDictionary()
        return try? OEZJsonModelAdapter.modelOfClass(modelClass, fromJSONDictionary: dict)
    }
    
    func findModel(sql: String!, values: [AnyObject]!,modelClass:AnyClass) ->AnyObject!{
        let rs = executeQuery(sql, values:values)
        if rs.next() {
            return resultSetToModel(rs,modelClass:modelClass)
        }
        defer {
            rs.close()
        }
        return nil
    }
    
    func findModels(sql: String!, values: [AnyObject]!,modelClass:AnyClass) -> [AnyObject]! {
        let rs = executeQuery(sql, values:values)
        var array = [AnyObject]()
        while rs.next() {
            array.append(resultSetToModel(rs,modelClass:modelClass))
        }
        defer {
            rs.close()
        }
        return array
    }
    
    
    func executeUpdate(sql: String!, values: [AnyObject]!) -> Bool {
        if !database.executeUpdate(sql, withArgumentsInArray: values) {
            XCGLogger.error("Error: \(ChatDataBaseHelper.shared.database.lastErrorMessage())")
            return false
        }
        return true
    }
    
    
    func executeQuery(sql:String, values:[AnyObject]) ->FMResultSet {
        return ChatDataBaseHelper.shared.database.executeQuery(sql, withArgumentsInArray: values)
    }
    
    func executeStatements(sql: String!) -> Bool {
        if !ChatDataBaseHelper.shared.database.executeStatements(sql) {
            XCGLogger.error("Error: \(ChatDataBaseHelper.shared.database.lastErrorMessage())")
            return false
        }
        return true
    }
    
    class BaseDBTable : NSObject {
        class func addModel(model:BaseDBModel) {
            if tableName() != nil {
                let keysAndValues = modelKeysAndValues(model)
                var seats = [String]()
                for _ in 0 ..< keysAndValues.keys.count {
                    seats.append("?")
                }
                
                let sqlString = String(format:"INSERT INTO %@ (%@) VALUES (%@)",tableName(),keysAndValues.keys.joinWithSeparator(","),seats.joinWithSeparator(","))
                
                
                if ChatDataBaseHelper.shared.executeUpdate(sqlString, values: keysAndValues.values) {
                    model.id = Int(ChatDataBaseHelper.shared.database.lastInsertRowId())
                }
                
            }
        }
        
        class func primaryKeyName() ->String! {
            return "id_"
        }
        
        class func updateModel(model:BaseDBModel) {
            let keysAndValues = modelKeysAndValues(model)
            var values = keysAndValues.values
            let sqlString = String(format:"UPDATE %@ SET  %@ = ? WHERE %@ = ? ",tableName(),keysAndValues.keys.joinWithSeparator(" = ? , "),primaryKeyName())
            values.append(model.primaryKeyValue())
            ChatDataBaseHelper.shared.executeUpdate(sqlString, values: values)
            
        }

        class func remove(id:AnyObject) ->Bool{
            let sqlString = String(format:"DELETE FROM %@  WHERE %@ = ? ",tableName(),primaryKeyName())
           return ChatDataBaseHelper.shared.executeUpdate(sqlString, values: [id])
        }
        
        
        class func tableName() ->String! {
            return nil
        }
    
        
        class func modelKeysAndValues(model:BaseDBModel,removeNames:[String] = []) ->(keys:[String], values:[AnyObject]) {
            var modelDictionary = try! OEZJsonModelAdapter.jsonDictionaryFromModel(model)
            modelDictionary.removeValueForKey(primaryKeyName())
            var values = [AnyObject]()
            var keys = [String]()
            for (key,value) in modelDictionary {
                values.append(value)
                keys.append(key as! String)
            }
            return (keys,values)
        }
        
        
     }
    
    class ChatSession : BaseDBTable {
        
        class func initTable() {
            let sqlString = "CREATE TABLE IF NOT EXISTS ChatSession (" +
                                "id_ integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
                                "sessionId_ integer," +
                                "type_ integer DEFAULT(0)," +
                                "title_ nvarchar(255)," +
                                "icon_ nvarchar(255)," +
                                "noReading_ integer DEFAULT(0)," +
                                "isTop_ integer DEFAULT(0)," +
                                "isNotDisturb_ integer DEFAULT(0));"
            
            ChatDataBaseHelper.shared.executeStatements(sqlString)
            
        }
        
        override class func tableName() ->String! {
            return "ChatSession"
        }
        
        
        class func findHistorySession() ->[ChatSessionModel]! {
            let sql = "SELECT * FROM ChatSession"
            let chatSessions = ChatDataBaseHelper.shared.findModels(sql, values: [], modelClass: ChatSessionModel.classForCoder()) as! [ChatSessionModel]
            for  chatSession in chatSessions {
                if chatSession.type == 0 {
                    chatSession.lastChatMsg = ChatDataBaseHelper.ChatMsg.findLastChatMsg(chatSession.sessionId)
                }
            }
            return chatSessions
        }
        
    }
    
    class ChatMsg : BaseDBTable {
        
        class func initTable() {
            
            let sqlString = "CREATE TABLE IF NOT EXISTS ChatMsg (" +
                                "id_ integer PRIMARY KEY AUTOINCREMENT NOT NULL," +
                                "from_uid_ integer NOT NULL," +
                                "to_uid_ integer NOT NULL," +
                                "msg_time_ integer DEFAULT(0)," +
                                "msg_type_ integer DEFAULT(0)," +
                                "status_ integer DEFAULT(0)," +
                                "content_ text NOT NULL);"
           ChatDataBaseHelper.shared.executeStatements(sqlString)
        }
        
        class func findHistoryMsg(uid:Int,lastId:Int,pageSize:Int) -> [ChatMsgModel] {
            var sql = "SELECT * FROM ChatMsg WHERE ( from_uid_ = ? OR to_uid_ = ? ) "
            if lastId != 0 {
                 sql += "AND id_ < \(lastId)"
            }
            sql += " ORDER BY id_ DESC limit 0,\(pageSize)"
            var array = ChatDataBaseHelper.shared.findModels(sql, values: [uid,uid], modelClass: ChatMsgModel.classForCoder()) as! [ChatMsgModel]
            array.sortInPlace( { (chatMsg1, chatMsg2) -> Bool in
                return chatMsg1.id < chatMsg2.id
            })
            return array
        }
        
        class func findLastChatMsg(uid:Int) -> ChatMsgModel! {
            let sql = "SELECT * FROM ChatMsg WHERE from_uid_ = ? OR to_uid_ = ? ORDER BY msg_time_ DESC "
            return ChatDataBaseHelper.shared.findModel(sql, values: [uid,uid], modelClass: ChatMsgModel.classForCoder()) as? ChatMsgModel
        }
        
        
        override class func tableName() ->String! {
            return "ChatMsg"
        }
    }
}
