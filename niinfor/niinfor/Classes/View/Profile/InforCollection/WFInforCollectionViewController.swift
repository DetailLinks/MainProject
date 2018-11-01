//
//  WFInforCollectionViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFInforCollectionViewController: BaseViewController {

    var  isMeeingCollection = true
    

}

extension WFInforCollectionViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        title = isMeeingCollection ? "会议收藏" : "资讯收藏"
        
        let cellString  =  isMeeingCollection ? WFMeetingTableViewCell().identfy : WFInforTableViewCell().identfy
        
        ///设置tableView
        baseTableView.frame = CGRect(x: 0, y: 64, width: Screen_width, height: Screen_height - 64)
        baseTableView.separatorStyle = .none
        regestNibCellString(cellString)
        
}
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
}

extension WFInforCollectionViewController{

    ///加载数据
    override func loadData() {
        
        isMeeingCollection ? loadMeetingDate() : loadInforMeeting()
    }
    
    func loadMeetingDate() {
        
        NetworkerManager.shared.collectList(1 , "\(page)") { (isSuccess, json) in
            
            if isSuccess == true  {
                
                self.base_dataList = self.base_dataList + json
                self.baseTableView.reloadData()
                
            }
        }
    }

    func loadInforMeeting() {
       
        NetworkerManager.shared.collectListInfor( 0 , "\(page)") { (isSuccess, json) in
            
            if isSuccess == true  {
                
                self.base_dataList = self.base_dataList + json
                self.baseTableView.reloadData()
                
            }
        }

    }
}
