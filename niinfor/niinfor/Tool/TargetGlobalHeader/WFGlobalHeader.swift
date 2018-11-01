//
//  WFGlobalHeader.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/9.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import Foundation
import UIKit

//字体
let PF_M  = "PingFangSC-Medium"
let PF_R   =  "PingFangSC-Regular"

let navigation_height : CGFloat = UIApplication.shared.statusBarFrame.height + 44

var isIphoneX = UIApplication.shared.statusBarFrame.height == 44


//屏幕宽高
let Screen_width = UIScreen.main.bounds.size.width
let Screen_height = UIScreen.main.bounds.size.height

let Service_Domain : String = Photo_Path + "/api"
#if DEBUG
let  Photo_Path : String = "http://www.medtion.com"//"http:192.168.0.108"//////"http://medtion.how2go.cn:40080"//"http://www.medtion.com"//
//"http://ni.medtion.com"//"http://medtion.how2go.cn:60080"/////"http://192.168.0.182"
//"http://medtion.how2go.cn:60080"//

//"http://medtion.how2go.cn:8089"
//

//

//

//

//"http://192.168.0.16" //

//"http://ni.medtion.com"////
#else
let  Photo_Path : String = "http://www.medtion.com"
#endif
///通知字符粗
let notifi_returnto_toot = "notifi_returnto_toot"

///登录成功
let notifi_login_success = "notifi_login_success"
let notifi_login_html_success = "notifi_login_html_success"

///网页认证完进行的通知
let notifi_approve_html_success = "notifi_approve_html_success"
let notifi_little_meeting_number = "notifi_little_meeting_number"

let notifi_notLogin_return_last = "notifi_notLogin_return_last"
let notifi_notLogout_clean_cookie = "notifi_notLogout_clean_cookie"

///收到通知刷新我的消息
let notifi_mymessage_reload = "notifi_mymessage_reload"
let notifi_mymessage_deleteBtn_click = "notifi_mymessage_deleteBtn_click"

///个人信息那边修改个人信息 tf修改完成发送通知
let notifi_person_change_infomaton = "notifi_person_change_infomaton"

///草稿删除内容通知
let notifi_draft_delete_infomaton = "notifi_draft_delete_infomaton"

///点击选择地图按钮返回字符串
let notifi_eraeBtn_click = "notifi_eraeBtn_click"
let notifi_selectTable_click = "notifi_selectTable_click"

///评论成功刷新界面
let notifi_comment_success_notify = "notifi_comment_success_notify"

///点击相关视频刷新页面
let notifi_current_class_notify = "notifi_current_class_notify"

///UserDefault Key
let user_username = "user_username"
let user_password = "user_password"
let user_userid = "user_userid"
let user_data_mainKey = "user_data_mainKey"
let user_isFirstLook = "isFirstLook"
let user_subspicl_isFirstLook = "user_subspicl_isFirstLook"
let user_essey_isFirstLook = "user_essey_isFirstLook"
let user_class_video_mainKey = "user_class_video_mainKey"
let user_video_qulity_key = "user_video_qulity_key"
///字体
let fontNameString = "MicrosoftYaHei"

func transHeight(_ px : CGFloat) -> CGFloat {
    return px / 1334.0  * Screen_height
}
func transWidth(_ px : CGFloat) -> CGFloat {
    return px / 750.0  * Screen_width
}

