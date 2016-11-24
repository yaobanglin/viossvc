//
//  BaseModel.swift
//  viossvc
//
//  Created by yaowang on 2016/11/21.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import XCGLogger
class BaseModel: OEZModel {
    override class func jsonKeyPostfix(name: String!) -> String! {
        return "_";
    }
    deinit {
        
            XCGLogger.debug("deinit \(self)")
        
    }
}
