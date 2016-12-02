//
//  InputBarView.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class InputBarView: OEZBaseView  {

    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    let sendLayer: CALayer = CALayer.init()
    override func awakeFromNib() {
        super.awakeFromNib()
        sendLayerSetting()
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func sendLayerSetting() {
        
        sendLayer.frame = CGRectMake(0, 10, sendButton.bounds.width, 30)
        sendLayer.masksToBounds = true
        sendLayer.cornerRadius = 3
        sendLayer.backgroundColor = UIColor(RGBHex: 0xE0E1E2).CGColor
        sendButton.layer.addSublayer(sendLayer)
    }
    
    func sendLayerChangeColor(canSend: Bool) {
        sendLayer.backgroundColor = canSend ? UIColor(RGBHex: 0x141F33).CGColor :UIColor(RGBHex: 0xE0E1E2).CGColor
    }
    
}
