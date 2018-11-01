//
//  WFPlayModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/10.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFPlayModel: NSObject {

    var meetingInfoId : String?
    var meetingName : String?
    var meetingDate : String?
    var titlePic : String?
    
    var titlePicString : String{
        return (titlePic ?? "")//Photo_Path + (titlePic ?? "")//
    }
    
    var meetingUrl : String?
    
    var meetingFields = [MeetingFields]()
    
    /////181  205  230 258
    var cellHeight : CGFloat{
        
       switch meetingFields.count {
        case 0: return 181
        case 1: return 205
        case 2: return 230
        case 3: return 258
        default: break
        }
        return CGFloat(258 + 23 * (meetingFields.count - 3))
    }
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["meetingFields" : MeetingFields.self]
    }

}
class MeetingFields: NSObject {
    
    var id  : String?
    var subject : String?
    var fieldUrl : String?
    
    override var description: String{
        return yy_modelDescription()
    }
}



