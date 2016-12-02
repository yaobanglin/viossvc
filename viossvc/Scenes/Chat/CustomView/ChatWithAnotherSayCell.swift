//
//  ChatWithAnotherSayCell.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ChatWithAnotherSayCell: ChatWithBaseSayCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        let image = UIImage(named: "msg-bubble-another")
        backImage.image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 23  , 17, 23), resizingMode: UIImageResizingMode.Stretch)
  
    }
}
