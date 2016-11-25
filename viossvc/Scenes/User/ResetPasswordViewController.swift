//
//  ResetPasswordViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ResetPasswordViewController: BaseTableViewController {
    
    @IBOutlet weak var oldPasswordText: UITextField!
    @IBOutlet weak var newPasswordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var resetBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func resetPasswordBtnTapped(sender: UIButton) {
        if checkTextFieldEmpty([oldPasswordText,newPasswordText]) {
            if newPasswordText.text == confirmPasswordText.text  {
                hideKeyboard()
                AppAPIHelper.userAPI().nodifyPasswrod(CurrentUserHelper.shared.userInfo.uid, oldPassword: oldPasswordText.text!, newPasword: newPasswordText.text!, complete: { [weak self](model) in
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
        showWithStatus("设置成功")
       navigationController?.popViewControllerAnimated(true)
    }
}
