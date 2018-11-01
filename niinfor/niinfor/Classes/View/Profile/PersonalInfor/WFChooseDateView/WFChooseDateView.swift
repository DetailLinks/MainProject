//
//  WFChooseDateView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFChooseDateView: UIView {

    ///创建日期视图
    class func chooseView(_ frame : CGRect) -> WFChooseDateView {
        
        let nib  = UINib.init(nibName: "WFChooseDateView", bundle: nil)
        
        let v =  nib.instantiate(withOwner: nil, options: nil)[0] as! WFChooseDateView
        
        v.frame  = frame
        
        v.setUpUI()
        return v
    }
    
    ///设置界面
    private func setUpUI()  {

        datePicker.maximumDate = Date()
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick(_:)), for: .touchUpInside)
        ensureBtn.addTarget(self, action: #selector(ensureBtnClick(_:)), for: .touchUpInside)

    }
    
    /// 返回当前时间
    var currentDate : String{

        let date  = datePicker.date
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "YYYY/MM/dd"
        
        return dateFormate.string(from: date)
    }
    
    
    /// 回调返回当前的时间
    var currentTimer : ((_ time:String)->())?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var ensureBtn: UIButton!

    @IBAction func cancelBtnClick(_ sender: Any) {
        isHidden = true
    }
    
    @IBAction func ensureBtnClick(_ sender: Any) {
        
        isHidden = true
        
        if (currentTimer) != nil {
            
            currentTimer!(currentDate)
        }
        
    }
    
}
