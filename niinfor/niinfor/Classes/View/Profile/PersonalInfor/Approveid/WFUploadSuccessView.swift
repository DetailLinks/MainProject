//
//  WFUploadSuccessView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/3.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFUploadSuccessView: UIView {

    @IBAction func cancelBtnClick(_ sender: Any) {
        isHidden = true
    }
    
    @IBAction func uploadSuccess(_ sender: Any) {
        
       NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_returnto_toot), object: nil)
        isHidden = true
    }

    class func uploadSuccessView() -> WFUploadSuccessView {
        
        let nib  = UINib.init(nibName: "WFUploadSuccessView", bundle: nil)
        
        let v =  nib.instantiate(withOwner: nil, options: nil)[0] as! WFUploadSuccessView
        
        v.frame  = UIScreen.main.bounds
        
        return v
    }

}
