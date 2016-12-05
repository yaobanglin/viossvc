//
//  ChatListCell.swift
//  viossvc
//
//  Created by yaowang on 2016/11/1.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class ChatSessionCell: OEZTableViewCell {
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    override func update(data: AnyObject!) {
        let chatSession = data as? ChatSessionModel
        if chatSession != nil {
            nicknameLabel.text = chatSession?.title
            headPicImageView.kf_setImageWithURL(NSURL(string: chatSession!.icon),placeholderImage:UIImage(named: "head_boy"))
            contentLabel.text = chatSession?.lastChatMsg?.content
            timeLabel.text = chatSession?.lastChatMsg?.formatMsgTime()
            
        }
    }
}
