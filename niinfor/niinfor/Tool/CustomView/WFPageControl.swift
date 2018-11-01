//
//  WFPageControl.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/9.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
//自定义pageViewController
class WFPageControl: UIPageControl {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    override var currentPage: Int{
        
        didSet{
            super.currentPage = currentPage
            
            for i in 0..<subviews.count{
                
                let v = subviews[i]
                
                var frame  = v.frame
                frame.size = CGSize(width: 12, height: 2)
                v.frame = frame
                
                v.alpha = 0.2
                
                v.layer.cornerRadius = 0
                
                if i == currentPage {
                    v.alpha = 1
                }
                
            }
            
        }
        
    }
    
    

    
}
