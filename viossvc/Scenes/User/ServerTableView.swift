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
}

class ServerTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var serverData: [UserServerModel] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        delegate = self
        dataSource = self
        scrollEnabled = false
    }
    
    //MARK: --delegate and datasource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 21//serverData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ServerCell = tableView.dequeueReusableCellWithIdentifier(ServerCell.className()) as! ServerCell
//        let model = serverData[indexPath.row]
        cell.serverNameLabel.text = indexPath.row/2==0 ? "asjdhagskdjs这是一个测试" : "这是一个测试"//model.service_name
        cell.serverPriceLabel.text = "￥10000.00"//"￥\(Double(model.service_price)/100)"
        cell.serverTimeLabel.text = "12:00-24:00"//"\(time(model.service_start))--\(time(model.service_end))"
        cell.upLine.hidden = indexPath.row == 0
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
