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
        //先把图片转成NSData
        let data = UIImageJPEGRepresentation(image, 0.5)
        //Home目录
        let homeDirectory = NSHomeDirectory()
        let documentPath = homeDirectory + "/Documents"
        //文件管理器
        let fileManager: NSFileManager = NSFileManager.defaultManager()
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        do {
            try fileManager.createDirectoryAtPath(documentPath, withIntermediateDirectories: true, attributes: nil)
        }
        catch _ {
        }
        //let timestemp:Int = Int(NSDate().timeIntervalSince1970)
        let key = "\(imageName).png"
        fileManager.createFileAtPath(documentPath.stringByAppendingString(key), contents: data, attributes: nil)
        //得到选择后沙盒中图片的完整路径
        let filePath: String = String(format: "%@%@", documentPath, key)
        //1,请求token
        AppAPIHelper.commenAPI().imageToken({ (result) in
            let token = result?.valueForKey("img_token_") as! String
            //2,上传图片
            let qiniuManager = QNUploadManager()
            qiniuManager.putFile(filePath, key: imageName, token: token, complete: { (info, key, resp) in
                //3,返回URL
                let respDic: NSDictionary? = resp
                let value:String? = respDic!.valueForKey("key") as? String
                let imageUrl = AppConst.Network.qiniuHost+value!
                complete(imageUrl)
            }, option: nil)
        }, error: errorBlockFunc())
        
    }
}