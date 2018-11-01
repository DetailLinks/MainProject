//
//  WFMyOrderController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMyOrderController: BaseViewController {

    
    @IBOutlet weak var tableView: UITableView!
    

}

///设置界面
extension WFMyOrderController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "我的订单"
        
        tableView.register(UINib.init(nibName: WFOrderTableViewCell().identfy, bundle: nil), forCellReuseIdentifier: WFOrderTableViewCell().identfy)
    }
}

// MARK: - tableView的数据源和代理方法
extension WFMyOrderController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: WFOrderTableViewCell().identfy, for: indexPath) as? WFOrderTableViewCell
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 34
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let contentView  = UIView(frame: CGRect(x: 0,
                                                                              y: 0,
                                                                              width: Screen_width,
                                                                              height: 34))
        
        contentView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        let label  = UILabel(frame: CGRect(x: 10,
                                                                   y: 0,
                                                                   width: Screen_width - 10,
                                                                    height: 34))
        
        label.text = "已付订单"
        label.font = UIFont(name: PF_R, size: 15)
        
        contentView.addSubview(label)
        
        return contentView
    }
}
