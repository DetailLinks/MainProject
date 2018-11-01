//
//  WFMoreViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/7.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMoreViewController: BaseViewController {

}

///设置界面
extension WFMoreViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "新闻资讯"
        regestNibCellString(WFInforTableViewCell().identfy)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = WFVideoDetailController()
        
        vc.htmlString = Photo_Path + (base_dataList[indexPath.row].url ?? "")
        
        navigationController?.pushViewController(vc, animated: true )
        
    }
}

extension WFMoreViewController{
    
    override func loadData() {
        loadHoneInfoData()
    }
    
    func loadHoneInfoData() {
        
        NetworkerManager.shared.getHomePageInfo(page) { (isSuccess, json) in
            
            if isSuccess == true {
                
                self.base_dataList = self.base_dataList + json
                
                self.baseTableView.reloadData()
            }
        }
    }

}
