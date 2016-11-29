//
//  EnterPasswordViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/26.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import  UIKit



class EnterPasswordViewController: UIViewController,UITextFieldDelegate {
    //MARK: --属性
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var contentView: UIView!
    typealias enterPasswordBlock = (password: String)->Void
    var Password = enterPasswordBlock?()
    
    //MARK: --lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    
    //MARK: --View
    func initView() {
        modalPresentationStyle = .Custom
        contentView.layer.cornerRadius = 6
        
        passwordView.layer.cornerRadius = 6
        passwordView.layer.masksToBounds = true
        passwordView.layer.borderColor = UIColor.blackColor().CGColor
        passwordView.layer.borderWidth = 0.5
        for view in passwordView.subviews {
            let btn: UIButton = view as! UIButton
            btn.layer.borderColor = UIColor(RGBHex: 0xf2f2f2).CGColor
            btn.layer.borderWidth = 0.5
        }
        
        passwordText.returnKeyType = .Done
        passwordText.becomeFirstResponder()
    }
    
    //MARK: --Data
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        dismissController()
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let resultText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        updatePasswordView(resultText)
        return true
    }
    func updatePasswordView(password: String) {
        for view in passwordView.subviews {
            let btn: UIButton = view as! UIButton
            btn.selected = btn.tag - 100 < password.characters.count
        }
        
        if password.characters.count == 6 && Password != nil{
            Password!(password: password)
            dismissController()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        super.touchesBegan(touches, withEvent: event)
        dismissController()
    }
}
