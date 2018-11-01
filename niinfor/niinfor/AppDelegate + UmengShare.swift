//
//  AppDelegate + UmengShare.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/9.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit


extension AppDelegate{
    
        
        
    }



extension AppDelegate{
    
    func setUmengShare(_ appKey : String) {
        
        ///友盟统计
        setAnalizy()
        
        //打开友盟日志
        //UMSocialManager.default().openLog(true)
        UMSocialManager.default().umSocialAppkey = "5a961a7ba40fa3430d00001c"//"56a7807be0f55a7a19000cda"
        UMSocialManager.default().umSocialAppSecret = ""
        
        UMConfigure.setLogEnabled(true)
        configUSharePlatforms()
    }
    
    private func setAnalizy() {
        
//        UMAnalyticsConfig.sharedInstance().appKey = "5a961a7ba40fa3430d00001c"
        //UMAnalyticsConfig.sharedInstance().channelId = "App Store"
        
//        MobClick.start(withConfigure: UMAnalyticsConfig.sharedInstance())
       
        
//        let dict  = Bundle.main.infoDictionary
//
//        let currentVersion  = dict?["CFBundleShortVersionString"] as? String
//
//        MobClick.setAppVersion(currentVersion)
        
        ///新版Version 5a961a7ba40fa3430d00001c
        UMConfigure.initWithAppkey("5a961a7ba40fa3430d00001c", channel: "App Store")
//        UMConfigure.sets
    }

    ///设置分享平台
    private func configUSharePlatforms() {
        
//
        UMSocialManager.default().setPlaform(.wechatSession, appKey: "wxb9379cacd09b3e99", appSecret: "63b4ff9d26607c73556b0033379f2067", redirectURL: "http://mobile.umeng.com/social")
        UMSocialManager.default().setPlaform(.QQ, appKey: "1104796793", appSecret: nil, redirectURL: nil)
       //UMSocialManager.default().setPlaform(.sina, appKey: "", appSecret: "", redirectURL: "")//1106493842
    
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let result  = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        
        if result == false  {
            
            
            
        }
        return result
    }
    
    //    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject])
    //        -> Bool {
    //
    //
    //            return result
    //    }
    
    //    - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
    
    
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        
        let result  = UMSocialManager.default().handleOpen(url)
        
        if result == false  {
            
        }
        return result
    }
    

    
    ///分享按钮
    class  func shareUrl(_ url : String , imageString : String , title : String , descriptionString : String,  viewController : BaseViewController ,_ type :  UMSocialPlatformType)  {
        
        UMSocialUIManager.showShareMenuViewInWindow { (plateform, userInfo) in
            
            
            let messageObject = UMSocialMessageObject()
            
            //使用的图像
            let  thumnail  = UIImage(named: imageString)
            
            if thumnail == nil {
                let imageView = UIImageView()
                
                if let urls = URL(string: imageString) {
                    
                    imageView.sd_setImage(with:urls)
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        
                        umnegShare(thumnail: imageView.image ?? #imageLiteral(resourceName: "24321528943095_.pic"), url: url, title: title, descriptionString: descriptionString, messageObject: messageObject, plateform: plateform, viewController: viewController)
                        
                    })
                    
                }else {
                    umnegShare(thumnail: #imageLiteral(resourceName: "24321528943095_.pic"), url: url, title: title, descriptionString: descriptionString, messageObject: messageObject, plateform: plateform, viewController: viewController)
                    
                }
                
            }else{
                
                umnegShare(thumnail: thumnail!, url: url, title: title, descriptionString: descriptionString, messageObject: messageObject, plateform: plateform, viewController: viewController)
                
            }
            
        }
    }
    
    
    private class func umnegShare(thumnail : UIImage , url : String, title : String , descriptionString : String, messageObject : UMSocialMessageObject ,plateform : UMSocialPlatformType ,viewController : BaseViewController ) {
        
        let shareObject  = UMShareWebpageObject.shareObject(withTitle: title, descr: descriptionString, thumImage: thumnail)
        
        shareObject?.webpageUrl = url
        
        messageObject.shareObject = shareObject
        
        UMSocialManager.default().share(to: plateform , messageObject: messageObject, currentViewController: viewController) { (data , error ) in
            
            if error != nil {
                print(error ?? "" )
            }else{
                
                if let data = data as? UMSocialShareResponse  {
                    
                    print(data.message)
                    //第三方原始返回的数据
                    print(data.originalResponse)
                }
            }
        }
        
    }
    
    
//    ///分享按钮
//    class  func shareUrl(_ url : String , imageString : String , title : String , descriptionString : String,  viewController : BaseViewController ,_ type :  UMSocialPlatformType)  {
//
//        UMSocialUIManager.showShareMenuViewInWindow { (plateform, userInfo) in
//
//
//        let messageObject = UMSocialMessageObject()
//
//        //使用的图像
//        let thumnail  = UIImage(named: imageString)
//
//        let shareObject  = UMShareWebpageObject.shareObject(withTitle: title, descr: descriptionString, thumImage: thumnail)
//
//        shareObject?.webpageUrl = url
//
//        messageObject.shareObject = shareObject
//
//        UMSocialManager.default().share(to: plateform , messageObject: messageObject, currentViewController: viewController) { (data , error ) in
//
//            if error != nil {
//                print(error ?? "" )
//            }else{
//
//                if let data = data as? UMSocialShareResponse  {
//
//                    print(data.message)
//                    //第三方原始返回的数据
//                    print(data.originalResponse)
//                }
//            }
//        }
//    }
//    }
    
//    func   open(_ url: URL, options: [String : Any] = [:], completionHandler completion: ((Bool) -> Void)? = nil){
//        
//        let result = UMSocialManager.default().handleOpen(url, sourceApplication: options, annotation: nil)
//        
//        
//    }
    
//    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
//        
//        let result = UMSocialManager.default().handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
//        
//        if result == false {
//            
//        }
//        
//        return result
//    }
    
    
    // 支持所有iOS系统
    //     application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
    //    {
    
    //    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    //    if (!result) {
    //    // 其他如支付等SDK的回调
    //    }
    //    return result;
    //    }
    


}
