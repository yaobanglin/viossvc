//
//  ServerTableView.swift
//  viossvc
//
//  Created by 木柳 on 2016/12/2.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit

class ServerCell: UITableViewCell {
    @IBOutlet weak var upLine: UIView!
    @IBOutlet weak var serverNameLabel: UILabel!
    @IBOutlet weak var serverTimeLabel: UILabel!
    @IBOutlet weak var serverPriceLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        var upview = contentView.viewWithTag(1000)
        if upview == nil {
            upview = UIView()
            upview?.tag = 1000
            upview?.backgroundColor = UIColor.grayColor()
            contentView.addSubview(upview!)
            upview?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(contentView).offset(10)
                make.right.equalTo(contentView).offset(-10)
                make.top.equalTo(contentView)
                make.height.equalTo(0.5)
            })
        }
        var timeLab = contentView.viewWithTag(1001) as? UILabel
        if timeLab == nil {
            timeLab = UILabel()
            timeLab?.tag = 1001
            timeLab?.font = UIFont.systemFontOfSize(13.0)
            contentView.addSubview(timeLab!)
            timeLab?.snp_makeConstraints(closure: { (make) in
                make.top.equalTo(contentView).offset(5)
                make.bottom.equalTo(contentView).offset(-5)
                make.centerX.equalTo(contentView)
                make.width.equalTo(80)
            })
        }
        
        var nameLab = contentView.viewWithTag(1002) as? UILabel
        if nameLab == nil {
            nameLab = UILabel()
            nameLab?.tag = 1002
            //            nameLab?.numberOfLines = 0
            //            nameLab?.lineBreakMode = .ByWordWrapping
            nameLab?.font = UIFont.systemFontOfSize(13.0)
            contentView.addSubview(nameLab!)
            nameLab?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(contentView).offset(10)
                make.top.equalTo(contentView).offset(5)
                make.bottom.equalTo(contentView).offset(-5)
                make.right.equalTo(timeLab!.snp_left).offset(-10)
            })
        }
        
        var priceLab = contentView.viewWithTag(1003) as? UILabel
        if priceLab == nil {
            priceLab = UILabel()
            priceLab?.tag = 1003
            priceLab?.textAlignment = .Right
            priceLab?.font = UIFont.systemFontOfSize(13.0)
            contentView.addSubview(priceLab!)
            priceLab?.snp_makeConstraints(closure: { (make) in
                make.left.equalTo(timeLab!.snp_right).offset(10)
                make.top.equalTo(contentView).offset(5)
                make.bottom.equalTo(contentView).offset(-5)
                make.right.equalTo(contentView).offset(-10)
            })
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ServerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var serverData: [UserServerModel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Nib 注册
        self.registerNib(UINib(nibName: "serviceCell", bundle: nil), forCellReuseIdentifier: "ServerCell")
        // Class 注册
        self.registerClass(ServerCell.self, forCellReuseIdentifier: ServerCell.className())
        delegate = self
        dataSource = self
        scrollEnabled = false
    }
    
    //MARK: --delegate and datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return serverData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ServerCell = tableView.dequeueReusableCellWithIdentifier(ServerCell.className()) as! ServerCell
        let model = serverData[indexPath.row]
        let serverNameLabel = cell.contentView.viewWithTag(1002) as? UILabel
        serverNameLabel?.text = model.service_name
        let serverPriceLabel = cell.contentView.viewWithTag(1003) as? UILabel
        serverPriceLabel?.text = "￥\(Double(model.service_price)/100)"
        let serverTimeLabel = cell.contentView.viewWithTag(1001) as? UILabel
        serverTimeLabel?.text = "\(time(model.service_start))--\(time(model.service_end))"
        let upLine = cell.contentView.viewWithTag(1000)
        upLine?.hidden = indexPath.row == 0
//        cell.serverNameLabel.text = model.service_name
//        cell.serverPriceLabel.text = "￥\(Double(model.service_price)/100)"
//        cell.serverTimeLabel.text = "\(time(model.service_start))--\(time(model.service_end))"
//        cell.upLine.hidden = indexPath.row == 0
        return cell
    }
    func time(minus: Int) -> String {
        let hour = minus / 60
        let leftMinus = minus % 60
        return String(format: "%02d:%02d", hour, leftMinus) //"\(hourStr):\(minusStr)"
//        let hourStr = hour > 9 ? "\(hour)" : "0\(hour)"
//        let minusStr = leftMinus > 9 ? "\(minus)" : "0\(leftMinus)"
//        return "\(hourStr):\(minusStr)"
    }
    func updateData(data: AnyObject!, complete:CompleteBlock) {
        serverData = data as! [UserServerModel]
        reloadData()
        complete(contentSize.height > 0 ? contentSize.height+20 : 0)
    }
    
}
