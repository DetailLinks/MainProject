//
//  WFMessageViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMessageViewController: BaseViewController {

     var titpLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: NSNotification.Name(rawValue: notifi_mymessage_reload), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteModelData), name: NSNotification.Name(rawValue: notifi_mymessage_deleteBtn_click), object: nil)
    }
    
        deinit {
           NotificationCenter.default.removeObserver(self)
       }
    
      @objc private func deleteModelData(_ notifi : Notification){
        
        if  let cell  = notifi.object as? WFMessageCell{
        
        let index = baseTableView.indexPath(for: cell)
        
              userList.remove(at: index?.row ?? 0)
              let delegate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
              delegate.saveData()

              self.base_dataList = userList
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(title)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(title)
    }}

///设置界面
extension WFMessageViewController{
    
    override func setUpUI() {
        super.setUpUI()
    
        navItem.title = "我的消息"
        
        baseTableView.frame = CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height - navigation_height)
        
        regestNibCellString(WFMessageCell().identfy)
        
        titpLabel = UILabel(frame: view.frame)
        titpLabel.text = "暂无消息"
        titpLabel.textAlignment = .center
        
        view.addSubview(titpLabel)
    }
    
    override func loadData() {
    
        base_dataList = userList
        titpLabel.isHidden = userList.count != 0
    }
}

extension WFMessageViewController{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = WFMessageDetailController()
        
        vc.contentString = userList[indexPath.row].content ?? ""
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


