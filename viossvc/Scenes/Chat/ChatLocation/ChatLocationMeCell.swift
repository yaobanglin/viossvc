//
//  ChatLocationMeCell.swift
//  TestAdress
//
//  Created by J-bb on 16/12/29.
//  Copyright © 2016年 J-bb. All rights reserved.
//

import UIKit

class ChatLocationMeCell: ChatLocationCell {



    override func setupDataWithAdress(title:String?,adress:String?, isOther:Bool) {
        super.setupDataWithAdress(title, adress:adress, isOther: isOther)
        var image = UIImage(named: "msg-bubble-me")
        image = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        bundleImageView.image = image?.resizableImageWithCapInsets(UIEdgeInsetsMake(17, 23  , 17, 23), resizingMode: UIImageResizingMode.Stretch)
    }
    
}
