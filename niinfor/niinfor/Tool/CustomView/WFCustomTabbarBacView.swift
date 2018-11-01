//
//  WFCustomTabbarBacView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/8.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFCustomTabbarBacView: UIView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        var lineY : CGFloat = 0
        var radiu : CGFloat = 0
        let lineWidth : CGFloat = 0.2
        
        lineY =  rect.size.height - lineWidth - (isIphoneX ? 80 : 50)
        radiu = (rect.size.height - lineWidth * 2.0)/2.0
        
        ///left
        let lineColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.5)
        lineColor.set()
        
        let toTop : CGFloat = radiu - lineY + lineWidth
        let all : CGFloat = pow(radiu,2)-pow(toTop,2)
        let x2 : CGFloat  = sqrt(all)*2
        let line1W : CGFloat = (rect.size.width - x2)/2.0
        
        let leftPoint :  CGPoint = CGPoint.init(x: line1W, y: lineY)
        
        
        let  leftLinePath : UIBezierPath = UIBezierPath()
        
        // 起点
        leftLinePath.move(to: CGPoint.init(x: 0, y: lineY))
        
        // 其他点
        leftLinePath.addLine(to: leftPoint)
        leftLinePath.lineWidth = lineWidth
        leftLinePath.lineCapStyle = .round
        leftLinePath.lineJoinStyle = .round
        
        leftLinePath.stroke()
        
        
        ///right
        lineColor.set()
        
        let rX : CGFloat = rect.size.width - line1W;
        
        let rightPoint :  CGPoint = CGPoint.init(x: rX, y: lineY)
        let  rightLinePath : UIBezierPath = UIBezierPath()
        
        // 起点
        rightLinePath.move(to:rightPoint)
        
        // 其他点
        rightLinePath.addLine(to:  CGPoint.init(x: rect.size.width, y: lineY))
        rightLinePath.lineWidth = lineWidth
        rightLinePath.lineCapStyle = .round
        rightLinePath.lineJoinStyle = .round
        
        rightLinePath.stroke()

        ///弧线
        lineColor.set()
        
        let yyy2 : CGFloat = acos(toTop / radiu);
        
        let centerPoint : CGPoint = CGPoint.init(x: rect.size.width / 2, y: rect.size.height / 2)
        
        let centerLinePath : UIBezierPath = UIBezierPath()
        centerLinePath.addArc(withCenter: centerPoint, radius: radiu, startAngle: -yyy2 - CGFloat(M_PI_2), endAngle: yyy2 - CGFloat(M_PI_2), clockwise: true)
        
        
        centerLinePath.lineWidth = lineWidth
        centerLinePath.lineCapStyle = .round
        centerLinePath.lineJoinStyle = .round
        
        centerLinePath.stroke()
        
        ///去除剩余部分
        let bezierPath = UIBezierPath.init(rect: CGRect.init(x: 0, y: lineY - lineWidth, width: rect.size.width, height: rect.size.height-lineY))

        bezierPath.append(UIBezierPath.init(roundedRect: CGRect.init(x: (rect.size.width-rect.size.height)/2, y: 0 , width: rect.size.height, height: rect.size.height) , cornerRadius: radiu))

        
        
        let  shapeLayer : CAShapeLayer = CAShapeLayer.init()
        
        shapeLayer.path = bezierPath.cgPath
        
        self.layer.mask = shapeLayer
    }
}
















