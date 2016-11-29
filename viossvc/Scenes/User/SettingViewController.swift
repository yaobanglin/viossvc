//
//  SettingViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class SettingViewController: UITableViewController {
    
    @IBOutlet weak var userNumLabel: UILabel!
    @IBOutlet weak var authLabel: UILabel!
    @IBOutlet weak var authCell: UITableViewCell!
    @IBOutlet weak var cacheLabel: UILabel!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var aboutUSCell: UITableViewCell!
    @IBOutlet weak var cacheCell: UITableViewCell!
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
    }
    //MARK: --DATA
    func initData() {
        
    }
    //MARK: --UI
    func initUI() {
        let userNum = CurrentUserHelper.shared.userInfo.phone_num! as NSString
        userNumLabel.text = userNum.stringByReplacingCharactersInRange(NSRange.init(location: 4, length: 4), withString: "****")
        
        
        cacheLabel.text = "\(Double(calculateCacle())) M"
    }
    @IBAction func logoutBtnTapped(sender: AnyObject) {
        CurrentUserHelper.shared.logout()
        let rootController = self.storyboard?.instantiateViewControllerWithIdentifier("LoginNavigationController")
        UIApplication.sharedApplication().keyWindow!.rootViewController = rootController
    }
    
    // 计算缓存
    func calculateCacle() ->Double {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let files = NSFileManager.defaultManager().subpathsAtPath(path!)
        var size = 0.00
        for file in files! {
            let filePath = path?.stringByAppendingString("/\(file)")
            let fileAtrributes = try! NSFileManager.defaultManager().attributesOfItemAtPath(filePath!)
            for (attrKey,attrVale) in fileAtrributes {
                if attrKey == NSFileSize {
                    size += attrVale.doubleValue
                }
            }
        }
        let totalSize = size/1024/1024
        return totalSize
    }
    // 清除缓存
    func clearCacleSizeCompletion(completion: (()->Void)?) {
        let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first
        let files = NSFileManager.defaultManager().subpathsAtPath(path!)
        showWithStatus("清除中...")
        for file in files! {
            let filePath = path?.stringByAppendingString("/\(file)")
            if NSFileManager.defaultManager().fileExistsAtPath(filePath!) {
                do{
                    try NSFileManager.defaultManager().removeItemAtPath(filePath!)
                }catch{
                    
                }
            }
        }
        completion
        
    }
    //MARK: --TableView
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell == cacheCell{
            clearCacleSizeCompletion({ [weak self] in
                self?.cacheLabel.text = "\(Double((self?.calculateCacle())!)) M"
                SVProgressHUD.dismiss()
            })
            return
        }
        
    }
    
    deinit{
        
    }
}
