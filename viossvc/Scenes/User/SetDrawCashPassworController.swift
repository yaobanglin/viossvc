//
//  SetDrawCashPassworController.swift
//  viossvc
//
//  Created by 木柳 on 2016/11/29.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
class SetDrawCashPassworController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    
    var oldPassword: String?
    var clear: Bool = false
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        MobClick.event(AppConst.Event.drawcash_pwd)
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initUI()
    }
    //MARK: --UI
    func initUI() {
        title = CurrentUserHelper.shared.userInfo.has_passwd_ == -1 ? "设置提现密码" : "修改提现密码"
        //titleLabel
        titleLabel.text = CurrentUserHelper.shared.userInfo.has_passwd_ == -1 ? "设置提现密码" : "请输入旧的提现密码"
        //passwordView
        passwordView.layer.cornerRadius = 6
        passwordView.layer.masksToBounds = true
        passwordView.layer.borderColor = UIColor.blackColor().CGColor
        passwordView.layer.borderWidth = 0.5
        for view in passwordView.subviews {
            let btn: UIButton = view as! UIButton
            btn.layer.borderColor = UIColor(RGBHex: 0xf2f2f2).CGColor
            btn.layer.borderWidth = 0.5
        }
        //passwordText
        passwordText.returnKeyType = .Done
        passwordText.becomeFirstResponder()
    }
    func updatePasswordView(password: String) {
        for view in passwordView.subviews {
            let btn: UIButton = view as! UIButton
            btn.selected = btn.tag - 100 < password.characters.count
        }
        
        if password.characters.count < 6 || password.characters.count > 6{
            return
        }
        
        let setPassword = {(sucessMsg: String, complete: CompleteBlock?) in
            //设置密码接口
            SVProgressHUD.showProgressMessage(ProgressMessage: "")
            let type = CurrentUserHelper.shared.userInfo.has_passwd_ == -1 ? 0 : 1
            let param = DrawCashPasswordModel()
            param.uid = CurrentUserHelper.shared.userInfo.uid
            param.new_passwd = password
            param.old_passwd = self.oldPassword
            param.passwd_type = 1
            param.change_type = type
            
            AppAPIHelper.userAPI().drawcashPassword(param, complete: {[weak self] (result) in
                CurrentUserHelper.shared.userInfo.has_passwd_ = 1
                SVProgressHUD.showSuccessMessage(SuccessMessage: sucessMsg, ForDuration: 1, completion: nil)
                if let completeBlock: CompleteBlock = complete{
                    completeBlock("")
                }else{
                    self?.navigationController?.popViewControllerAnimated(true)
                }
            }, error: self.errorBlockFunc())
        }
        
        if CurrentUserHelper.shared.userInfo.has_passwd_ == -1 {
            //第一步->确认密码
            if oldPassword == nil {
                titleLabel.text = "再次输入，确认提现密码"
                oldPassword = password
                clear = true
                updatePasswordView("")
                return
            }
            //第二步->设置密码
            if oldPassword != password {
                SVProgressHUD.showErrorMessage(ErrorMessage: "两个密码不一致，请重新输入", ForDuration: 1, completion: nil)
                oldPassword = nil
                clear = true
                updatePasswordView("")
                titleLabel.text = "设置提现密码"
                return
            }
            setPassword("密码设置成功", nil)
            return
        }else{
            //第一步->验证旧密码
            if oldPassword == nil {
                AppAPIHelper.userAPI().checkDrawCashPassword(CurrentUserHelper.shared.uid, password: password, type: 1, complete: {[weak self] (result) in
                    SVProgressHUD.showSuccessMessage(SuccessMessage: "验证成功", ForDuration: 1, completion: nil)
                    self?.titleLabel.text = "重新设置提现密码"
                    self?.oldPassword = password
                    self?.clear = true
                    self?.updatePasswordView("")
                    return
                }, error: errorBlockFunc())
                return
            }
           
            //第二步->重置密码
            setPassword("重设密码成功", nil)
        }
        
    }
    

    //MARK: --Textfield
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if clear {
            textField.text = ""
            updatePasswordView(string)
            clear = false
            return true
        }
        
        let resultText = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
        updatePasswordView(resultText)
        return true
    }}
