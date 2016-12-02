//
//  SingleSkillCell.swift
//  HappyTravel
//
//  Created by J-bb on 16/11/5.
//  Copyright © 2016年 J-bb. All rights reserved.
//

import UIKit

class SingleSkillCell: UICollectionViewCell {
    
    private lazy var deleteButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.clearColor()
        button.setTitle("-", forState: .Normal)
        button.layer.borderColor =  UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1).CGColor
        button.setTitleColor( UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1), forState: .Normal)
        return button
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.whiteColor()
        label.layer.cornerRadius = 15
        label.layer.masksToBounds = true
        label.textAlignment = .Center
        label.layer.borderColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1).CGColor
        label.layer.borderWidth = 1.0
        label.textColor = UIColor.init(red: 183/255.0, green: 39/255.0, blue: 43/255.0, alpha: 1)
        label.font = UIFont.systemFontOfSize(14)
        return label
    }()
    
    
   override  init(frame: CGRect) {
        super.init(frame: frame)
    contentView.backgroundColor = UIColor.whiteColor()
    contentView.addSubview(deleteButton)
    contentView.addSubview(titleLabel)
    
    titleLabel.frame = bounds
    }

    
    
    func setupTitle(text:String) {
        
        titleLabel.text = text
    }
    


    /**
     设置圆角、边框颜色、字体颜色、deleteButton隐藏
     
     - parameter textColor:
     - parameter borderColor:
     - parameter cornerRadius:
     - parameter isDelete:
     */
    private func  setUpWith(textColor:UIColor, borderColor:CGColor, cornerRadius:CGFloat, isDelete:Bool) {
        titleLabel.textColor = textColor
        titleLabel.layer.borderColor = borderColor
        titleLabel.layer.cornerRadius = cornerRadius

        deleteButton.hidden = !isDelete
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    

}
