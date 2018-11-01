//
//  WFTitleButton.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFTitleButton: UIButton {

    init() {
        super.init(frame: CGRect())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let titleLabel = titleLabel, let imageView = imageView else {
            return
        }
        
        imageView.frame = CGRect.init(x: (bounds.width - imageView.frame.width) / 2.0, y: (bounds.height - imageView.bounds.height - titleLabel.bounds.height - 8) / 2, width: imageView.frame.width, height: imageView.bounds.height)
        
        titleLabel.frame = CGRect.init(x: (bounds.width - titleLabel.frame.width) / 2.0, y: imageView.frame.origin.y + imageView.bounds.height + 8, width: titleLabel.frame.width, height: titleLabel.bounds.height)

            //titleLabel.frame.offsetBy(dx: -titleLabel.bounds.width/2, dy: titleLabel.bounds.height/2 )


            //imageView.frame.offsetBy(dx: imageView.bounds.width/2, dy: -imageView.bounds.height/2 )
    }
}

