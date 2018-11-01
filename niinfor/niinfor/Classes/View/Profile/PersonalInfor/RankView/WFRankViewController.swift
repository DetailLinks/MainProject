//
//  WFRankViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFRankViewController: BaseViewController {

    @IBOutlet weak var navigationBarConstant: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var dataList  = WFRankModel()
    var selectList  = [-1,-1,-1]
    
    var complict : ((String)->())?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.value(forKey: "--") != nil  {//selectList
            selectList = UserDefaults.standard.value(forKey: "selectList") as? [Int] ?? [-1,-1,-1]
            tableView.reloadData()
        }
        
    }

    
}

///设置界面
extension WFRankViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "职称选择"
        navigationBarConstant.constant = navigation_height
        tableView.register(UINib.init(nibName: WFRankCell().identfy, bundle: nil), forCellReuseIdentifier: WFRankCell().identfy)
        
        loadDataSouce()
        
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
        
        if selectList[0] != -1  {
            string += dataList.listA?[selectList[0]].name ?? "" + "  "
        }
        if selectList[1] != -1 {
            if string != "" {
                string += "、"
            }
            string += dataList.listA?[selectList[1]].name ?? "" + "  "
        }
        
        if selectList[2] != -1 {
            if string != "" {
                string += "、"
            }
            string += dataList.listA?[selectList[2]].name ?? ""
        }
        complict!(string)
        
        UserDefaults.standard.setValue(selectList, forKey: "selectList")
        
        navigationController?.popViewController(animated: true)
    }


    
    ///加载数据
    private func loadDataSouce() {
        
        NetworkerManager.shared.getTitles { (isSuccess, json) in
            
            if isSuccess == true {
                self.dataList = json
                self.tableView.reloadData()
            }
            
        }
    }
}

extension WFRankViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFRankCell().identfy, for: indexPath) as? WFRankCell
        
        cell?.isSelectedCell = false
        
        var array   = [WFEducationModel]()
        
        switch indexPath.section {
            
        case 0:  array = dataList.listA ?? []
                    if selectList[0] !=  -1 && indexPath.row == selectList[0] {cell?.isSelectedCell = true}
            
        case 1:  array = dataList.listB ?? []
                    if selectList[1] !=  -1 && indexPath.row == selectList[1] {cell?.isSelectedCell = true}
            
        case 2:  array = dataList.listC ?? []
                    if selectList[2] !=  -1 && indexPath.row == selectList[2] {cell?.isSelectedCell = true}
            
        default:  break
        }
        
        let nsarray    = array as NSArray   //[indexPath.row] as WFEducationModel
         cell?.model = nsarray[indexPath.row] as? WFEducationModel
        
        cell?.complictSelected = {(cell) in
            
            let  index : IndexPath = tableView.indexPath(for: cell)!
            
            switch index.section {
            
            case 0:
                if self.selectList[0] == -1 || self.selectList[0] != index.row {
                    self.selectList[0] = index.row
                }else{
                self.selectList[0] = -1
                }
                
            case 1:
                if self.selectList[1] == -1 || self.selectList[1] != index.row {
                    self.selectList[1] = index.row
                }else{
                    self.selectList[1] = -1
                }

            case 2:
                if self.selectList[2] == -1 || self.selectList[2] != index.row{
                    self.selectList[2] = index.row
                }else{
                    self.selectList[2] = -1
                }
                
            default: break
            }
           
            tableView.reloadData()
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0: return dataList.listA?.count ?? 0
        case 1: return dataList.listB?.count ?? 0
        case 2: return dataList.listC?.count ?? 0
            
        default: return 0
        }
            //(dataList[0].list?.count)! + (dataList[1].list?.count)! + (dataList[3].list?.count)!
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    

}





