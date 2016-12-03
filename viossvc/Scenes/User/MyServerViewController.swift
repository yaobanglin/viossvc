//
//  MyServerViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class MyServerViewController: BaseTableViewController, LayoutStopDelegate {
    @IBOutlet weak var zhimaAnthIcon: UIImageView!
    @IBOutlet weak var idAuthIcon: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerContent: UIView!
    @IBOutlet weak var picAuthLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var skillView: SkillLayoutView!
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
        //我的标签
        AppAPIHelper.orderAPI().getSkills({[weak self] (response) in
            let array = response as? Array<SkillsModel>
            var skillDict: Dictionary<Int, AnyObject> = [:]
            for skill in array! {
                let size = skill.skill_name!.boundingRectWithSize(CGSizeMake(0, 21), font: UIFont.systemFontOfSize(15), lineSpacing: 0)
                skill.labelWidth = size.width + 30
                skillDict[skill.skill_id] = skill
            }
            
            AppAPIHelper.userAPI().getOrModfyUserSkills(0, skills: "", complete: { (response) in
                
                if response != nil {
                    let dict = response as! Dictionary<String, AnyObject>
                    CurrentUserHelper.shared.userInfo.skills = dict["skills_"] as? String
                    let skillArray = CurrentUserHelper.shared.userInfo.skills?.componentsSeparatedByString(",")
                    if  skillArray?.count == 0{
                        return
                    }
                    var skillModelArray: [SkillsModel] = []
                    for skillName in skillArray!{
                        if Int(skillName) > 0 {
                            let model = skillDict[Int(skillName)!] as! SkillsModel
                            skillModelArray.append(model)
                        }
                    }
                    self?.skillView.dataSouce = skillModelArray
                }
            }, error: (self?.errorBlockFunc())!)
          
        }, error: errorBlockFunc())
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
        skillView.delegate = self
        skillView.showDelete = false
        skillView.collectionView?.backgroundColor = UIColor(RGBHex: 0xf2f2f2)
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
    func layoutStopWithHeight(layoutView: SkillLayoutView, height: CGFloat) {
        markHeight = height
        tableView.reloadData()
    }
}
