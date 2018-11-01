//
//  WFMeetingSelectedView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/22.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMeetingSelectedView: UIView,UIPickerViewDelegate,UIPickerViewDataSource {

//    var dataList  = [WFEducationModel]()
    
    var ensureSelectTime : ((String)->())?
    
    
    ///确定Click
    @IBAction func ensureBtnClick(_ sender: Any) {
        
        if pickView.selectedRow(inComponent: 0) == 4 {
            
            self.ensureSelectTime!("")
        }else if pickView.selectedRow(inComponent: 1) == 12 {
           
            self.ensureSelectTime!("\(["2015","2016","2017","2018","全部"][pickView.selectedRow(inComponent: 0)])")
        }else {
            
            self.ensureSelectTime!("\(["2015","2016","2017","2018","全部"][pickView.selectedRow(inComponent: 0)])-\(["1","2","3","4","5","6","7","8","9","10","11","12","全部"][pickView.selectedRow(inComponent: 1)])")
        }
        
        isHidden = true
    }
    
    @IBOutlet weak var ensureBtn: UIButton!
    
    @IBOutlet weak var pickView: UIPickerView!
    
    class func selectedTimeView(_ frame : CGRect) -> WFMeetingSelectedView {
        
        let nib  = UINib.init(nibName: "WFMeetingSelectedView", bundle: nil)
        
        let v =  nib.instantiate(withOwner: nil, options: nil)[0] as! WFMeetingSelectedView
        
        v.frame  = frame
        
        v.setUpUI()
        return v
    }
    
    /// 设置界面
    func setUpUI () {
        
        pickView.delegate = self
        pickView.dataSource = self
        
        pickView.reloadAllComponents()
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHidden = true
    }
    
}

extension WFMeetingSelectedView{
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
       
        if component == 0 {
            
         return   NSAttributedString(string: ["2015","2016","2017","2018","全部"][row],
                               attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
        }
        
        return NSAttributedString(string: ["1","2","3","4","5","6","7","8","9","10","11","12","全部"][row],
                                  attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
         if component == 0 {
            return ["2015","2016","2017","2018","全部"][row]
        }
            return ["1","2","3","4","5","6","7","8","9","10","11","12","全部"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return Screen_width / 2 - 10
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return component == 0  ? 5 : 13
    }
    
}
