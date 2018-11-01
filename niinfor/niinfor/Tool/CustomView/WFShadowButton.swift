//
//  WFShadowButton.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/28.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFShadowButton: UIButton {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let path  = UIBezierPath.init(ovalIn: CGRect.init(x: transWidth(90), y: 0, width: Screen_width / 2 -  2 * transWidth(90)  , height: 50))
        
        let  shapeLayer : CAShapeLayer = CAShapeLayer.init()
        
        shapeLayer.path = path.cgPath
        
        self.layer.mask = shapeLayer
        
        let contenxt  = UIGraphicsGetCurrentContext()
        contenxt?.setLineWidth(4)
        contenxt?.setStrokeColor(UIColor.gray.cgColor)
        
        contenxt?.setLineDash(phase: 0, lengths: [4,8])
        contenxt?.addPath(path.cgPath)
        contenxt?.strokePath()

    }
}
