//
//  WFFooterView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/15.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WFFooterView: UITableViewHeaderFooterView {

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.clear
        
        ///添加视图设置约束
        self.addSubview(clickBtn)
        clickBtn.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
            maker.width.equalToSuperview()
            maker.height.equalToSuperview()
        }
    }
    
    var  disposeBag  =  DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
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
