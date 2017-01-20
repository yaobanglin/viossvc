//
//  RegisterViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
import XCGLogger

class RegisterViewController: BaseLoginViewController {
    var registerModel:RegisterModel = RegisterModel();
    var childViewControllerData:Bool = true;
    @IBOutlet weak var smsButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    private var timer:NSTimer?
    private var timeSecond:Int = 0
    
    @IBAction func didActionLogin(sender: AnyObject) {
        let navController = navigationController
        navController!.popViewControllerAnimated(false);
        navController?.pushViewControllerWithIdentifier(MainViewController.className(), animated: false, valuesForKeys: [MainViewController.childViewControllerIdentifierKey:LoginViewController.className()])
    
    }
    
    
    @IBAction func didActionNext(sender: AnyObject) {
        guard textField3.text?.length() <= 0 else {
            checkInviteCode()
            return
        }
        pushToNextPage()

    }
    func checkInviteCode() {
        AppAPIHelper.userAPI().checkInviteCode(textField1.text!, inviteCode: (textField3.text?.change32To10())!, complete: { (response) in
            self.checkWithResult(response as! Int)
            }, error: errorBlockFunc())
      }
    
    func checkWithResult(result:Int) {
        if result == 0 {
            showErrorWithStatus(AppConst.Text.CheckInviteCodeErr);
        } else if result == 1 {
            registerModel.invitation_phone_num = textField3.text!.change32To10()
            pushToNextPage()
        }
    }
    func pushToNextPage() {
        MobClick.event(AppConst.Event.sign_next)
        if checkTextFieldEmpty([textField1,textField2]) && checkPhoneFormat(textField1.text!) {
            let verify_code:Int? = Int(textField2.text!.trim());
            if( verify_code != nil ) {
                registerModel.verify_code = verify_code!;
                self.stopTimer()
                navigationController?.pushViewControllerWithIdentifier(MainViewController.className(), animated: true, valuesForKeys: [MainViewController.childViewControllerIdentifierKey:PasswordViewController.className(),MainViewController.childViewControllerDataKey:registerModel])
            }
            else {
                showErrorWithStatus(AppConst.Text.VerifyCodeErr );
            }
        }
    }
    
    @IBAction func didActionSMS(sender: AnyObject) {
        if checkTextFieldEmpty([textField1]) && checkPhoneFormat(textField1.text!) {
            registerModel.phone_num = textField1.text
            registerModel.smsType = childViewControllerData ? .Register : .Login
            AppAPIHelper.userAPI().smsVerify(registerModel.smsType, phone: registerModel.phone_num, complete: { [weak self] (model) in
                self?.didSMSVerifyComplete(model as? SMSVerifyRetModel)
                }, error: { [weak self ] (error) in
                    self?.showErrorWithStatus(AppConst.Text.SMSVerifyCodeErr)
                    self?.stopTimer()
            })
            smsButton.enabled = false;
            setupTimer();
        }
    }
    
    func didSMSVerifyComplete(model:SMSVerifyRetModel?) {
        registerModel.timestamp = model!.timestamp
        registerModel.token = model?.token
        nextButton.enabled = true;
        nextButton.backgroundColor = AppConst.Color.CR
    }
    
    //MARK: --计时器
    func setupTimer() {
        timeSecond = 60
        updateSMSButtonTitle()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: #selector(didActionTimer), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timeSecond = 0;
        smsButton.enabled = true
        smsButton.setTitle(AppConst.Text.ReSMSVerifyCode, forState: .Normal)
        timer?.invalidate()
        timer = nil

    }
    
    func updateSMSButtonTitle() {
        let showInfo = String(format: "%ds", timeSecond)
        smsButton.setTitle(showInfo, forState: .Disabled)
    }
    func didActionTimer() {
        timeSecond -= 1
        if timeSecond > 0 {
            updateSMSButtonTitle()
        } else {
            stopTimer()
        }
    }
    
    deinit {
        
        XCGLogger.debug("deinit \(self)")
        
    }
}
