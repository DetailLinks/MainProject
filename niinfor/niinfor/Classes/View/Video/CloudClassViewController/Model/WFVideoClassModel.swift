//
//  WFVideoClassModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/27.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFVideoClassModel: NSObject {

    var durationSum = 0
    var videoList = [WFVideoListModel]()
    
    var druationString : String{
        let second  = durationSum % 60
        let minit   = (durationSum / 60) //% 60
        if minit == 0{
            return " 00:\(String.init(format: "%02d", second))分钟"
        }else{
            return "\(String.init(format: "%02d", minit)):\(String.init(format: "%02d", second))分钟"
        }
    }
    
    static func modelContainerPropertyGenericClass() ->[String : AnyObject]? {
        return ["videoList" : WFVideoListModel.self]
    }
}

class WFVideoListModel: NSObject {
    
    var id  = 0
    var name  = ""
    var vid  = ""
    var duration  = 0
    var trial  = ""
//    var order  = 0
    var addTime = ""
    var authorsName = ""
    var size : Int = 0
    var isDefaultModel   = false
    var isSelectDownload = false
    
    
    var druationString : String{
        let second  = duration % 60
        let minit   = (duration / 60) //% 60
        if minit == 0{
            return " 00:\(String.init(format: "%02d", second))"
        }else{
            return "\(String.init(format: "%02d", minit)):\(String.init(format: "%02d", second))"
        }
    }

}
