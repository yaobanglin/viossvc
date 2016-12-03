//
//  MyServerViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class MyServerViewController: BaseTableViewController {
    @IBOutlet weak var zhimaAnthIcon: UIImageView!
    @IBOutlet weak var idAuthIcon: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerContent: UIView!
    @IBOutlet weak var picAuthLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var serverTabel: ServerTableView!
    @IBOutlet weak var serverTabelCell: UITableViewCell!
    @IBOutlet weak var pictureCollection: UserPictureCollectionView!
    var markHeight: CGFloat = 100
    var serverHeight: CGFloat = 100
    var pictureHeight: CGFloat = 100
    var serverData: [UserServerModel] = []
    
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }
    //MARK: --DATA
    func initData() {
        //我的服务
        AppAPIHelper.userAPI().serviceList({ [weak self](result) in
            if result == nil {
                return
            }
            self?.serverData = result as! [UserServerModel]
            self?.serverTabel.updateData(result, complete: { (height) in
                self?.serverHeight = height as! CGFloat
                self?.tableView.reloadData()
            })
        }, error: errorBlockFunc())
        //我的相册
        pictureCollection.updateMyPicture(["","","","","","","",""]) {[weak self] (height) in
            self?.pictureHeight = height as! CGFloat
            self?.tableView.reloadData()
        }
    }
    //MARK: --UI
    func initUI() {
        
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            return markHeight
        }
        if indexPath.section == 2 && indexPath.row == 1{
            return serverHeight
        }
        if indexPath.section == 3 && indexPath.row == 1 {
            return pictureHeight
        }
        return 44
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SMSServerViewController.className() {
            let controller = segue.destinationViewController as! SMSServerViewController
            controller.serverData = serverData
        }
    }
    
}
