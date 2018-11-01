//
//  Bundle+Extensions.swift
//  反射机制
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 itcast. All rights reserved.
//

import Foundation

extension Bundle {

    // 计算型属性类似于函数，没有参数，有返回值
    //也可以设置成一个方法 但是计算型属性更好点 便于阅读
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

extension Date{
    ///时间戳
    var timeStapmpString : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }
}
