//
//  UserInfoEditViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD

class NodifyUserInfoViewController: BaseTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    var imageUrl: String?
    var haveChangeImage: Bool = false
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController.init()
        return picker
    }()
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        if (CurrentUserHelper.shared.userInfo.head_url != nil){
            let headUrl = NSURL.init(string: CurrentUserHelper.shared.userInfo.head_url!)
            iconImage.kf_setImageWithURL(headUrl, placeholderImage: UIImage.init(named: "head_boy"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if CurrentUserHelper.shared.userInfo.nickname != nil {
            nameText.text = CurrentUserHelper.shared.userInfo.nickname
        }
        
        if CurrentUserHelper.shared.userInfo.address != nil {
            cityLabel.text = CurrentUserHelper.shared.userInfo.address
        }
        
        sexLabel.text = CurrentUserHelper.shared.userInfo.gender == 1 ? "男" : "女"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker.delegate = self
    }
    //MARK: --上传头像
    @IBAction func finishItemTapped(sender: AnyObject) {
        let sex = sexLabel.text == "男" ? 1 : 0
        if CurrentUserHelper.shared.userInfo.nickname == nameText.text &&
            CurrentUserHelper.shared.userInfo.address == cityLabel.text && CurrentUserHelper.shared.userInfo.gender == sex &&
            haveChangeImage == false{
            SVProgressHUD.showWainningMessage(WainningMessage: "未做任何修改", ForDuration: 1, completion: nil)
            return
        }
        
        if haveChangeImage && imageUrl == nil  {
            showErrorWithStatus("头像上传失败，请稍后再试")
            return
        }
        if nameText.text?.characters.count == 0 {
            showErrorWithStatus("请输入用户昵称")
            return
        }
        let param = NotifyUserInfoModel()
        param.address = cityLabel.text
        param.gender = sexLabel.text == "男" ? 1 : 0
        if iconImage.image != UIImage.init(named: "head_boy") {
            param.head_url = imageUrl
        }
        param.nickname = nameText.text
        param.uid = CurrentUserHelper.shared.userInfo.uid
        AppAPIHelper.userAPI().notifyUsrInfo(param, complete: {[weak self] (result) in
            CurrentUserHelper.shared.userInfo.address = self?.cityLabel.text
            CurrentUserHelper.shared.userInfo.nickname = self?.nameText.text
            CurrentUserHelper.shared.userInfo.gender = self?.sexLabel.text == "男" ? 1 : 0
            self?.navigationController?.popViewControllerAnimated(true)
        }, error: errorBlockFunc())
    }
    //MARK: --常住地选择
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == CitysSelectViewController.className() {
            let controller: CitysSelectViewController = segue.destinationViewController as! CitysSelectViewController
            controller.cityName = cityLabel.text
            controller.selectCity =  { [weak self](cityName) in
                self?.cityLabel.text = cityName
            }
            return
        }
    }
    //MARK: --TABLEVIEW
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 1 || indexPath.row == 3 {
            return
        }
        
        let title = indexPath.row == 0 ? "头像" : "性别"
        let firstActionTitle = indexPath.row == 0 ? "照相机":"男"
        let secondActionTitle = indexPath.row == 0 ? "相册":"女"
        let alterController: UIAlertController = UIAlertController.init(title: title, message: nil, preferredStyle: .ActionSheet)
        let alterActionFirst: UIAlertAction = UIAlertAction.init(title: firstActionTitle, style: .Default) { [weak self](action) in
            if indexPath.row != 0{
                self?.sexLabel.text = firstActionTitle
                return
            }
            self?.imagePicker.sourceType = .Camera
            self?.presentViewController((self?.imagePicker)!, animated: true, completion: nil)
        }
        let alterActionSecond: UIAlertAction = UIAlertAction.init(title: secondActionTitle, style: .Default) { [weak self](action) in
            if indexPath.row != 0{
                self?.sexLabel.text = secondActionTitle
                return
            }
            self?.imagePicker.sourceType = .PhotoLibrary
            self?.presentViewController((self?.imagePicker)!, animated: true, completion: nil)
        }
        
        let alterActionCancel: UIAlertAction = UIAlertAction.init(title: "取消", style: .Cancel, handler: nil)
        
        alterController.addAction(alterActionFirst)
        alterController.addAction(alterActionSecond)
        alterController.addAction(alterActionCancel)
        presentViewController(alterController, animated: true, completion: nil)
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        haveChangeImage = true
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        iconImage.image = image
        qiniuUploadImage(image, imageName: "\(CurrentUserHelper.shared.userInfo.uid)", complete: { [weak self](imageUrl) in
            if imageUrl == nil || imageUrl?.length == 0 {
                SVProgressHUD.showErrorMessage(ErrorMessage: "头像上传失败，请稍后再试", ForDuration: 1, completion: nil)
                if (CurrentUserHelper.shared.userInfo.head_url != nil){
                    let headUrl = NSURL.init(string: CurrentUserHelper.shared.userInfo.head_url!)
                    self?.iconImage.kf_setImageWithURL(headUrl, placeholderImage: UIImage.init(named: "head_boy"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
                }
                return
            }
            self?.imageUrl = imageUrl as? String
            AppAPIHelper.userAPI().authHeaderUrl(CurrentUserHelper.shared.userInfo.uid, head_url_: (self?.imageUrl)! , complete: { (result) in
                
                }, error: self!.errorBlockFunc())
        })
    }
    
}
