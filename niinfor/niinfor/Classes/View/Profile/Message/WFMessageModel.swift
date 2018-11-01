//
//  WFMessageModel.swift
//  神经介入资讯
//
//  Created by 王孝飞 on 2017/10/25.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMessageModel: NSObject,NSCoding{

    var title : String
    var content : String
    var timeString : String
    
    //构造方法
    required init(title:String="", content:String="",timeString:String = "") {
        self.title = title
        self.content = content
        self.timeString = timeString
    }
    
    //从object解析回来
    required init(coder decoder: NSCoder) {
        self.title = decoder.decodeObject(forKey: "title") as? String ?? ""
        self.content = decoder.decodeObject(forKey: "content") as? String ?? ""
        self.timeString = decoder.decodeObject(forKey: "timeString") as? String ?? ""
    }
    
    //编码成object
    func encode(with coder: NSCoder) {
        coder.encode(title, forKey:"title")
        coder.encode(content, forKey:"content")
        coder.encode(timeString, forKey:"timeString")
    }
    
    override var description: String{
        return yy_modelDescription()
    }
}
