//
//  WFSetWechatPasswordController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/7.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
class WFSetWechatPasswordController: BaseViewController , UITextFieldDelegate {

    var unioid = ""
    var phoneNumber = ""
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "设置密码"
        
        passwordTF.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
                
        let  textString : NSString  = string as NSString
        
        let s  = (textString.components(separatedBy: CharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.@_").inverted) as NSArray).componentsJoined(by: "")
        
        
        return textString as String == s
        
    }

    ///确定按钮点击
    @IBAction func ensureBtnClick(_ sender: UIButton) {
        
        if  passwordTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus:  "请输入密码" )
            return
        }
        
        if  (passwordTF.text?.count)! < 6 {
            
            SVProgressHUD.showInfo(withStatus:  "请输入的密码不少于6位" )
            return
        }

        
        NetworkerManager.shared.bindWeixinUidRegister(phoneNumber, passwordTF.text!, unioid) { (isSuccess, code ) in
            
            if isSuccess == true{
                
                AppDelegate.jpush_regest(set: [NetworkerManager.shared.userCount.id ?? ""], alias:NetworkerManager.shared.userCount.mobile ?? "")
    
                
                UserDefaults.standard.set(self.phoneNumber, forKey: user_username)
                UserDefaults.standard.set(NetworkerManager.shared.userCount.id, forKey: user_userid)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
                                
                    ///跳转到页面
                    DispatchQueue.main.async {
                        //跳转到完善信息页面
                        let vc = WFPersonalInforViewController()
                        vc.isNextStep = true
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    
            }
        }
        
    }
    
    @IBOutlet weak var passwordTF: UITextField!
    ///安全输入
    @IBAction func securtBtnClick(_ sender: Any) {
        let btn  = sender as! UIButton
        btn.isSelected =  !btn.isSelected
        
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    
    
    
}
