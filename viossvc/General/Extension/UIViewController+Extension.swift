//
//  UIViewController+Extension.swift
//  viossvc
//
//  Created by yaowang on 2016/10/31.
//  Copyright © 2016年 ywwlcom.yundian. All rights reserved.
//

import Foundation
import XCGLogger
import SVProgressHUD
import Qiniu
extension UIViewController {
    
    static func storyboardViewController<T:UIViewController>(storyboard:UIStoryboard) ->T {
        return storyboard.instantiateViewControllerWithIdentifier(T.className()) as! T;
    }
    
    func storyboardViewController<T:UIViewController>() ->T {
        return storyboard!.instantiateViewControllerWithIdentifier(T.className()) as! T;
    }
    
    
    func errorBlockFunc()->ErrorBlock {
        return { [weak self] (error) in
            XCGLogger.error("\(error) \(self)");
            self?.showErrorWithStatus(error.localizedDescription)
        }
    }
   
    func showErrorWithStatus(status: String!) {
        SVProgressHUD.showErrorWithStatus(status)
    }
    
    func showWithStatus(status: String!) {
        SVProgressHUD.showWithStatus(status)
    }
    
    //MARK: -Common function
    func checkTextFieldEmpty(array:[UITextField]) -> Bool {
        for  textField in array {
            if NSString.isEmpty(textField.text)  {
                showErrorWithStatus(textField.placeholder);
                return false
            }
        }
        return true
    }
    
    func qiniuUploadImage(image: UIImage, imageName: String, complete:CompleteBlock) {
        //0,将图片存到沙盒中
        let filePath = cacheImage(image, imageName: imageName)
        //1,请求token
        AppAPIHelper.commenAPI().imageToken({ (result) in
            let token = result?.valueForKey("img_token_") as! String
            //2,上传图片
            let qiniuManager = QNUploadManager()
            qiniuManager.putFile(filePath, key: imageName, token: token, complete: { (info, key, resp) in
                if resp == nil{
                    complete(nil)
                    return
                }
                //3,返回URL
                let respDic: NSDictionary? = resp
                let value:String? = respDic!.valueForKey("key") as? String
                let imageUrl = AppConst.Network.qiniuHost+value!
                complete(imageUrl)
            }, option: nil)
        }, error: errorBlockFunc())
    }
    
    func cacheImage(image: UIImage ,imageName: String) -> String {
        let data = UIImageJPEGRepresentation(image, 0.5)
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        do {
            try fileManager.createDirectoryAtPath(documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
        }
        let key = "\(imageName).png"
        fileManager.createFileAtPath(documentPath.stringByAppendingString(key), contents: data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, key)
        return filePath
    }
}