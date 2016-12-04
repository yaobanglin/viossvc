//
//  AppAPIHelper.swift
//  viossvc
//
//  Created by yaowang on 2016/11/22.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class AppAPIHelper: NSObject {
    private static var _userAPI = UserSocketAPI()
    class func userAPI() ->UserAPI {
        return _userAPI
    }
    
    private static var _skillShareAPI = SkillShareSocketAPI()
    class func skillShareAPI() ->SkillShareAPI {
        return _skillShareAPI
    }
    
    private static var _tourShareAPI = TourShareSocketAPI()
    class func tourShareAPI() -> TourShareAPI{
        return _tourShareAPI
    }
    
    private static var _commenShareAPI = CommenSocketAPI()
    class func commenAPI() -> CommenAPI {
        return _commenShareAPI
    }
    
    private static var _orderAPI = OrderListSocketAPI()
    class func orderAPI() -> OrderListAPI {
        
        return _orderAPI
    }
    
    private static var _chatAPI = ChatSocketAPI()
    
    class func chatAPI() ->ChatAPI {
        return _chatAPI
    }
}

