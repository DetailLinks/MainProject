//
//  WFMPArticle.swift
//  niinfor
//
//  Created by 王晓波 on 2018/9/8.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import YYModel

class WFMPArticle : NSObject {
    override var description: String{
        return yy_modelDescription()
    }
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["dicts" : WFMPSubSpecialty.self]
    }
    var id : String?
    var templateId : String?
    var type : String?
    var title : String?
    var cover : String?
    var content : String?
    var permission : String?
    var password : String?
    var allowComment : String?
    var views : String?
    var comments : String?
    var diggs : String?
    var status : String?
    var creationTime : String?
    var articleUrl : String?
    var dicts : [WFMPSubSpecialty]?
    var showDiggs : String = ""
    var showViews : String = ""
    var isDraft = false
    var imageData : Data?
    var keyId = ""
    
}
