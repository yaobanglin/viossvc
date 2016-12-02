//
//  UIFont+Extension.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import Foundation

extension UIFont {
    
  static  func SIZE(fontSize: CGFloat) -> UIFont {
        return UIFont.systemFontOfSize(fontSize)
    }
    

 static   func HEIGHT(fontSize : CGFloat) -> CGFloat {
      return   UIFont.systemFontOfSize(fontSize).lineHeight
    }
    
    
}