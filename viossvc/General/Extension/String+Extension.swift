//
//  String.swift
//  viossvc
//
//  Created by yaowang on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

extension String {
    func trim() -> String {
        return  self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    static func stringAttributes(font:UIFont,lineSpacing:CGFloat) ->[String:AnyObject]{
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        return [NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle]
    }
     func boundingRectWithSize(size:CGSize,font:UIFont,lineSpacing:CGFloat) ->CGRect {
        let attributedString = self.attributedString(font, lineSpacing: lineSpacing)
        return attributedString.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, context: nil)
    }
    
    func attributedString(font:UIFont,lineSpacing:CGFloat) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes(String.stringAttributes(AppConst.SystemFont.S3,lineSpacing:5), range: NSMakeRange(0, attributedString.length))
        return attributedString
    }
}
