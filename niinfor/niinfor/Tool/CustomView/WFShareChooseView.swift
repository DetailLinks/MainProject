//
//  WFShareChooseView.swift
//  神经介入资讯
//
//  Created by 王孝飞 on 2017/10/24.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFShareChooseView: UIView {

    @IBOutlet weak var newCaseBtn: UIButton!

    
    @IBOutlet weak var shareBtn: UIButton!
    
    
    class  func shareChooseView(_ frame : CGRect ) -> WFShareChooseView {
        
        let nib = UINib.init(nibName: "WFShareChooseView", bundle: nil)
        
        let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WFShareChooseView
        
        v.frame = frame
        
        return v
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        isHidden = true
    }
}


