//
//  PasswordViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
import SVProgressHUD
class PasswordViewController: BaseLoginViewController {

    var childViewControllerData:RegisterModel!
    var registerModel:RegisterModel {
        get { return childViewControllerData }
    }
    @IBAction func didActionOk(sender: AnyObject) {
        MobClick.event(AppConst.Event.sign_confrim)
        if checkTextFieldEmpty([textField1,textField2]) {
            if textField1.text?.trim() == textField2.text?.trim()  {
                hideKeyboard()
                let tips = registerModel.smsType == SMSVerifyModel.SMSType.Register ? "注册..." : "重设密码..."
                showWithStatus(tips)
                registerModel.passwd = textField1.text?.trim()
                if textField3.text?.length() > 0 {
                    
                    registerModel.invitation_phone_num = textField3.text!.change32To10()                    
                }
                AppAPIHelper.userAPI().register(registerModel, complete: { [weak self] (resultInt) in
                    self?.didRegisterComplete(resultInt as! Int);
                    }, error: errorBlockFunc())
            }
            else {
                showErrorWithStatus(AppConst.Text.PasswordTwoErr);
            }
        }
    }
    
    func didRegisterComplete(resultInt:Int) {
        if registerModel.smsType == SMSVerifyModel.SMSType.Register
        && resultInt == 0 {
            
            SVProgressHUD.showErrorMessage(ErrorMessage: AppConst.Text.RegisterPhoneError, ForDuration: 1.5, completion: { [weak self] in
                self?.navigationController?.popViewControllerAnimated(true);
                
            })
        }
        else {
            userLogin(registerModel.phone_num,password: registerModel.passwd)
        }
    }
    
    override func didLoginComplete(userInfo:UserInfoModel?) {
        super.didLoginComplete(userInfo);
        if registerModel.smsType == SMSVerifyModel.SMSType.Register {
            let viewController:UINavigationController? = ((UIApplication.sharedApplication().keyWindow!.rootViewController as? UITabBarController)?.selectedViewController) as? UINavigationController
            viewController?.pushViewControllerWithIdentifier(NodifyUserInfoViewController.className(), animated: true,valuesForKeys:["title":"完善基本资料"])
        }
    }
}
