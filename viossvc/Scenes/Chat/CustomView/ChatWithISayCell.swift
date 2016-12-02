//
//  ChatWithISayCell.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatWithISayCell:ChatWithBaseSayCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var image = UIImage(named: "msg-bubble-me")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        backImage.image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 23  , 17, 23), resizingMode: UIImageResizingMode.Stretch)
        backImage.tintColor = UIColor.whiteColor()
        detailLabel.textColor = UIColor.init(RGBHex: 0x000001)
        
    }
}
