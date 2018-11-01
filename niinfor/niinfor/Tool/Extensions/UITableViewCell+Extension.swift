//
//  UITableViewCell+Extension.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/24.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

extension UITableViewCell {

    var   identfy : String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }
    }

extension UICollectionViewCell {
    
    var   identfy : String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
    }
}
