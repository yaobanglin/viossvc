//
//  CustomTextView.swift
//  viossvc
//
//  Created by abx’s mac on 2016/12/5.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class CustomTextView: UITextView {
   private var placeHolder : String = ""
    private  var placeHolderFont : UIFont?
    private var getPlaceHolderFont : UIFont {
        return  (placeHolderFont == nil ? font : placeHolderFont)!
    }

   private var placeHolderTextColor : UIColor = UIColor.lightGrayColor()
   private var isClearPlaceHolder = false
    
    var overrideNextResponder : UIResponder?
    
    override func nextResponder() -> UIResponder? {
        if  overrideNextResponder != nil{
            return overrideNextResponder
        }else {
            return super.nextResponder()
        }
    }

    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if overrideNextResponder != nil {
            return false
        }else {
            return super.canPerformAction(action, withSender: sender)
        }
    }

//#pragma mark - Setters
    
    func setPlaceHolder(placeHolder : String)  {
        if placeHolder != self.placeHolder {
            let maxChars = Int(CustomTextView.maxCharactersPerLine())
            var  place : NSString = placeHolder
             if(placeHolder.length() > maxChars) {
                place = place.substringToIndex(maxChars - 8)
                place = place.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).stringByAppendingString("...")
 
            }
            self.placeHolder = place as String
            isClearPlaceHolder = false;
            self.setNeedsDisplay();
        }
    }
    
    
    func settingFont(textFont fontT : CGFloat, placeHolderFont : CGFloat ) {
        self.font = UIFont.systemFontOfSize(fontT)
        self.placeHolderFont = UIFont.systemFontOfSize(placeHolderFont)
        self.setNeedsDisplay();
    }
    func settingPlaceHolderTextColor(placeHolderTextColor : UIColor) {
        if self.placeHolderTextColor != placeHolderTextColor {
            self.placeHolderTextColor = placeHolderTextColor
            setNeedsDisplay()
        }
    }

    func settingScrollIndicatorInsets( insets :UIEdgeInsets) {
        var insetVar = insets
        scrollIndicatorInsets = insetVar
        insetVar.left -= 5
        textContainerInset = insetVar
        setNeedsDisplay()
    }
    
    func settingtTextContainerInset(insets :UIEdgeInsets) {
        textContainerInset = insets
        setNeedsDisplay()
    }
    
    

//#pragma mark - Message text view
    func numberOfLinesOfText() -> UInt {
        return CustomTextView.numberOfLinesForMessage(self.text)
    }
    class func  numberOfLinesForMessage(text : String) -> UInt {
    
        return (UInt(text.length()) / CustomTextView.maxCharactersPerLine())  + 1
    }
    
    class func maxCharactersPerLine() -> UInt {
        return UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone ? 33 : 109
    }
   
    override var text: String! {
        didSet {
            setNeedsDisplay()
        }
    }
    override var attributedText: NSAttributedString! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var contentInset: UIEdgeInsets {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var font: UIFont? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var textAlignment: NSTextAlignment {
        didSet {
            setNeedsDisplay()
        }
    }
    
    
    //#pragma mark - Notifications
    
    func didReceiveTextDidChangeNotification(notification :NSNotification )  {
        setNeedsDisplay()
    }
    
    func setup()  {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(CustomTextView.didReceiveTextDidChangeNotification(_:)), name: UITextViewTextDidChangeNotification, object: self)
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleWidth;
        self.layoutManager.allowsNonContiguousLayout = false;
        self.scrollEnabled = true;
        self.scrollsToTop = false;
        //    self.scrollIndicatorInsets = UIEdgeInsetsMake(13,10, 13, 10);
        self.userInteractionEnabled = true;
        self.keyboardAppearance = UIKeyboardAppearance.Default;
        self.keyboardType = UIKeyboardType.Default;
        //    self.textContainerInset = UIEdgeInsetsMake(12, 0, 13, 0);           // 调整光标位置  默认是（8 0 8 0） 调小需要微调 不建议输入条这么小
        self.textAlignment = NSTextAlignment.Left;
    }
    
//    override init(frame: CGRect, textContainer: NSTextContainer?) {
//        super.init(frame: frame, textContainer: textContainer)
//        setup()
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    
    deinit {
       NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: self)
    }
    
    func placeHolderTop(y : CGFloat) -> CGFloat {
        var height  = y + self.scrollIndicatorInsets.top
        height += (self.font!.lineHeight -  getPlaceHolderFont.lineHeight) / 2.0;
        return height
        
    }
    
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        
        
        
        if(self.text.length() == 0 && placeHolder.length() != 0) {
            rect.origin.y
            let placeHolderRect = CGRectMake(self.scrollIndicatorInsets.left,placeHolderTop(rect.origin.y) ,rect.size.width - 2 * self.scrollIndicatorInsets.left,rect.size.height);
            
             placeHolderTextColor.set()
            
            let  paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = NSLineBreakMode.ByTruncatingTail;
            paragraphStyle.alignment = self.textAlignment;
            
            let string : NSString = self.placeHolder
            string.drawInRect(placeHolderRect, withAttributes: [NSFontAttributeName : getPlaceHolderFont, NSForegroundColorAttributeName : placeHolderTextColor ,NSParagraphStyleAttributeName : paragraphStyle])
            
            isClearPlaceHolder = false
            
     
        }else if (isClearPlaceHolder == false){
            isClearPlaceHolder = true
            
            CGContextClearRect(UIGraphicsGetCurrentContext(), CGRectZero);
        }

        
    }
    
    
    
    
  
    
    
}





