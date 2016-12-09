//
//  SMSServerViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class SMSServerViewController: BaseTableViewController {
    
    @IBOutlet weak var VerifyText: UITextField!
    @IBOutlet weak var codeBtn: UIButton!
    @IBOutlet weak var nextStepBtn: UIButton!
    @IBOutlet weak var protocolBtn: UIButton!
    var serverData: [UserServerModel]?
    var codeTime: Int = 60
    var timer: NSTimer?
    var timeStemp: Int64 = 0
    var token = ""
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        nextStepBtn.layer.cornerRadius = 6
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if CurrentUserHelper.shared.userInfo.auth_status_ == -1 {
            let alertController = UIAlertController.init(title: "身份认证", message: "您还未进行身份认证，前往设置", preferredStyle: .Alert)
            let setAction = UIAlertAction.init(title: "前去认证", style: .Default, handler: { [weak self](sender) in
                alertController.dismissController()
                self?.navigationController?.pushViewControllerWithIdentifier(AuthUserViewController.className(), animated: true)
                })
            let cancelAction = UIAlertAction.init(title: "取消", style: .Default, handler: { [weak self](sender) in
                alertController.dismissController()
                self?.navigationController?.popViewControllerAnimated(true)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(setAction)
            presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if CurrentUserHelper.shared.userInfo.auth_status_  == 0 {
            SVProgressHUD.showWainningMessage(WainningMessage: "个人认证尚未通过，请稍后再试", ForDuration: 1, completion: {[weak self] in
                self?.navigationController?.popViewControllerAnimated(true)
                return
            })
        }
    }
    deinit {
        timer = nil
    }
    //codeBtn
    @IBAction func codeBtnTapped(sender: UIButton) {
        
        AppAPIHelper.userAPI().smsVerify(.Login, phone: CurrentUserHelper.shared.userInfo.phone_num!, complete: {[weak self] (result) in
            if result == nil{
                return
            }
            
            if let strongSelf = self{
                let model = result as! SMSVerifyRetModel
                strongSelf.timeStemp = model.timestamp as Int64
                strongSelf.token = model.token
                strongSelf.codeBtn.enabled = false
                strongSelf.timer = NSTimer.scheduledTimerWithTimeInterval(1, target: strongSelf, selector: #selector(strongSelf.updateBtnTitle), userInfo: nil, repeats: true)
            }
        }, error: errorBlockFunc())
    }
    func updateBtnTitle() {
        if codeTime == 0 {
            codeBtn.enabled = true
            codeBtn.setTitle("重新发送", forState: .Normal)
            codeBtn.setTitleColor(UIColor(RGBHex: 0xb72528), forState: .Normal)
            codeTime = 60
            timer?.invalidate()
            return
        }
        codeTime = codeTime - 1
        let title: String = "\(codeTime)秒后重新发送"
        codeBtn.setTitleColor(UIColor(RGBHex: 0x666666), forState: .Normal)
        codeBtn.setTitle(title, forState: .Normal)
    }
    //protolBtn
    @IBAction func followProtocol(sender: UIButton) {
        sender.selected = !sender.selected
    }
    
    //nextBtn
    @IBAction func nextBtnTapped(sender: AnyObject) {
        if protocolBtn.selected ==  false{
            SVProgressHUD.showErrorMessage(ErrorMessage: "请先同意《服务条款》", ForDuration: 1, completion: nil)
            return
        }
        if checkTextFieldEmpty([VerifyText]){
            performSegueWithIdentifier(ServerManagerViewController.className(), sender: nil)
            return
            let param: Dictionary<String, AnyObject> = ["phone_num_":CurrentUserHelper.shared.userInfo.phone_num!,
                                                        "timestamp_":Int(timeStemp),
                                                        "token_": token,
                                                        "verify_type_": 1,
                                                        "verify_code_":Int(VerifyText.text!)!]
            AppAPIHelper.userAPI().verifyCode(param, complete: { [weak self](result) in
                self?.performSegueWithIdentifier(ServerManagerViewController.className(), sender: nil)
            }, error: errorBlockFunc())
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let controller =  segue.destinationViewController as! ServerManagerViewController
        if serverData != nil {
            controller.serverData = serverData!
        }
    }
}
