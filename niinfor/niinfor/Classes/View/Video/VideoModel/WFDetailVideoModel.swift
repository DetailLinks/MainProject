//
//  WFVideoModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/27.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFDetailVideoModel: NSObject {

    var id : Int = 0
    var name : String = ""
    var vid : String = ""
    var duration : String = ""
    var trial : String = ""
    var authors : [WFAuthorsModel] = []
    var course : WFFreeClassModel  = WFFreeClassModel()
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["tags" : TagModel.self,
                "authors" : WFAuthorsModel.self, ]
    }
    override var description: String{
        return yy_modelDescription()
    }
}

class WFAuthorsModel : NSObject {

    var id : Int = 0
    var authorName : String = ""
    var headImage : String = ""
    var mdescription : String = ""
    var titles : String = ""
    var company : String = ""
    override var description: String{
        return yy_modelDescription()
    }

    static func modelCustomPropertyMapper() ->[String : AnyObject]? {
        return ["mdescription" : "description" as AnyObject ]
    }

}
