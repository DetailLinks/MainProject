//
//  WFSubspecialController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/3.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFSubspecialController: BaseViewController {
    
    var titleID  = ""
    
    var selectDataList  = [Int]()
    
    var complict : ((String)->())?
}

///设置界面
extension WFSubspecialController{
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "亚专业选择"
        
        baseTableView.bounces = false
        regestNibCellString(WFRankCell().identfy)
        
        loadNetDate()
        
        setRightItem()
    }
    
    ///完成按钮
    private func setRightItem(){
        
        let btn  = UIButton.cz_textButton("完成", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        btn?.addTarget(self, action: #selector(rightItmClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn!)
        
    }
    
    @objc private func rightItmClick() {
        
        var string  = ""
        
        for item  in selectDataList {
            
            if item != -1 {
                
                let educationModel = base_dataList[item] as? WFEducationModel
                
                string += (string == "" ? "" : "、") + (educationModel?.name ?? "")
                
            }
        }
        
        complict?(string)
    
        navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "WFRankCell", for: indexPath) as? WFRankCell
        
        cell?.isSelectedCell = false
        
        cell?.complictSelected = {(cell) in
        
            let index  = tableView.indexPath(for: cell)
            
            if self.selectDataList[index?.row ?? 0] == -1 {
                self.selectDataList[index?.row ?? 0] = index?.row ?? 0
            }else {
                self.selectDataList[index?.row ?? 0] = -1
            }
            tableView.reloadData()
        }
        
        if self.selectDataList[indexPath.row] != -1 && self.selectDataList[indexPath.row] == indexPath.row {
            cell?.isSelectedCell = true
        }
        
        cell?.model = base_dataList[indexPath.row] as? WFEducationModel
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    ///加载网络数据
    private func loadNetDate () {
        
        NetworkerManager.shared.getSpecialities(["hospdeptsId":titleID]) { (isSuccess, json) in
            
            if isSuccess == true {
                
            self.base_dataList = json
                
            for _ in 0..<self.base_dataList.count{
                self.selectDataList.append(-1)
            }
            
            self.baseTableView.reloadData()
        }
        
    }
}
}
