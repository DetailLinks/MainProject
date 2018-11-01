//
//  UIView+Extension.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/22.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

extension UIView{
    
    var xf_width : CGFloat {
        return frame.size.width
    }
    
    var xf_height : CGFloat {
        return frame.size.height
    }

    var xf_X : CGFloat {
        return frame.origin.x
    }

    var xf_Y : CGFloat {
        return frame.origin.y
    }
    
    var xf_size : CGSize {
        return bounds.size
    }

    ///返回视图截图
    var xf_snapImage:UIImage{
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard  let  image  = UIGraphicsGetImageFromCurrentImageContext() else {
           UIGraphicsEndImageContext()
            return UIImage()
        }
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func xf_snapImage(_ rect : CGRect) -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(rect.size, true, 0)
        drawHierarchy(in: rect, afterScreenUpdates: true)
        guard  let  image  = UIGraphicsGetImageFromCurrentImageContext() else {
            UIGraphicsEndImageContext()
            return UIImage()
        }
        UIGraphicsEndImageContext()
        
        return image
    }
    
    ///切割圆角
        func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
            let cornerLayer = CAShapeLayer()
            cornerLayer.frame = bounds
            cornerLayer.path = path.cgPath
            
            layer.mask = cornerLayer
        }
    
    
}
