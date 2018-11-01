//
//  WFCurrentMothMTingController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/29.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFCurrentMothMTingController: BaseViewController,CLWeeklyCalendarViewDelegate {

    lazy var timeContol : CLWeeklyCalendarView = {
    
        let v = CLWeeklyCalendarView(frame: CGRect(x: 0, y: 64, width: Screen_width, height: 116))
        v.delegate = self
        
        return v
    }()
    
}

///设置界面
extension WFCurrentMothMTingController{
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "本月会议"
        
        view.addSubview(timeContol)
        
        baseTableView.frame = CGRect(x: 0, y: 190, width: Screen_width, height: Screen_height - 190)
        regestNibCellString(WFMeetingTableViewCell().identfy)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


extension WFCurrentMothMTingController{
    
    func clCalendarBehaviorAttributes() -> [AnyHashable : Any]! {
        return [CLCalendarWeekStartDay : 7]
    }
    
    func dailyCalendarViewDidSelect(_ date: Date!) {
        print("点击了我你")
    }
    
}
