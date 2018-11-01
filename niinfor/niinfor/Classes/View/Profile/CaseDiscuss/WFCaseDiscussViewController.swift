//
//  WFCaseDiscussViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFCaseDiscussViewController: BaseViewController {

    @IBOutlet weak var navigationBarConstant: NSLayoutConstraint!
    let titpLabel = UILabel()
}

///设置界面
extension WFCaseDiscussViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        navigationBarConstant.constant = navigation_height
        navItem.title = "病例讨论"
        
        baseTableView.frame = CGRect(x: 0,
                                                              y: navigation_height,
                                                              width: Screen_width,
                                                              height: Screen_height - navigation_height)
        regestNibCellString(WFCaseDiscussCell().identfy)
        
        titpLabel.frame = CGRect(x: 0,
                                y: 0,
                                width: Screen_width,
                                height: Screen_height)
        titpLabel.text = "暂无病例"
        titpLabel.textAlignment = .center
        
        view.addSubview(titpLabel)

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  215
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let discusModel = self.base_dataList[indexPath.row] as? WFDiscussModel else{
            return
        }
        
        let vc  = WFVideoDetailController()
        vc.htmlString = Photo_Path + "/h5cases/casedetails.html?id=\(discusModel.id)"
        vc.title = "病例详情"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension WFCaseDiscussViewController{
    
    override func loadData() {
        
        NetworkerManager.shared.getUserCaseList(page) { (isSuccess, json) in
            
            if isSuccess == true {
                
                self.base_dataList = self.base_dataList + json
                self.baseTableView.reloadData()
                self.titpLabel.isHidden  =  self.base_dataList.count != 0
                
            }
        }
    }
}
