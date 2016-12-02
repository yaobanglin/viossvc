//
//  ServerSuccessController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ServerSuccessController: UIViewController {
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        iconImage.layer.cornerRadius = 40
        iconImage.layer.masksToBounds = true
        
        subTitleLabel.text = "我们会在一个工作日内通过审 \n核,审核完毕后我们会通过短 \n信进行通知"
        
        navigationItem.backBarButtonItem = nil
        navigationItem.hidesBackButton = true
    }
    
    @IBAction func finishItemTapped(sender: AnyObject) {
        navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
    }
}
