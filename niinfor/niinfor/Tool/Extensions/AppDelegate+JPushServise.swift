//
//  AppDelegate+JPushServise.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/8/4.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

import UserNotifications


// MARK: - 给appdelegate添加Jpsh分类
extension AppDelegate:JPUSHRegisterDelegate{
    
    func f_jpushOriginalSet(launchOptions: [UIApplicationLaunchOptionsKey: Any]?)  {
    
        //集成腾讯Bugly
         Bugly.start(withAppId: "900051549")
        
        //初始化 apns
        let entity = JPUSHRegisterEntity()
        
        entity.types = Int(JPAuthorizationOptions.alert.rawValue) |  Int(JPAuthorizationOptions.sound.rawValue) |  Int(JPAuthorizationOptions.badge.rawValue)
        
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        //初始化Jpush
        JPUSHService.setup(withOption: launchOptions, appKey: "1554ff5238f2c391cd875933", channel: "APPStore", apsForProduction: true)
     
        //监听自定义消息的接收
        let defaultCenter =  NotificationCenter.default
             defaultCenter.addObserver(self, selector: #selector(networkDidReceiveMessage(notification:)),
             name:Notification.Name.jpfNetworkDidReceiveMessage, object: nil)
        
    }
}

// MARK: - 代理方法
extension AppDelegate{
    
    //收到自定义消息
    func networkDidReceiveMessage(notification:Notification){
       
        var userInfo =  notification.userInfo!
        //获取推送内容
     
        let model  = WFMessageModel(title: userInfo["title"] as? String ?? "", content: userInfo["content"] as? String ?? "", timeString: String(format: "%.0f", Date(timeIntervalSinceNow: 0).timeIntervalSince1970))//Date().timeIntervalSince1970)
        
        userList.append(model)
        
        saveData()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_mymessage_reload), object: nil)
       
        //显示获取到的数据
        let alertController = UIAlertController(title: "消息提醒",
                                                message: userInfo["content"] as? String ?? "",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .cancel, handler: nil))
        self.window?.rootViewController!.present(alertController, animated: true, completion: nil)
    }
    
    ///注册APNs成功并上报DeviceToken
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        /// Required - 注册 DeviceToken
        JPUSHService.registerDeviceToken(deviceToken)
        print("注册失APNs -- 极光推送\(deviceToken)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        ///注册失败 可选
        print("注册失败 极光推送\(error)")
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        JPUSHService.handleRemoteNotification(userInfo)
        print("收到消息 极光推送\(userInfo)")
    }
    
    ///添加处理APNs通知回调方法
    // iOS 10 Support
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!, withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        //这个在app内收到跳转消息   redirect
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
    }
    
    @available(iOS 10.0, *)
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        //required 从外面点击进来
        let userInfo  = response.notification.request.content.userInfo
        
        if response.notification.request .isKind(of: UNPushNotificationTrigger.self) {
            JPUSHService.handleRemoteNotification(userInfo)
        }
        
        isNotification = true 
        
        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        if mainContoller?.screenSecond != 0{
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                
                let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
                
                let vc  = WFVideoDetailController()
                
                vc.htmlString = userInfo["redirect"] as? String ?? ""
                
                if vc.htmlString == "" {
                    
                }else{
                    
                    controler?.pushViewController(vc , animated: true)
                    
                }
            }
        }else{
            
            let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
            
            let vc  = WFVideoDetailController()
            
            vc.htmlString = userInfo["redirect"] as? String ?? ""
            
            if vc.htmlString == "" {
                
            }else{
                
                controler?.pushViewController(vc , animated: true)
                
                
            }
        }
        completionHandler()
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        
        if UIApplication.shared.applicationState == UIApplicationState.active {
            
        }else {
            
            isNotification = true
            
            let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
            
            if mainContoller?.screenSecond != 0{
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
                    
                    let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
                    
                    let vc  = WFVideoDetailController()
                    
                    vc.htmlString = userInfo["redirect"] as? String ?? ""
                    
                    if vc.htmlString == "" {
                        
                    }else{
                        
                        controler?.pushViewController(vc , animated: true)
                        
                    }
                }
            }else{
                
                let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
                
                let vc  = WFVideoDetailController()
                
                vc.htmlString = userInfo["redirect"] as? String ?? ""
                
                if vc.htmlString == "" {
                    
                }else{
                    
                    controler?.pushViewController(vc , animated: true)
                    
                }
            }
                }
        
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    // 清除通知栏和角标
    func applicationWillEnterForeground(application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        application.cancelAllLocalNotifications()
    }  
    
}



// MARK: - 注册和登录进行的操作 注册jpsh
extension AppDelegate {
    
    class func jpush_regest(set : Set<String>, alias : String) {
        
        MobClick.profileSignIn(withPUID: NetworkerManager.shared.userCount.id ?? "")
        
        JPUSHService.setTags(set, alias: alias) { (iResCode, iTags, iAlias) in
            
            
            
            print(iResCode,iTags ?? "",iAlias ?? "")
            print("iResCode ======\(iResCode)" + "itage========\(String(describing: iTags))" +  "iAlias===\(String(describing: iAlias))")
        }
        
    }
    
    class func jpush_logout() {
        
        MobClick.profileSignOff()
        
        JPUSHService.setTags([], alias: "") { (iResCode, iTags, iAlias) in
            
            print("iResCode\(iResCode)")
            print("iTags==\(String(describing: iTags))")
            print("iAlias=\(iAlias ?? "")")
            
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        JPUSHService.setBadge(0)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

