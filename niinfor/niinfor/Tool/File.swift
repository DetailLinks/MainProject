//
//  File.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/10.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import Foundation
import UIKit
import JavaScriptCore
import SVProgressHUD

@objc protocol MeetingExport : JSExport {
    
    ///点开会议 
    func homepage(_ id : String)
    ///会议注册
    func meetingRegister()
    ///会议登录
    func meetingLogin()
    ///热门会议
    func hotMeeting()
    ///本月会议
    func monthmeeting()
    ///会议搜索
    func meetingSearch()
    //认证界面
    func certification(_ id : String)
    //刷新页面的地址
    func backUrl(_ id : String)
    
    func meetinglive(_ id : String)
    
    func meetingfields(_ id : String)
    
    func informationShare(_ description : [String])
    
    func createArticle()
}

@objc class MeetingClass: NSObject,MeetingExport {
    
    func createArticle() {
        
        
        let vc = WFEditViewController()
        
        vc.view.backgroundColor = UIColor.white
        
        let nav  = WFNavigationController.init(rootViewController: vc)
        
        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController

        controler?.viewControllers.last?.present(nav, animated: true, completion: nil)
    }
    
    ///新增 分享
    func informationShare(_ description: [String]) {
        
        print(description)
        
        if (webView.shareInfoBlock != nil) {
            webView.shareInfoBlock!(description)
        }
        
    }

    
    func meetinglive(_ id: String) {
        guard let url  = URL(string:Photo_Path + id) else{
            return
        }
        
       _ = webView.load(URLRequest(url: url))

    }
    
    func meetingfields(_ id: String) {
        guard let url  = URL(string:Photo_Path + id) else{
            return
        }
        
       _ = webView.load(URLRequest(url: url))

    }
    
    
    //刷新页面的地址
    func backUrl(_ id: String) {
        
        guard let url  = URL(string:Photo_Path + id) else{
            return
        }
        
       _ = webView.load(URLRequest(url: url))
        
    }

    ///认证
    func certification(_ id: String) {
        
        var isPush = false
        switch NetworkerManager.shared.userCount.isAuth {
        ///跳转到认证界面然后跳转到主页 未认证
        case 0: isPush = true
        ///跳转到认证界面然后跳转到主页 待认证
        case 2: isPush = false
        ///跳转到认证界面然后跳转到主页 认证未通过
        case 3: isPush = true
        default: break
            
        }
        
        UserDefaults.standard.set(id, forKey: "certificationID")
        
        if isPush == true  {
        
        let vc  = WFApproveidController()
        
        vc.isHtmlApprove = true
//        myController?.navigationController?.pushViewController(vc , animated: true)
        
            
        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
            
        let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
            
        controler?.pushViewController(vc , animated: true)
            
//        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
//        
//        let nav  = WFNavigationController(rootViewController: vc)
//        
//        mainContoller?.present(nav , animated: false , completion: nil )
        
        }else{
            
            homepage(id)
           
            if NetworkerManager.shared.userCount.isAuth == 2{
                SVProgressHUD.showInfo(withStatus: "认证中，请耐心等待！")
            }

        }
        
    }
    
    ///点开会议
    func homepage(_ id : String) {
        
        guard let url  = URL(string:Photo_Path + "/meeting/homepage.jspx?&id=\(id)") else{
            return
        }
        
       _ = webView.load(URLRequest(url: url))
        //loadMeetingInfor?(url)
    }

    
    ///会议搜索
    func meetingSearch() {
        
        guard let url  = URL(string:Photo_Path + "/meeting/meetingSearch.jspx") else{
            return
        }
       _ = webView.load(URLRequest(url: url))

    }

    ///本月会议
    func monthmeeting() {
        
        guard let url  = URL(string:Photo_Path + "/meeting/monthMeeting.jspx") else{
            return
        }
       _ = webView.load(URLRequest(url: url))

    }

    ///热门会议
    func hotMeeting() {
        
        guard let url  = URL(string:Photo_Path + "/meeting/hotmeeting.jspx") else{
            return
        }
       _ = webView.load(URLRequest(url: url))

    }

    var loadMeetingInfor : ((_ url  : URL )->())?
    
   weak var jsContext : JSContext?
    var webView  = WFWkWebView()
    
   weak var myController  = BaseViewController()

    func meetingLogin() {
        
        print("需要登录")
        
        if NetworkerManager.shared.userCount.isLogon != true  {
            
            vc.isHtmlLogin = true
            
            let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
            
            let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
            
            controler?.pushViewController(vc , animated: true)
          
            
            return
        }

        webView.resendMessageToHtml(Notification(name: Notification.Name(rawValue: "")))
       //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        
//        let username  = UserDefaults.standard.value(forKey: user_username) as? String
//        let password  = UserDefaults.standard.value(forKey: user_password) as? String
//        
//        webView.evaluateJavaScript("userInfo('\(username)','\(password )')") { (json, error ) in
//            print("错误 ", json ,"这个是啥",error )
//        }


    }
    
    let vc  = WFLoginViewController()
    
    func popToParent() {
        
        vc.dismiss(animated: false) { 
            
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_notLogin_return_last), object: nil)
            
        }
        
    }
    
    func meetingRegister() {
       
    }
    
}


