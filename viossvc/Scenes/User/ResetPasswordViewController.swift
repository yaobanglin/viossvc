//
//  ResetPasswordViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class ResetPasswordViewController: BaseTableViewController {
    
    @IBOutlet weak var oldPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    var newPassword:String?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    @IBAction func resetPasswordBtnTapped(sender: UIButton) {
        if checkTextFieldEmpty([oldPasswordText,newPasswordText]) {
            if newPasswordText.text!.trim() == confirmPasswordText.text!.trim()  {
                hideKeyboard()
                SVProgressHUD.showWithStatus("密码重置中...")
                newPassword = newPasswordText.text!.trim()
                AppAPIHelper.userAPI().nodifyPasswrod(CurrentUserHelper.shared.userInfo.uid, oldPassword: oldPasswordText.text!.trim(), newPasword: newPassword!, complete: { [weak self](model) in
                    if let strongSelf = self {
                        let modelDic = model as? Dictionary<String, AnyObject>
                        strongSelf.didResetPasswordComplete(modelDic)
                    }
                    }, error: errorBlockFunc())
            }
            else {
                showErrorWithStatus(AppConst.Text.PasswordTwoErr);
            }
        }
    }
    
    
    func didResetPasswordComplete(dict:Dictionary<String,AnyObject>!) {
        CurrentUserHelper.shared.nodifyPassword(newPassword!)
        SVProgressHUD.showSuccessWithStatus("重置成功")
        navigationController?.popViewControllerAnimated(true)
    }
}
