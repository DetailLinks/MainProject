//
//  WFWechaBindToPhoneControllerView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/7.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFWechaBindToPhoneControllerView: BaseViewController {

    var unioid = ""
    var isLogView = false
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "绑定手机号"
        
//        sendMessageBtn.layer.borderWidth = 1
//        sendMessageBtn.layer.borderColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)

    }
    
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    
    ///确定按钮
    @IBAction func loginBtnClick(_ sender: Any) {
        
        if phoneNumberTF.text == "" || passwordTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus:  "请输入验证码")
            return
        }
        
        NetworkerManager.shared.bindWeixinUid(phoneNumberTF.text!, passwordTF.text!, unioid) { (isSuccess, code ) in
            
            if isSuccess == true{
             
                ///继续注册
                if code == -2{
                    
                    DispatchQueue.main.async {
                        let vc = WFSetWechatPasswordController()
                        vc.unioid = self.unioid
                        vc.phoneNumber = self.phoneNumberTF.text!
                        self.navigationController?.pushViewController(vc , animated: true)
                    }

                    
                }else{///用户存在需要登录
                    
                    DispatchQueue.main.async {
                        AppDelegate.jpush_regest(set: [NetworkerManager.shared.userCount.id ?? ""], alias:NetworkerManager.shared.userCount.mobile ?? "")
                        
                        
                        UserDefaults.standard.set(self.phoneNumberTF.text!, forKey: user_username)
                        UserDefaults.standard.set(NetworkerManager.shared.userCount.id, forKey: user_userid)

                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)

                        if self.isLogView == true {
                            self.navigationController?.popToRootViewController(animated: true)
                        }else{
                            self.navigationController?.popViewController(animated: true)
                        }

                    }
                }
            }
        }
        
        
    }
    
    ///发送验证码按钮
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBAction func sendMessageBtnClick(_ sender: UIButton) {
        
        if phoneNumberTF.text ?? "" == "" {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            return
        }
        
        if (phoneNumberTF.text! as NSString).isMobileNumber() || (phoneNumberTF.text! as NSString).isMobileNumberClassification()   {
            
            NetworkerManager.shared.getCaptchaByLogin(phoneNumberTF.text!) {[weak self] (isSuccess) in
                
                if isSuccess == true {
                    self?.timer.fireDate = Date.distantPast
                }
            }
            
        }else{
            
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
        }
        
    }
    lazy var timer : Timer = {
        let time : Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRepeats), userInfo: nil, repeats: true)
        time.fireDate = Date.distantFuture
        return time
    }()
    
    deinit {
        
        timer.invalidate()
    }
    
    var timerNumber = 60
    /// 时间及时
    func timerRepeats() {
        
        
        timerNumber -= 1
        sendMessageBtn.backgroundColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)
        
        sendMessageBtn.setAttributedTitle(NSMutableAttributedString(
            string: "重新发送(\(timerNumber)s)",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 13) ??
                UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : UIColor.white]),
                                          for: .normal)
        
        sendMessageBtn.isUserInteractionEnabled = false
        if timerNumber == 0 {
            sendMessageBtn.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
            timerNumber = 60
            sendMessageBtn.setAttributedTitle(NSMutableAttributedString(
                string: "重新发送",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 13) ??
                    UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : UIColor.white]),
                                              for: .normal)
            
            timer.fireDate = Date.distantFuture
            sendMessageBtn.isUserInteractionEnabled = true
        }
        
    }
    
}
