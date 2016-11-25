//
//  BaseSocketAPI.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class BaseSocketAPI: NSObject {
    
    /**
     *  请求接口 数据解析成字典
     *
     *  @param packet 请求包
     *  @param complete complete返回字典
     *  @param error    失败回调
     *
     *
     */
    func startRequest(packet: SocketDataPacket, complete: CompleteBlock, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet,complete: {  (response) in
            complete((response as? SocketJsonResponse)?.responseJsonObject())
            },error: error)
    }
    
    /**
     *  请求接口 数据result_字段解析成int
     *
     *  @param packet 请求包
     *  @param complete complete返回result_ int值
     *  @param error    失败回调
     *
     */
    func startResultIntRequest(packet: SocketDataPacket, complete: CompleteBlock, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet,complete: {  (response) in
            complete((response as? SocketJsonResponse)?.responseResult())
            },error: error)
    }
    
    /**
     *  请求接口 数据解析成model实体
     *
     *  @param packet 请求包
     *  @param modelClass 要解析填充的model类class
     *  @param complete complete返回modelClass的model实体
     *  @param error    失败回调
     *
     */
    func startModelRequest(packet: SocketDataPacket, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            complete?((response as? SocketJsonResponse)?.responseModel(modelClass))
            }, error: error)
    }
    
    /**
     *  请求接口 数据解析成model实体数组
     *
     *  @param packet 请求包
     *  @param modelClass 要解析填充的model类class
     *  @param complete complete返回modelClass的model实体数组
     *  @param error    失败回调
     *
     */
    func startModelsRequest(packet: SocketDataPacket, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            complete?((response as? SocketJsonResponse)?.responseModels(modelClass))
            }, error: error)
    }
    
    /**
     *  请求接口 数据data_list_字段解析成model实体数组
     *
     *  @param packet 请求包
     *  @param modelClass 要解析填充的model类class
     *  @param complete complete返回modelClass的model实体数组
     *  @param error    失败回调
     *
     */
    func startDataListRequest(packet: SocketDataPacket, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        
       startModelsRequest(packet, listName:"data_list_", modelClass: modelClass, complete: complete, error: error)
    }
    
    /**
     *  请求接口 数据listName值的字段解析成model实体数组
     *
     *  @param packet 请求包
     *  @param listName 列表字段名
     *  @param modelClass 要解析填充的model类class
     *  @param complete complete返回modelClass的model实体数组
     *  @param error    失败回调
     *
     */
    func startModelsRequest(packet: SocketDataPacket, listName:String, modelClass: AnyClass, complete: CompleteBlock?, error: ErrorBlock) {
        SocketRequestManage.shared.startJsonRequest(packet, complete: {  (response) in
            let dict:[String:AnyObject]? = ((response as? SocketJsonResponse)?.responseJsonObject()) as? [String:AnyObject]
            if dict != nil {
                 let array:[AnyObject]? = dict?[listName] as? [AnyObject]
                if array != nil  {
                    complete?(try! OEZJsonModelAdapter.modelsOfClass(modelClass, fromJSONArray: array))
                    return ;
                }
            }
            complete?([]);
            }, error: error)
    }

}
