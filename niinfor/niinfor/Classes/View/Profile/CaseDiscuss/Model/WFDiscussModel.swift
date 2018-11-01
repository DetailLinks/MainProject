//
//  WFDiscussModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/7.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFDiscussModel: NSObject {

    var id = 0
    var views = 0
    var comments = 0
    var diggs = 0
    var title : String?
    
    var publishTime  : String = ""
    
    var publisher : WFUserAccount?
    var imgs : [Image] = []

    override var description: String{
        return yy_modelDescription()
    }
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["imgs" : Image.self]
    }


}

class Image: NSObject {

    var id  = 0
    var height  = 0
    var width  = 0
    var type : String?
    var thumbnail : String?
    var thumbnailString : String{
       return (thumbnail ?? "")//Photo_Path + (thumbnail ?? "")//
    }
    
    
    override var description: String{
        return yy_modelDescription()
    }

}

