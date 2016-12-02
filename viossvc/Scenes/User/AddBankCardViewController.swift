//
//  AddBankCardViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class AddBankCardViewController: BaseTableViewController, UITextFieldDelegate{
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var nameTextfiled: UITextField!
    @IBOutlet weak var bankNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    
    
    
    @IBAction func bindBankCard(sender: AnyObject) {
        
        if checkTextFieldEmpty([cardNumberTextfield,nameTextfiled,bankNameTextfield,phoneNumberTextfield]) {
            SVProgressHUD.showProgressMessage(ProgressMessage: "绑定中...")
            AppAPIHelper.userAPI().newBankCard([
                "uid_":CurrentUserHelper.shared.userInfo.uid,
                "account_": cardNumberTextfield.text!,
                "bank_username_":bankNameTextfield.text!,
                "bank_":1,
                "is_default_":0
                ], complete: { [weak self](response) in
                    SVProgressHUD.showSuccessMessage(SuccessMessage: "绑定成功", ForDuration: 1, completion: { 
                        self?.navigationController?.popViewControllerAnimated(true)
                    })
            }) { (error) in
                SVProgressHUD.showErrorMessage(ErrorMessage: error.localizedDescription, ForDuration: 1, completion: nil)
            }
        }
        
        
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
       
        if textField == cardNumberTextfield {
            if cardNumberTextfield.text?.characters.count > 0 {
                bankNameTextfield.text = String.bankCardName(cardNumberTextfield.text!) as String
  
            }
        }
        return true
    }
}
