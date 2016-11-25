//
//  UserInfoEditViewController.swift
//  viossvc
//
//  Created by yaowang on 2016/11/23.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class NodifyUserInfoViewController: BaseTableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var iconImage: UIImageView!
    
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController.init()
        return picker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        imagePicker.delegate = self
    }
    
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
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        iconImage.image = image
    }
    
}
