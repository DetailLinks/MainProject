//
//  WFDatePickView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFDatePickView: UIDatePicker {


    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

extension WFDatePickView{
    
     func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        return NSAttributedString(string: ["博士及以上","硕士","本科","大专","中专以下"][row],
                                  attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ["博士及以上","硕士","本科","大专","中专以下"][row]
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }

    
    
}
