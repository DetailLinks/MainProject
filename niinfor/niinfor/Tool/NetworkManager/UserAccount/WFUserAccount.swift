//
//  WFUserAccount.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/27.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import YYModel

class WFUserAccount: NSObject {

    var id : String?
    var username : String?
    var realName : String?
    
    ///微信Uid
    var weixinUid : String?
    
    ///认证照片
    var empcard : String?
    
   
    ///是否认证  0：未认证；1：已认证；2：待认证 ； 3：认证未过'
    var isAuth = -1
    var avatarAddress : String?
    
    var avatarAddressString : String{
        return (avatarAddress ?? "")//Photo_Path + (avatarAddress ?? "") //
    }
    
   ///T：完善信息过了  F ：需要完善信息
    var isPerfectInformation : String?
    
    ///邮箱
    var email : String?
    ///出生日期
    var birthDate : String?
    ///性别
    var gender : String?
    var genderString : String{
        if gender == "M" || gender == "男" {
            return "男"
        }else if gender == "F" || gender == "女"{
            return "女"
        }else{
            return "请选择"
        }
    }
    
    ///手机
    var mobile : String?
    ///医院
    var company : String?
    ///科室
    var department : String?
    ///专业
    var speciality : String?
    ///职称
    var title : String?
    var education : String?
    
    var subSpecial : String?
    
    
    var isLogon : Bool {
        return (id ?? "") != ""
    }
    
    
    
    override var description: String{
        return yy_modelDescription()
    }
    
}
