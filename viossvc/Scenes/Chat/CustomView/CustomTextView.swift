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
   private var placeHolderFont : UIFont = UIFont.italicSystemFontOfSize(14)
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
   
}



