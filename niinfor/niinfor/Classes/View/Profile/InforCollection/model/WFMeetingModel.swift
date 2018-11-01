//
//  WFMeetingModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMeetingModel: NSObject {

    var meetingInfoId = 0
    var meetingName : String?
    var meetingDate : String?
    var titlePic : String?
    
    var meetingUrl : String?
    
    var titlePicString : String{
        return (titlePic ?? "")//Photo_Path + (titlePic ?? "")//
    }
    
    var cellHeight : CGFloat {
        return 63 + (Screen_width - 20) / 710 * 270 //63 + imageHeight
    }
    
    var imageHeight : CGFloat{
        return (titlePic ?? "" == "" ) ? 0 : ((Screen_width - 20) / 710 * 270)
     }
    
    
    override var description: String{
        return yy_modelDescription()
    }

}
