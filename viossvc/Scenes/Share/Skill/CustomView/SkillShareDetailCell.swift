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


