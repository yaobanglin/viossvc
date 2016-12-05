//
//  InputBarView.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

 protocol  InputBarViewProcotol : OEZViewActionProtocol{
    
    func inputBarDidKeyboardShow(inputBar inputBar: InputBarView,userInfo : Any)
    
    func inputBarDidKeyboardHide(inputBar inputBar: InputBarView,userInfo : Any)
    
    func inputBarDidSendMessage(message: String)
    
    func inputBarDidChangeHeight(height: CGFloat)
    
}



class InputBarView: OEZBaseView  {

    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    var inputDelegate : InputBarViewProcotol?
    
    
    let sendLayer: CALayer = CALayer.init()
    override func awakeFromNib() {
        
        super.awakeFromNib()
        sendLayerSetting()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputBarView.didKeyboardShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(InputBarView.didKeyboardHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    
    
    }
    
    func  registeredDelegate(sender : InputBarViewProcotol)  {
     
        inputDelegate = sender
    }
    
    
    
    func didKeyboardShow( notification: NSNotification) {
        
        if (textView.isFirstResponder()) {
//            _keyboardShow = YES;
//            _isActionEmoji = NO;
//
             inputDelegate?.inputBarDidKeyboardShow(inputBar: self, userInfo: notification.userInfo)
//
            
        }
    }
    func didKeyboardHide(notification: NSNotification) {
        
        if ( textView.isFirstResponder())
        {
            if( textView.inputView != nil )
            {
                textView.inputView = nil;
            }
//            if (![self isTouchEmoji]) {
//                _keyboardShow = NO;
            
            inputDelegate?.inputBarDidKeyboardHide(inputBar: self, userInfo: notification.userInfo)
                    self.faceButton.selected = false;
                    

//            }
            
        }
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
