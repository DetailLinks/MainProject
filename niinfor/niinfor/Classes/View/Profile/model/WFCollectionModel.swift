//
//  WFCollectionModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFCollectionModel: NSObject {

    var infoId  = 0
    
    var title : String?
    
    var  infoTitle : String?
    
    var publishDate : String?
    
    var infoImg : String?
    
    var authors : [Authors]?
    
    var url : String?
    
    var infoImgString : String{
        return (infoImg ?? "")//Photo_Path + (infoImg ?? "")//
    }
    
    override var description: String{
        return yy_modelDescription()
    }
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["authors" : Authors.self]
    }
}

class Authors : NSObject{
    
    var id : String?
    
    var authorName : String?
    
    var company : String?
    
    override var description: String{
        return yy_modelDescription()
    }
}
