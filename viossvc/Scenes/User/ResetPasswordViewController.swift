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
                AppAPIHelper.userAPI().nodifyPasswrod(Curren, oldPassword: oldPasswordText.text, newPasword: newPasswordText.text, complete: { [weak self](model) in
                    <#code#>
                    }, error: <#T##ErrorBlock##ErrorBlock##(NSError) -> ()#>)
            }
            else {
                showErrorWithStatus(AppConst.Text.PasswordTwoErr);
            }
        }
    }
    
    
    func didResetPasswordComplete(dict:Dictionary<String,AnyObject>!) {
       
    }
}
