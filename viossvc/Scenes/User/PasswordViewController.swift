//
//  PasswordViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/10/27.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation

class PasswordViewController: BaseLoginViewController {

    var childViewControllerData:RegisterModel!
    var registerModel:RegisterModel {
        get { return childViewControllerData }
    }
    @IBAction func didActionOk(sender: AnyObject) {
        if checkTextFieldEmpty([textField1,textField2]) {
            if textField1.text == textField2.text  {
                hideKeyboard()
                let tips = registerModel.smsType == SMSVerifyModel.SMSType.Register ? "注册..." : "重设密码..."
                showWithStatus(tips)
                registerModel.passwd = textField1.text
                AppAPIHelper.userAPI().register(childViewControllerData, complete: { [weak self] (dict) in
                    self?.didRegisterComplete(dict as? Dictionary<String,AnyObject> );
                    }, error: errorBlockFunc())
            }
            else {
                showErrorWithStatus(AppConst.Text.PasswordTwoErr);
            }
        }
    }
    
    func didRegisterComplete(dict:Dictionary<String,AnyObject>!) {
        let result:Int! = dict["result"] as? Int
        if registerModel.smsType == SMSVerifyModel.SMSType.Register
        && result == 0 {
            showErrorWithStatus(AppConst.Text.RegisterPhoneError)
            let delta = 1.5 * Double(NSEC_PER_SEC)
            let dtime = dispatch_time(DISPATCH_TIME_NOW, Int64(delta))
            dispatch_after(dtime, dispatch_get_main_queue(), { [weak self] in
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
