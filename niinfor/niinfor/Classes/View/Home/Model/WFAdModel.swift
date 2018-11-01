//
//  WFAdModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFAdModel: NSObject {

    var id : String?
    
    var name : String?
    
    var url : String?
    
    var image : String?
    
    var imageString : String{
        return (image ?? "")//Photo_Path + (image ?? "")//
    }
    
    
    override var description: String{
        return yy_modelDescription()
    }
}
