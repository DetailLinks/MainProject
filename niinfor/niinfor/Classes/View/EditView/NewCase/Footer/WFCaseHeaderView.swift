//
//  WFCaseHeaderView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/14.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFCaseHeaderView: UIView {


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        ///添加视图设置约束
        self.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalTo(100)
            maker.height.equalTo(50)
        }
        
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var clickBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        btn.setImage( #imageLiteral(resourceName: "Add to"), for: .normal)
        
        return btn
    }()
}
