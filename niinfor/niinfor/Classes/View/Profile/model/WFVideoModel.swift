//
//  WFVideoModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFVideoModel: NSObject {

    var infoId  = 0
    
    var title : String?
    
    var publishDate : String?
    
    var infoImg : String?
    
    var infoImgString : String{
        return (infoImg ?? "")//Photo_Path + (infoImg ?? "")//
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
