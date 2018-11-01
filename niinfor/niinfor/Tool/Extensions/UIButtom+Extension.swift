//
//  UIButtom+Extension.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/10.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

extension UIButton {

    class func xf_imageBtn(_ imageName:String) -> UIButton {
        
        let btn = UIButton(type: .custom)
        
        btn.setImage(UIImage(named: imageName), for: .normal)
        
        btn.sizeToFit()
        
        return btn
    }
    
}
