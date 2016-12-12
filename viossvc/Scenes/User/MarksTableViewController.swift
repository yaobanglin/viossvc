//
//  MarksTableViewController.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//  Code By BB


import UIKit
import SVProgressHUD
protocol RefreshSkillDelegate: NSObjectProtocol {
    func refreshUserSkill()
}

class MarksTableViewController: BaseTableViewController , LayoutStopDelegate{

    @IBOutlet weak var selectSkillView: SkillLayoutView!
    
    @IBOutlet weak var allSkillView: SkillLayoutView!
    
    var selectHeight:CGFloat = 55.0
    var allSkillsHeight:CGFloat = 55.0
    
    var currentSkillsArray:Array<SkillsModel>?
    var allSkillArray:Array<SkillsModel>?
    var skillDict:Dictionary<Int, SkillsModel> = [:]
    var delegate:RefreshSkillDelegate?
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
    
        selectSkillView.delegate = self
        allSkillView.delegate = self
        
        submitButton.enabled = false
        setData()
        MobClick.event(AppConst.Event.server_mark)
    }
    func setData() {
        guard  currentSkillsArray == nil else {
            selectSkillView.showDelete = true
            selectSkillView.dataSouce = currentSkillsArray
            allSkillView.dataSouce = allSkillArray
            return
        }
        getAllSkills()
        getUserSkills()

    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.row == 1 {
            return selectHeight
        } else if indexPath.row == 3 {
            return allSkillsHeight
        }
        
        return 45
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
            weakSelf.allSkillView.dataSouce = weakSelf.allSkillArray
            if CurrentUserHelper.shared.userInfo.skills != nil {
                weakSelf.currentSkillsArray =   AppAPIHelper.orderAPI().getSKillsWithModel(CurrentUserHelper.shared.userInfo.skills, dict:weakSelf.skillDict )
                weakSelf.selectSkillView.dataSouce = weakSelf.currentSkillsArray
                
                
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
                    weakSelf.selectSkillView.showDelete = true
                    weakSelf.selectSkillView.dataSouce = weakSelf.currentSkillsArray
                }
            }
            }, error: errorBlockFunc())
    }
    
    /**
     高度回调
     
     - parameter layoutView: 回调的layoutView
     - parameter height:     高度
     */
    func layoutStopWithHeight(layoutView: SkillLayoutView, height: CGFloat) {
        if layoutView == selectSkillView {
            guard height > 50 else {return}
            selectHeight = height
        } else {
            allSkillsHeight = height
        }
        tableView.reloadData()
    }
    
    /**
     点击回调
     
     - parameter layoutView: 点所在的layouView
     - parameter indexPath:  indexPath
     */
    func selectedAtIndexPath(layoutView:SkillLayoutView, indexPath:NSIndexPath) {
        

        
        if layoutView == selectSkillView {
          

            guard currentSkillsArray?.count > 0 else {return}
            currentSkillsArray?.removeAtIndex(indexPath.item)

        } else {
            
            guard currentSkillsArray?.count != 8 else {
                SVProgressHUD.showWainningMessage(WainningMessage: "不能选择更多标签", ForDuration: 1.5, completion: nil)
                return
            }
            let skill = allSkillArray![indexPath.item]
            if currentSkillsArray == nil {
                currentSkillsArray = []
            }
            guard !currentSkillsArray!.contains(skill) else {
                SVProgressHUD.showWainningMessage(WainningMessage: "您已经选择过此标签", ForDuration: 1.5, completion: nil)
                return
            }
            currentSkillsArray?.append(allSkillArray![indexPath.item])
            
        }
        submitButton.enabled = true
        submitButton.backgroundColor = UIColor.init(hexString: "131F32")
        selectSkillView.showDelete = true
        selectSkillView.dataSouce = currentSkillsArray
    }
    
    @IBAction func modfySkills(sender: AnyObject) {
        
        var idString = ""
        for skill in currentSkillsArray! {
            
            if skill.skill_id != 0 {
                idString = idString + "\(skill.skill_id),"
            }
            
        }
        
        unowned let weakSelf = self
        AppAPIHelper.userAPI().getOrModfyUserSkills(1, skills: idString, complete: { (response) in
            
            if response != nil {
                let dict = response as! Dictionary<String, AnyObject>
                CurrentUserHelper.shared.userInfo.skills = dict["skills_"] as? String
                if weakSelf.delegate != nil {
                    weakSelf.delegate?.refreshUserSkill()
                }
                weakSelf.navigationController?.popViewControllerAnimated(true)
            }
            }, error: errorBlockFunc())
    }
    
}
