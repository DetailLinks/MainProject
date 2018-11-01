//
//  WFViewHistoryViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/10/12.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFViewHistoryViewController: BaseViewController {

}

extension WFViewHistoryViewController{
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        setTitleView()
    }
    
    func setTitleView() {
        let btn = UIButton.cz_textButton("学习历史", fontSize: 17, normalColor: UIColor.black, highlightedColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1))
        btn?.addTarget(self, action: #selector(viewDidAppear(_:)), for: .touchUpInside)
        let btn1 = UIButton.cz_textButton("课程缓存", fontSize: 17, normalColor:UIColor.black, highlightedColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1))
        btn?.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .selected)
        btn1?.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .selected)
        btn?.isSelected = true
        btn1?.addTarget(self, action: #selector(viewDidAppear(_:)), for: .touchUpInside)
        
        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 44))
        btn?.frame = CGRect.init(x: 0, y: 0, width: 100, height: 44)
        btn1?.frame = CGRect.init(x: 100, y: 0, width: 100, height: 44)
        contentView.addSubview(btn!)
        contentView.addSubview(btn1!)

        navItem.titleView = contentView
    }
}
