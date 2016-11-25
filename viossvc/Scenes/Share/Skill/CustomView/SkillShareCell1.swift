//
//  SkillShareChatCellTableViewCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit
import Kingfisher
class SkillShareCell1: OEZTableViewCell {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeAndNumLabel: UILabel!
    @IBOutlet weak var nameAndLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func update(data: AnyObject!) {
        let model:SkillShareModel = data as! SkillShareModel
            titleLabel.text = model.share_theme
            let dfmatter = NSDateFormatter()
            dfmatter.dateFormat="yyyy-MM-dd HH:mm:ss "
            let date = NSDate(timeIntervalSince1970: Double(model.share_start))
            nameAndLabel.text = "\(model.share_user)|\(model.user_label)"
            timeAndNumLabel.text = "\(dfmatter.stringFromDate(date))"
            var string:String = "参加"
            switch model.share_status {
            case 1:
                statusLabel.text = "正在筹备";
                string = "报名"
            case 2:
                statusLabel.text = "正在进行";
            default:
                statusLabel.text = "已结束";
            }
            if model.entry_num > 0 {
                timeAndNumLabel.text! += "\(model.entry_num)人\(string)"
            }
            picImageView.kf_setImageWithURL(NSURL(string: model.brief_pic),placeholderImage: UIImage(named: ""))

    }

}
