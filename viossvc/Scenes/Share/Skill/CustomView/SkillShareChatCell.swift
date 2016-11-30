//
//  SkillShareChatCellTableViewCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit

class SkillShareChatCell: OEZTableViewCell ,OEZCalculateProtocol {

    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func update(data: AnyObject!) {
        let model = data as! SkillShareCommentModel
        
        contentLabel.text = model.content;
        headPicImageView.kf_setImageWithURL(NSURL.init(string: model.head_url!), placeholderImage: UIImage(named: "test1"))
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        let model = data as! SkillShareCommentModel
        let size = model.content.boundingRectWithSize(CGSizeMake(UIScreen.width() - 93 * 2 , CGFloat.max), font: UIFont.systemFontOfSize(15), lineSpacing: 5)
        
        
        return size.height + 49;
    }
}
