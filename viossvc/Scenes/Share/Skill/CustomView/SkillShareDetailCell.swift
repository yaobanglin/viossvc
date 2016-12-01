//
//  SkillShareDetailCell.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import UIKit


class SkillShareDetailCell: OEZTableViewCell {
    static var selectTabAction:Int = 100001;
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var viewLineConstraint: NSLayoutConstraint!
    
    @IBAction func didActionButton(sender: AnyObject) {
       
        didSelectTab(sender as! NSObject == detailButton);
    }
    
    func didSelectTab(isDetailButton:Bool) {
        detailButton.enabled = !isDetailButton;
        commentButton.enabled = isDetailButton;
        UIView.animateWithDuration(0.2, animations: {
            self.viewLineConstraint.constant = isDetailButton ? 0 : self.commentButton.frame.width;
            self.layoutIfNeeded();
            }) { (Bool) in
                self.didSelectRowAction(UInt(SkillShareDetailCell.selectTabAction),data: isDetailButton ? 0 : 1);
        };
    }
}




class SkillShareDetailCell1: OEZTableViewCell , OEZCalculateProtocol {
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var picView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func update(data: AnyObject!) {
        let model = data as! SkillShareDetailModel
        settingPicArray(model)
        timeLabel.text = model.share_startStr(false, ChinaDate: true)
        numLabel.text = "\(model.entry_num)人"
        statusLabel.text = model.share_statusStr
        
        
    }
    
    func settingPicArray(model : SkillShareDetailModel)  {
        
        func userListEnumerate(array:[UserModel]) {
            let startTag = 100 + 5 - array.count
            for (index , value) in array.enumerate() {
                let imageView  = picView.viewWithTag(startTag + index) as? UIImageView
                imageView?.hidden = false
                imageView?.kf_setImageWithURL(NSURL(string: value.head_url!), placeholderImage: UIImage(named: "head_boy"))
            }
        }
        
        
        
        if  model.user_list.count >= 5{
            let userList = model.user_list[0...4]
            userListEnumerate(Array(userList))
        }
        else {
   
            userListEnumerate(model.user_list)
            
            for index in  0 ..< (5 - model.user_list.count) {
                let imageView  = picView.viewWithTag(100 + index) as? UIImageView
                imageView?.hidden = true
            }
        }
        
        

        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 80;
    }
    

    
}


class SkillShareDetailCell2: OEZTableViewCell ,OEZCalculateProtocol {
    @IBOutlet weak var headPicImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func update(data: AnyObject!) {
        let model = data as! SkillShareDetailModel
    
        headPicImageView.kf_setImageWithURL(NSURL.init(string: model.share_head), placeholderImage: UIImage(named: "head_boy"))
        nicknameLabel.text = model.share_user
        titleLabel.text = model.user_label
        
    }
    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        return 75;
    }
    
    
    
}


class SkillShareDetailCell3: OEZTableViewCell ,OEZCalculateProtocol {
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
    static func calculateHeightWithData(data: AnyObject!) -> CGFloat {
        let model = data as! SkillShareDetailModel
        let rect = model.summary.boundingRectWithSize(CGSizeMake(UIScreen.width()-CGFloat(36), 0),font:AppConst.SystemFont.S3,lineSpacing:5)
        return rect.height + 40
    }
    
    
    override func update(data:AnyObject!) {
        let model = data as! SkillShareDetailModel
        contentLabel.attributedText = model.summary.attributedString(AppConst.SystemFont.S3,lineSpacing:5)
        contentLabel.sizeToFit()
    }
    

    
}


