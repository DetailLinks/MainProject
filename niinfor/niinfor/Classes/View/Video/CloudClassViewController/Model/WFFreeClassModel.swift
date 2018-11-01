//
//  WFFreeClassModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/26.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFFreeClassModel: NSObject {

    var id : Int = 0
    var name : String = ""
    var image : String = ""
    var introduction : String = ""
    var condition : String = ""
    var content : String = ""
    var point : String = ""
    var money : String = ""
    var buys : String = ""
    var views : String = ""
    var comments : String = ""
    var downloads : String = ""
    var score : String = ""
    var tags  = [TagModel]()
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["tags" : TagModel.self]
    }
}
class TagModel : NSObject {

    var id : Int = 0
    var name : String = ""

    override var description: String{
        return yy_modelDescription()
    }
}


class WFCommentListModel: NSObject {
    
    var commentTime : String = ""
    var content : String = ""
    var status : String = ""
    var score : String = ""
    var isDigg : String = ""
    var diggs : Int = 0
    var id : Int = 0
    var replys : Int = 0
    var commentator : Commentator =  Commentator()
    var childComments : [ChildComments] = []
    
    var isFoldComment = true
    
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["childComments" : ChildComments.self]
    }

    override var description: String{
        return yy_modelDescription()
    }
}

class ChildComments: NSObject {
    var child : String = ""
    var parent : String = ""
    var text : String = ""
    var id : Int = 0

    override var description: String{
        return yy_modelDescription()
    }
}

class Commentator: NSObject {
    var avatarAddress : String = ""
    var realName : String = ""
    var id : Int = 0
    
    override var description: String{
        return yy_modelDescription()
    }
}


