//
//  WFSystemSettingViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFSystemSettingViewController: BaseViewController {

    @IBOutlet weak var logOutBtn: UIButton!
    @IBOutlet weak var versionNumberLabel: UILabel!
    @IBOutlet weak var cacheNumberLabel: UILabel!
    ///跳转修改密码界面
    @IBAction func resectPasswordClick(_ sender: Any) {
        navigationController?.pushViewController(!NetworkerManager.shared.userCount.isLogon ? WFLoginViewController() : WFResetPasswordViewController(), animated: true)
    }
    
    ///跳转第三方平台
    @IBAction func thirdPlateform(_ sender: UIButton) {
    
        navigationController?.pushViewController(!NetworkerManager.shared.userCount.isLogon ? WFLoginViewController() : WFThirdPlateFormViewController(), animated: true)
    }
    
    
    ///清除缓存
    @IBAction func cleanCacheClick(_ sender: Any) {
        
    }
    
    ///退出登录按钮
    @IBAction func logoutClick(_ sender: Any) {
        
        NetworkerManager.shared.userCount = WFUserAccount()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        UserDefaults.standard.removeObject(forKey: "selectList")
        
        AppDelegate.jpush_logout()
        
        UserDefaults.standard.removeObject(forKey: user_username)
        UserDefaults.standard.removeObject(forKey: user_userid)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_notLogout_clean_cookie), object: nil)
        
        navigationController?.popToRootViewController(animated: true)
        
        //navigationController?.pushViewController(WFLoginViewController(), animated: false)
        
    }
    
    ///接受转诊按钮
    @IBAction func reciveTransClick(_ sender: Any) {
    }
    
    ///接受会诊按钮
    @IBAction func receveMeetingClick(_ sender: Any) {
    }
    
    ///接受消息通知
    @IBAction func notificationClick(_ sender: Any) {
           UIApplication.shared.openURL(URL.init(string: UIApplicationOpenSettingsURLString)!)
    }
    
}

extension WFSystemSettingViewController{
    
}

///设置界面
extension WFSystemSettingViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "系统设置"
        
        logOutBtn.isHidden = !NetworkerManager.shared.userCount.isLogon
        
        versionNumberLabel.text = "V " + (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
    }
}
