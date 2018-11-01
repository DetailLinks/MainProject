//
//  WFHeaderCollectionReusableView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/26.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFHeaderCollectionReusableView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titlLabel)
        
        titlLabel.textColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)
        titlLabel.font = UIFont.systemFont(ofSize: 14)
        
        titlLabel.snp.makeConstraints { (maker ) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let titlLabel = UILabel.init()
    
    func  setTitle(_ title : String) {
        titlLabel.text = title
    }
}
