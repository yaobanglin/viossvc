//
//  MyServerViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/1.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class MyServerViewController: BaseTableViewController, LayoutStopDelegate, RefreshSkillDelegate{
    @IBOutlet weak var zhimaAnthIcon: UIImageView!
    @IBOutlet weak var idAuthIcon: UIImageView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var headerContent: UIView!
    @IBOutlet weak var picAuthLabel: UILabel!
    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var serverTabel: ServerTableView!
    @IBOutlet weak var serverTabelCell: UITableViewCell!
    @IBOutlet weak var skillView: SkillLayoutView!
    var currentSkillsArray:Array<SkillsModel>?
    var allSkillArray:Array<SkillsModel>?
    var skillDict:Dictionary<Int, SkillsModel> = [:]
    @IBOutlet weak var pictureCollection: UserPictureCollectionView!
    var markHeight: CGFloat = 100
    var serverHeight: CGFloat = 100
    var pictureHeight: CGFloat = 100
    var serverData: [UserServerModel] = []
    
    
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getUserSkills()
        getAllSkills()
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
    
    
    func getUserSkills() {
        
        unowned let weakSelf = self
        AppAPIHelper.userAPI().getOrModfyUserSkills(0, skills: "", complete: { (response) in
            
            if response != nil {
                let dict = response as! Dictionary<String, AnyObject>
                CurrentUserHelper.shared.userInfo.skills = dict["skills_"] as? String
                if weakSelf.skillDict.count  > 0 {
                    weakSelf.currentSkillsArray = AppAPIHelper.orderAPI().getSKillsWithModel(CurrentUserHelper.shared.userInfo.skills, dict:weakSelf.skillDict )
                    weakSelf.skillView.dataSouce = weakSelf.currentSkillsArray
                }
            }
        }) { (error) in
            
        }
    }
    func getAllSkills() {
        
        
        unowned let weakSelf = self
        AppAPIHelper.orderAPI().getSkills({ (response) in
            let array = response as? Array<SkillsModel>
            weakSelf.allSkillArray = array
            for skill in array! {
                let size = skill.skill_name!.boundingRectWithSize(CGSizeMake(0, 21), font: UIFont.systemFontOfSize(15), lineSpacing: 0)
                skill.labelWidth = size.width + 30
                
                weakSelf.skillDict[skill.skill_id] = skill
            }
            if CurrentUserHelper.shared.userInfo.skills != nil {
                weakSelf.currentSkillsArray =   AppAPIHelper.orderAPI().getSKillsWithModel(CurrentUserHelper.shared.userInfo.skills, dict:weakSelf.skillDict )
                weakSelf.skillView.dataSouce = weakSelf.currentSkillsArray
                
                
            }
        }) { (error) in
        }
    }
    //MARK: --UI
    func initUI() {
        skillView.delegate = self
        
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
        } else if segue.identifier == MarksTableViewController.className() {
            let marksVC = segue.destinationViewController as! MarksTableViewController
            marksVC.allSkillArray = allSkillArray
            marksVC.currentSkillsArray = currentSkillsArray
            marksVC.skillDict = skillDict
            marksVC.delegate =  self
        }
    }
    
    
    func refreshUserSkill() {
    
        currentSkillsArray = AppAPIHelper.orderAPI().getSKillsWithModel(CurrentUserHelper.shared.userInfo.skills, dict:skillDict )
        skillView.dataSouce = currentSkillsArray
        
    }

    
    /**
     skillView 高度回调
     
     - parameter layoutView:
     - parameter height:
     */
    func layoutStopWithHeight(layoutView: SkillLayoutView, height: CGFloat) {
        
        markHeight = height
        print(height)
        tableView.reloadData()
//        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
    }
    
}


