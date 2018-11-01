//
//  WFSelectTableView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

enum SelectStyle {
    case SelectStyleOnlyText
    case SelectStyleHopital
    case SelectStyleCompany
}

class WFSelectTableView: UIView,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var selectTableView: UITableView!
    
    var cellIdetity : String = ""
    var dataList  = [WFEducationModel](){
        didSet{
             self.selectTableView.reloadData()
        }
    }
    
    var selectStyle : SelectStyle = .SelectStyleOnlyText

//{
//        didSet{
//            
//            switch selectStyle {
//    
//            case .SelectStyleOnlyText:
//                cellIdetity = WFOffcialTableViewCell().identfy
//                
//            case .SelectStyleHopital:
//                cellIdetity = WFHospitalTableViewCell().identfy
//                
//            default:
//                break
//            }
//            
//            selectTableView.reloadData()
//        }
//}


    class  func selectView(_ frame : CGRect, style:SelectStyle ) -> WFSelectTableView {
        
        let nib = UINib.init(nibName: "WFSelectTableView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WFSelectTableView
        
        v.frame = frame
        
        v.createEareView(style)
        
        return v
    }

    
    ///创建tableView
   private func createEareView(_ style : SelectStyle) {
    
        selectStyle = style
    
        selectTableView.tableFooterView = UIView()
        selectTableView.delegate = self
        selectTableView.dataSource = self
    
       selectTableView.register(UINib.init(nibName: WFHospitalTableViewCell().identfy,
                                                                   bundle: nil),
                                                                  forCellReuseIdentifier: WFHospitalTableViewCell().identfy)
    
        selectTableView.register(UINib.init(nibName: WFOffcialTableViewCell().identfy,
                                                                 bundle: nil),
                                                                 forCellReuseIdentifier: WFOffcialTableViewCell().identfy)
    
      cellIdetity = WFOffcialTableViewCell().identfy
    
    }
}

// MARK: - 代理协议
extension WFSelectTableView{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellIdetity)
        
        cell?.setValue(dataList[indexPath.row], forKey: "model")
        
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var string  = ""
        var index  = 0
        
        switch selectStyle {
            
        case .SelectStyleOnlyText:  string = dataList[indexPath.row].name ?? "";index=1
        case .SelectStyleHopital:     string = dataList[indexPath.row].id ?? "";index=2
        case .SelectStyleCompany:  string = dataList[indexPath.row].id ?? "";index=3
            
        default: break
        }
        
        if indexPath.row == 0 {
            string = ""
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_selectTable_click), object: ["style":"\(index)","message":string] )
        
        isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHidden = true
        
    }
    
}













