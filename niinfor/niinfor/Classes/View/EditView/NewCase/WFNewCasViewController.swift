//
//  WFNewCasViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/28.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFNewCasViewController: BaseViewController {

    var tableView  = WFMoveCellTableView.init(frame: CGRect.init(x: 0, y: 64, width: Screen_width, height: Screen_height - 64), style: .plain)
    
    var dataSource  =  ["sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "sjslfsjflsjlf",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        "kfaljflajfll😁😁",
                        
                        ]

    
}

extension WFNewCasViewController{
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "创建病例"
        
        removeTabelView()
        
        view.addSubview(self.tableView)
        
        setTableView()
        
//        for item  in mainDataSouce {
//            base_dataList.append(item as AnyObject)
//        }
        
//        tableView.insertSubview(funcChooseView, at: 0)
    }

}

extension WFNewCasViewController : MoveCellDataSource,MoveCellDelegate {
    func returnDataSource(_ array: [AnyObject]) {
        mainDataSouce = array as! [CaseDetailModel]
    }
    
    func dataSource(inTableView tableView: WFMoveCellTableView) -> [AnyObject] {
        return dataSource as [AnyObject]
    }
    
    func tableView(_ tableView: WFMoveCellTableView, customizeStartMovingAnimationWithimage image: UIImageView, fingerPoint point: CGPoint) {
        UIView.animate(withDuration: 0.25) {
            image.center = CGPoint.init(x: image.center.x, y: point.y)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = dataSource[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func setTableView() {
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = nil
        tableView.tableHeaderView = nil
        tableView.delegatet = self
        tableView.dataSourcee = self
        tableView.dataSource = self
        tableView.delegate = self
     }
    
    
}






