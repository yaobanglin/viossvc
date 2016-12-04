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
    @IBOutlet weak var skillView: SkillLayoutView!
    @IBOutlet weak var serverTabel: ServerTableView!
    @IBOutlet weak var serverTabelCell: UITableViewCell!
    var currentSkillsArray:Array<SkillsModel>?
    var allSkillArray:Array<SkillsModel>?
    var skillDict:Dictionary<Int, SkillsModel> = [:]
    @IBOutlet weak var pictureCollection: UserPictureCollectionView!
    var markHeight: CGFloat = 0
    var serverHeight: CGFloat = 0
    var pictureHeight: CGFloat = 0
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
        //我的技能标签
        getUserSkills()
        getAllSkills()
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
        let requestModel = PhotoWallRequestModel()
        requestModel.uid = CurrentUserHelper.shared.userInfo.uid
        requestModel.size = 12
        requestModel.num = 1
        AppAPIHelper.userAPI().photoWallRequest(requestModel, complete: {[weak self] (result) in
            if result == nil{
                return
            }
            let model: PhotoWallModoel = result as! PhotoWallModoel
            self?.pictureCollection.updateMyPicture(model.photo_list) {[weak self] (height) in
                self?.pictureHeight = height as! CGFloat
                self?.tableView.reloadData()
            }
        }, error: errorBlockFunc())
        
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
        }, error: errorBlockFunc())
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
        }, error: errorBlockFunc())
    }
    //MARK: --UI
    func initUI() {
        
        headerImage.layer.cornerRadius = headerImage.frame.size.width * 0.5
        headerImage.layer.masksToBounds = true
        headerImage.layer.borderColor = UIColor(RGBHex: 0xb82624).CGColor
        headerImage.layer.borderWidth = 2
        
        skillView.showDelete = false
        skillView.collectionView?.backgroundColor = UIColor(RGBHex: 0xf2f2f2)
        skillView.delegate = self
        //headerView
        if (CurrentUserHelper.shared.userInfo.head_url != nil){
            let headUrl = NSURL.init(string: CurrentUserHelper.shared.userInfo.head_url!)
            headerImage.kf_setImageWithURL(headUrl, placeholderImage: UIImage.init(named: "head_boy"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
        
        if CurrentUserHelper.shared.userInfo.praise_lv > 0 {
            for i in 100...104 {
                if i <= 100 + CurrentUserHelper.shared.userInfo.praise_lv {
                    let starImage: UIImageView = headerContent.viewWithTag(i) as! UIImageView
                    starImage.image = UIImage.init(named: "star-common-fill")
                }
            }
        }
        
        idAuthIcon.hidden = !(CurrentUserHelper.shared.userInfo.auth_status_ == 1)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 215
        }
        if indexPath.section == 1 && indexPath.row == 1 {
            return markHeight
        }
        if indexPath.section == 2 && indexPath.row == 1 {
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
        tableView.reloadData()
    }
}


