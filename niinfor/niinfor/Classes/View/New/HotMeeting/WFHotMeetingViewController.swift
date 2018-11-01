//
//  WFHotMeetingViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/29.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFHotMeetingViewController: BaseViewController {
    
    @IBOutlet weak var lineView: UIImageView!

    /// 会议预告按钮
    @IBOutlet weak var foreshowMeetingBtn: UIButton!
    
    /// 历史会议按钮
    @IBOutlet weak var historyMeetingBtn: UIButton!

    
    /// 会议预告点击
    @IBAction func foreshowMeetingClick(_ sender: Any) {
        
        if foreshowMeetingBtn.isSelected == true {
            return
        }
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected
        
        //动画
        UIView.animate(withDuration: 0.5) {
            
            var viewFrame = self.lineView.frame
            viewFrame.origin.x = self.foreshowMeetingBtn.xf_X
            self.lineView.frame = viewFrame
        }
        
    }
    
    /// 历史会议点击
    @IBAction func historyMeetingClick(_ sender: Any) {
        
        ///如果是当下选择的按钮的话返回
        if historyMeetingBtn.isSelected == true {
            return
        }
        
        ///切换按钮状态
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected
        
        UIView.animate(withDuration: 0.5) {
            
            var viewFrame = self.lineView.frame
            viewFrame.origin.x = self.historyMeetingBtn.xf_X
            self.lineView.frame = viewFrame
        }
        
    }
    
}


extension WFHotMeetingViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        title = "热门会议"
        
        ///设置tableView
        baseTableView.frame = CGRect(x: 0, y: 108, width: Screen_width, height: Screen_height - 108)
        baseTableView.separatorStyle = .none
        regestNibCellString(WFMeetingTableViewCell().identfy)

        setUpTableView()
        setUpForeshowBtn()
    }
    
    /// 设置预告和历史按钮
    private  func setUpForeshowBtn() {
        
        foreshowMeetingBtn.isSelected = true
        foreshowMeetingBtn.setAttributedTitle(NSMutableAttributedString(
            string: "会议预告",
            attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                              for: .selected)
        
        
        historyMeetingBtn.setAttributedTitle(NSMutableAttributedString(
            string: "历史会议",
            attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                             for: .selected)
        
    }
    
    
    /// 设置列表视图
    private func setUpTableView() {
        

        
        baseTableView.touchesShouldCancel(in: baseTableView)
        
        /// 添加右滑收拾
        let gesture  = UISwipeGestureRecognizer(target: self,
                                                action: #selector(gesterClick(gesture:)))
        baseTableView.addGestureRecognizer(gesture)
        
        /// 添加左滑收拾
        let gestureLeft  = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(gesterClick(gesture:)))
        
        gestureLeft.direction = .left
        baseTableView.addGestureRecognizer(gestureLeft)
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}


// MARK: - 监听的方法
extension WFHotMeetingViewController{
    
    
    // MARK: - 手势监听方法
    @objc func gesterClick(gesture : UISwipeGestureRecognizer){
        
        if gesture.direction == .right && historyMeetingBtn.isSelected == true {
            
            foreshowMeetingClick(self)
            print("往左滑")
            
        }
        if gesture.direction == .left  {
            
            historyMeetingClick(self)
            
            print("往又滑")
        }
        
    }
    
}

