//
//  WFEducationView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFEducationView: UIView,UIPickerViewDataSource,UIPickerViewDelegate{


    var dataList  = [WFEducationModel]()
    
    var ensureEducation : ((String)->())?
    
    
    ///确定Click
    @IBAction func ensureBtnClick(_ sender: Any) {
    
        self.ensureEducation!(dataList[pickView.selectedRow(inComponent: 0)].name ?? "")
        
        isHidden = true
    }
    
    @IBOutlet weak var ensureBtn: UIButton!
    
    @IBOutlet weak var pickView: UIPickerView!
    
     class func educateView(_ frame : CGRect) -> WFEducationView {
        
        let nib  = UINib.init(nibName: "WFEducationView", bundle: nil)
        
        let v =  nib.instantiate(withOwner: nil, options: nil)[0] as! WFEducationView
        
        v.frame  = frame
       
        v.setUpUI()
        
        return v
    }
    
    /// 设置界面
    func setUpUI () {
        
        pickView.delegate = self
        pickView.dataSource = self
        
        ensureBtn.addTarget(self, action: #selector(ensureBtnClick(_:)), for: .touchUpInside)
        pickView.reloadAllComponents()
        
        loadDateSouce()
    }

    private func loadDateSouce() {
       
        NetworkerManager.shared.getEducations { (isSuccess, json) in
            
            if isSuccess  == true {
              
               self.dataList = json
               self.pickView.reloadAllComponents()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
         isHidden = true
    }
  
}

extension WFEducationView{
    
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        
        return NSAttributedString(string: dataList[row].name ?? "",
                                  attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20), NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
    }
    
    @available(iOS 2.0, *)
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataList[row].name ?? ""
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 300
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return  dataList.count
    }
    
}
