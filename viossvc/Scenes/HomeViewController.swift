//
//  HomeViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation


class HomeViewController: SegmentedViewController, TouchMaskViewDelegate{
    
    
    var maskView:YD_MaskView?
    
    var count = 0
    
    var images = ["message_mask", "order_mask", "refresh_service_mask"]
    
    
    func segmentedViewControllerIdentifiers() -> [String]! {
        return [ChatSessionViewController.className(),OrderListViewController.className()];
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        addMaskView()
    }
   
    func addMaskView() {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let key = "isShowMaskView"
        
        let isShowMaskView = userDefaults.valueForKey(key)
        guard isShowMaskView == nil else {return}
        
        userDefaults.setBool(true, forKey: key)
        maskView = YD_MaskView.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height))

        maskView?.setMaskFrame(getRectWithCount(), isTop: true, infoImage: images[count], infoLeft: false)
        count += 1
        maskView?.delegate = self
        UIApplication.sharedApplication().keyWindow?.addSubview(maskView!)
    }
    func getRectWithCount() -> CGRect {
        if count < 2 {
            let originX = segmentedControl.frame.origin.x
            let originY = segmentedControl.frame.origin.y + 20
            let width = segmentedControl.frame.size.width
            let height = segmentedControl.frame.size.height
            if count == 0 {
                return CGRectMake(originX, originY, width / 2, height)
            }
            
            return CGRectMake(originX + width / 2, originY, width / 2, height)
        }
            
        let width:CGFloat = 70.0
        let originY:CGFloat =  7.0 + 20
        let height:CGFloat = 30.0
        let originX = UIScreen.mainScreen().bounds.size.width - width - 17.5
        
        return CGRectMake(originX, originY, width, height)
        
    }
    func touchMaskView() {
        switch count {
        case 1:
            segmentedControl.selectedSegmentIndex = 1
            maskView?.setMaskFrame(getRectWithCount(), isTop: true, infoImage: images[count], infoLeft: true)

            break
        case 2:
            maskView?.setMaskFrame(getRectWithCount(), isTop: true, infoImage: images[count], infoLeft: true)

            break
        case 3:
            removeMaskView()
            break
        default:
            break
        }
        count+=1
    }
    
    func removeMaskView() {
        maskView?.removeFromSuperview()
        maskView?.frame = CGRectZero
        segmentedControl.selectedSegmentIndex = 0
        maskView = nil
    }
    
    @IBAction func refreshServiceAction(sender: AnyObject) {
        let storyBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let refreshServiceVC = storyBoard.instantiateViewControllerWithIdentifier("SMSServerViewController")
        
        navigationController?.pushViewController(refreshServiceVC, animated: true)
    }


}
