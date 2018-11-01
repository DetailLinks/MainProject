//
//  WFHomeInforModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/5.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFHomeInforModel: NSObject {

    var infoId  = 0
    
    var infoTitle : String?
    
    var publishDate : String?
    
    var infoImg : String?
    
    var url  : String?
    
    var infoImgString : String{
        return (infoImg ?? "")//Photo_Path + (infoImg ?? "")//
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
