//
//  WFRankModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/27.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import YYModel

class WFRankModel: NSObject {
    
    var listA : [WFEducationModel]?
    var listB : [WFEducationModel]?
    var listC : [WFEducationModel]?
    
//    func modelContainerPropertyGenericClass() ->[String : AnyObject]?  {
//        
//        return ["listA" : WFEducationModel.self,
//                    "listB" : WFEducationModel.self,
//                    "listC" : WFEducationModel.self]
//    }
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["listA" : WFEducationModel.self,
                    "listB" : WFEducationModel.self,
                    "listC" : WFEducationModel.self]
    }

//    func  modelContainerPropertyGenericClass()->Dictionary
//    {
//        
//    }
    
    override var description: String{
        return yy_modelDescription()
    }

    
}
