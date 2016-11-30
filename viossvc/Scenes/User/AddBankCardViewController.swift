//
//  AddBankCardViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/27.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class AddBankCardViewController: BaseTableViewController, UITextFieldDelegate{
    @IBOutlet weak var cardNumberTextfield: UITextField!
    @IBOutlet weak var nameTextfiled: UITextField!
    @IBOutlet weak var bankNameTextfield: UITextField!

    @IBOutlet weak var phoneNumberTextfield: UITextField!
    
    
    
    
    @IBAction func bindBankCard(sender: AnyObject) {
        
        
        AppAPIHelper.userAPI().newBankCard(["uid_":CurrentUserHelper.shared.userInfo.uid,"account_": cardNumberTextfield.text!,"bank_username_":bankNameTextfield.text!,"bank_":1,"is_default_":0], complete: { (response) in
            
            
        }) { (error) in
            
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
