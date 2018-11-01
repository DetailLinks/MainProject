//
//  WFSearchMeetingController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/25.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

var btnSpace : CGFloat = 0

class WFSearchMeetingController: BaseViewController {

    
    /// 地区视图
    lazy var eareView : WFEareMainView  = WFEareMainView.eareMainView(
                                                                                                            CGRect(x: 0,
                                                                                                                        y: 108,
                                                                                                                        width: Screen_width,
                                                                                                                        height: Screen_height - 108))
    
    /// 选择其他的视图
    lazy var selctTableView : WFSelectTableView = WFSelectTableView.selectView(
                                                                                     CGRect(x: 0,
                                                                                                   y: 108,
                                                                                                   width: Screen_width,
                                                                                                   height: Screen_height - 108), style: .SelectStyleOnlyText)
    
    /// 地区按钮
    @IBOutlet weak var eareBtn: UIButton!
    /// 地区按钮点击
    @IBAction func eareBtnClick(_ sender: Any) {
        selctTableView.isHidden = true
        
        let sender = sender as! UIButton
        sender.isSelected = !sender.isSelected
        eareView.isHidden = !sender.isSelected
    }
    
    /// 专科点击
    @IBAction func officialBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
        sender.isSelected = !sender.isSelected
        
        selctTableView.isHidden = false
        if sender.isSelected == true {
            selctTableView.selectStyle = .SelectStyleOnlyText
        }else{
            selctTableView.isHidden = true
        }
    }
    
    /// 医院点击
    @IBAction func hospitalBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
        sender.isSelected = !sender.isSelected
        
        if selctTableView.selectStyle != .SelectStyleHopital {
            selctTableView.selectStyle = .SelectStyleHopital
        }
        selctTableView.isHidden = !sender.isSelected
    }
    
    /// 公司点击
    @IBAction func companyBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
        sender.isSelected = !sender.isSelected
        
        selctTableView.isHidden = false
        if selctTableView.selectStyle != .SelectStyleCompany {
            selctTableView.selectStyle = .SelectStyleCompany
        }else{
            selctTableView.isHidden = true
        }
        
    }
}

// MARK: - 设置界面
extension WFSearchMeetingController{
    
    override func setUpUI() {
        super.setUpUI()
    
        title = "会议查询"
        
        ///设置tableView
        baseTableView.frame = eareView.frame
        baseTableView.separatorStyle = .none
        regestNibCellString(WFMeetingTableViewCell().identfy)
        
        view.addSubview(eareView)
        view.addSubview(selctTableView)
        
        selctTableView.isHidden = true
        eareView.isHidden = true
        
        ///记录一下btn的frame
        btnSpace = (eareBtn.titleLabel?.xf_X ?? 0) - 20.5
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
}
