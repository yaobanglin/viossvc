//
//  InputBarView.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

 protocol  InputBarViewProcotol : OEZViewActionProtocol{
    
    func inputBarDidKeyboardShow(inputBar inputBar: InputBarView,userInfo : [NSObject : AnyObject]?)
    
    func inputBarDidKeyboardHide(inputBar inputBar: InputBarView,userInfo : [NSObject : AnyObject]?)
    
    func inputBarDidSendMessage(inputBar inputBar: InputBarView ,message: String)
    
    func inputBarDidChangeHeight(inputBar inputBar: InputBarView,height: CGFloat)
    
}



class InputBarView: OEZBaseView ,UITextViewDelegate,FaceKeyboardViewDelegate {

    @IBOutlet weak var faceButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var textView: CustomTextView!
    var faceKeyboard :FaceKeyboardView = FaceKeyboardView.loadFromNib()
    var faceKeyboardView : UIView = UIView()
    
    
    var inputDelegate : InputBarViewProcotol?
    var isKVO : Bool = false
//    var isChangeTextViewHeight = false
    
    
    let inputBarHeight : CGFloat = 50
    let kFaceKeyboardHeight : CGFloat = 216
    let sendLayer: CALayer = CALayer.init()
    override func awakeFromNib() {
        
        super.awakeFromNib()
        sendLayerSetting()
        addNotification()
        textViewSetting()
       
        facekeyboardSetting()
    }
    func facekeyboardSetting() {
        faceKeyboard.frame = CGRectMake(0, 0, UIScreen.width(), kFaceKeyboardHeight)
        faceKeyboard.faceDelegate = self
        
        faceKeyboardView.frame = faceKeyboard.frame
        
        faceKeyboardView.addSubview(faceKeyboard)
    }
    
    func textViewSetting() {
        textView.delegate = self
        textView.setPlaceHolder("输入要说的话...")
        textView.settingPlaceHolderTextColor(UIColor(RGBHex: 0xbdbdbd))
        
        let  top = (self.textView.bounds.size.height - UIFont.HEIGHT(14)) / 2.0;
        textView.settingScrollIndicatorInsets(UIEdgeInsetsMake(top, 5, 0, 5))
        
        
        textView.addObserver(self, forKeyPath: "contentSize", options: .New, context: nil)
    }
    
    func  addNotification()  {
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
            faceButton.selected = false

//            }
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "contentSize" && object === textView {
            
            let contentH = getHeight()
            let viewHeight = self.bounds.height
            if !isKVO && viewHeight != contentH  {
                inputDelegate?.inputBarDidChangeHeight(inputBar: self, height: contentH)
            }
            textView.scrollRectToVisible(CGRectMake(0, textView.contentSize.height - UIFont.HEIGHT(14), textView.contentSize.width,UIFont.HEIGHT(14)), animated: false)
        }

    }
    
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            
            didSendMessage()
            return false;
        }
        return true;
    }
    
    func textViewDidChange(textView: UITextView) {
        sendLayerChangeColor(textView.text.length() > 0)
        isKVO = false
    }
    
    func didSendMessage() {
        let  inputText = textView.text;
        inputDelegate?.inputBarDidSendMessage(inputBar: self, message: inputText)
        textView.text = nil;
        sendLayerChangeColor(false)
        isKVO = true

    }
    
    func faceKeyboardView(faceKeyboardView: FaceKeyboardView, didKeyCode keyCode: String) {
   
        
        
        
        if keyCode.length() > 0{
            textView.insertText(keyCode)
        }else {
           
            textView.deleteBackward()
        }

        
        sendLayerChangeColor(textView.text.length() > 0)
    }

    @IBAction func emojiFaceAction(sender : UIButton) {
        
        if faceButton.selected {
            textView.inputView = nil
        }
        let isSelected = faceButton.selected
        UIView.animateWithDuration(0.2) { 
            self.resignTextViewFirstResponder()
        }
       
        
         faceButton.selected = !isSelected

        setFaceBottonImage()
        if faceButton.selected {
            textView.inputView = faceKeyboardView
//            [self emojiOpen];
        }
        
        
        UIView.animateWithDuration(0.2) {
            self.becomeTextViewFirstResponder()
        }
        

        
    }
    func setFaceBottonImage() {
//        let image = UIImage(named: faceButton.selected ? "cm_emojiHigh" : "cm_emojiGray")
//        faceButton.setImage(image, forState: .Normal)
    }


    @IBAction func sendButtonAction(sender : UIButton) {
        didSendMessage()
        
    }
    
    func sendLayerSetting() {
        
        sendLayer.frame = CGRectMake(0, 10, sendButton.bounds.width, 30)
        sendLayer.masksToBounds = true
        sendLayer.cornerRadius = 3
        sendLayer.backgroundColor = UIColor(RGBHex: 0xE0E1E2).CGColor
        sendButton.layer.addSublayer(sendLayer)
    }
    
    func sendLayerChangeColor(canSend: Bool) {
        if sendButton.userInteractionEnabled != canSend {
            sendLayer.backgroundColor = canSend ? UIColor(RGBHex: 0x141F33).CGColor :UIColor(RGBHex: 0xE0E1E2).CGColor
            sendButton.userInteractionEnabled = canSend
        }
    }
    
    
    
    func getHeight() -> CGFloat {
    var height = inputBarHeight
        if textView.text.length() != 0 {
           
            height =  ceil(textView.sizeThatFits(textView.frame.size).height)
            height = height > 73 ? 73 : height
            height += 20
        }
        //    else
        //    {
        //        //全选剪贴的情况
        //        height = kInputBarHeight;
        //    }
        height = height > inputBarHeight ? height : inputBarHeight;
        return height;
    }

    
    func becomeTextViewFirstResponder() {
        textView.becomeFirstResponder()
    }
    
    func resignTextViewFirstResponder() {
        textView.resignFirstResponder()
    }
    func isTextViewFirstResponder() -> Bool{
      return  textView.isFirstResponder()
    }

    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
        textView.removeObserver(self, forKeyPath: "contentSize")
    }
    
}
