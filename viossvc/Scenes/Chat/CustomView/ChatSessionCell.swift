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
    @IBOutlet weak var noReadNumLabel: UILabel!
    
    @IBOutlet weak var noReadWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        noReadNumLabel.backgroundColor = UIColor.redColor()
    }
    
    override func update(data: AnyObject!) {
        let chatSession = data as! ChatSessionModel
        nicknameLabel.text = chatSession.title
        headPicImageView.kf_setImageWithURL(NSURL(string: chatSession.icon),placeholderImage:UIImage(named: "head_boy"))
        
        if chatSession.lastChatMsg.msg_type == ChatMsgType.Text.rawValue {
            contentLabel.text = chatSession.lastChatMsg?.content
        }
        else if chatSession.lastChatMsg.msg_type == ChatMsgType.Location.rawValue {
            contentLabel.text = "[位置分享]"
        } else {
            contentLabel.text = "[未知消息类型，请更新最新版查看]"
        }
        timeLabel.text = chatSession.lastChatMsg?.formatMsgTime()
        noReadNumLabel.hidden = chatSession.noReading == 0
        noReadNumLabel.text = "\(chatSession.noReading)"
        if chatSession.noReading > 9 {
            noReadWidthConstraint.constant = 12 + 7
        }
        if chatSession.noReading > 99 {
            noReadWidthConstraint.constant = 12 + 15
            noReadNumLabel.text = "99+"
        }
    }
}
