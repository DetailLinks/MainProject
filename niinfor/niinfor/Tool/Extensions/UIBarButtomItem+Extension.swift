//
//  UIBarButtomItem+Extension.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/10.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    /// 创建 UIBarButtonItem
    ///
    /// - parameter title:    title
    /// - parameter fontSize: fontSize，默认 16 号
    /// - parameter target:   target
    /// - parameter action:   action
    /// - parameter isBack:   是否是返回按钮，如果是加上箭头
    ///
    /// - returns: UIBarButtonItem
    convenience init(imageString: String, fontSize: CGFloat = 16, target: AnyObject?, action: Selector, isBack: Bool = false ,fixSpace : CGFloat = 0,rightSpace : CGFloat = 0) {
        let btn = UIButton.xf_imageBtn(imageString)
        
        if isBack {
            let imageName = "nav_icon_back"
            
            btn.setImage(UIImage(named: imageName ), for: UIControlState(rawValue: 0))
            btn.setImage(UIImage(named: imageName ), for: .highlighted)
            btn.sizeToFit()
            btn.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
            
        }
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, fixSpace, 0, rightSpace)
        btn.addTarget(target, action: action, for: .touchUpInside)
        
        
        // self.init 实例化 UIBarButtonItem
        self.init(customView: btn)
    }
}

