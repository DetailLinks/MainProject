//
//  WFQuikeRegestController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFQuikeRegestController: BaseViewController {

    var phoneNumer  = ""
    
    @IBOutlet weak var codeNumberTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
    
    ///重新发送验证码
    @IBOutlet weak var resendBtn: UIButton!
    
    @IBAction func resendBtnClick(_ sender: Any) {
    
        timer.fireDate = Date.distantPast
        
        NetworkerManager.shared.getFastRegisterSign(["phoneno":phoneNumer]) { (isSuccess) in
            
            if isSuccess == true {

                SVProgressHUD.showInfo(withStatus: "发送验证码成功")
            }
        }

        
    }
    
    ///注册按钮
    @IBAction func regestBtnClick(_ sender: Any) {
    
        if  codeNumberTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus: "请输入验证码")
            return
        }
        
        if  passwordTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus: "请输入密码")
            return
        }
        
        if (passwordTF.text?.count)! < 6 {
            SVProgressHUD.showInfo(withStatus: "输入的密码不能少于6位")
            return
        }
        
    let passwordString = SWJiaMi.jiami( phoneNumer, passWord: passwordTF.text ?? "")
        
        
    NetworkerManager.shared.fastRegister(["password":passwordString ?? "","captcha":codeNumberTF.text ?? "","username":phoneNumer]) { (iSuccess) in
        
        if iSuccess == true {
            
            UserDefaults.standard.set(self.phoneNumer, forKey: user_username)
            UserDefaults.standard.set(self.passwordTF.text, forKey: user_password)
            UserDefaults.standard.set(NetworkerManager.shared.userCount.id ?? "", forKey: user_userid)
        //跳转到完善信息页面
        let vc = WFPersonalInforViewController()
         
        vc.isNextStep = true
            
        self.navigationController?.pushViewController(vc, animated: true)
         
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        
        }
        }
        
    }
    
    ///是不是隐藏
    @IBAction func isSecretBtnClick(_ sender: Any) {
    
        let btn  = sender as! UIButton
        btn.isSelected = !btn.isSelected
        
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        timer.fireDate = Date.distantPast
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
        resendBtn.backgroundColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)
        resendBtn.setAttributedTitle(NSMutableAttributedString(
            string: "重新发送(\(timerNumber)s)",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 13) ??
                UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : UIColor.white]),
                                   for: .normal)
        
        resendBtn.isUserInteractionEnabled = false
        if timerNumber == 0 {
            timerNumber = 60
            resendBtn.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
            resendBtn.setAttributedTitle(NSMutableAttributedString(
                string: "重新发送",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 13) ??
                    UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : UIColor.white]),
                                       for: .normal)
            
            timer.fireDate = Date.distantFuture
            resendBtn.isUserInteractionEnabled = true
        }
        
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //
        ////            //限制长度
        ////
        ////            let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        ////
        ////            if proposeLength > 11 { return false }
        //
        //        }
        
        
        
        let  textString : NSString  = string as NSString
        
        let s  = (textString.components(separatedBy: CharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.@_").inverted) as NSArray).componentsJoined(by: "")
        
        
        return textString as String == s
        
    }

}

///设置界面
extension WFQuikeRegestController: UITextFieldDelegate{
    
    override func setUpUI() {
        super.setUpUI()
        
        passwordTF.delegate = self
        removeTabelView()
        navItem.title = "快速注册"
    }
    
}
