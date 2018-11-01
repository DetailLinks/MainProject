//
//  WFLoginViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFLoginViewController: BaseViewController,UITextFieldDelegate {

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        passwordTF.text = ""
        phoneNumberTF.text = ""
        
    }

    
    var isHtmlLogin  = false
    
    
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    @IBOutlet weak var passwordTF: UITextField!
   
    @IBOutlet weak var navgationBarConstant: NSLayoutConstraint!
    ///忘记密码
    @IBAction func forgotPasswordBtnclick(_ sender: Any) {
        
        navigationController?.pushViewController(WFForgotpasswordViewController(), animated: true)
    }
    ///安全输入
    @IBAction func securtBtnClick(_ sender: Any) {
        let btn  = sender as! UIButton
        btn.isSelected =  !btn.isSelected
    
        passwordTF.isSecureTextEntry = !btn.isSelected
    }
    
    ///登录按钮
    @IBAction func loginBtnClick(_ sender: Any) {
        
        if phoneNumberTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus: "请输入手机号" )
            return
        }
        if passwordTF.text == "" {
            
            SVProgressHUD.showInfo(withStatus: pawdBtn.isSelected ? "请输入密码" : "请输入验证码")
            return
        }
        
        
        

        pawdBtn.isSelected ? loginWithPassword() : loginWithCode()
       
    }
    
    @IBOutlet weak var pawdBtn: UIButton!
    ///点击账号登录按钮
    @IBAction func pswdLoginBtnClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        chooseBtnLogin()
        vericodeBtn.isSelected = !vericodeBtn.isSelected
        
    }
    
    @IBOutlet weak var vericodeBtn: UIButton!
    ///点击验证码登录按钮
    @IBAction func verifyCodeLoginBtnClick(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        pawdBtn.isSelected = !pawdBtn.isSelected
        chooseBtnLogin()
        
    }
    
    private func chooseBtnLogin() {
        
        passwordTF.text = ""
        phoneNumberTF.text = ""
        
        sendMessageBtn.isHidden = pawdBtn.isSelected
        isSecretBtn.isHidden = !pawdBtn.isSelected
        
        phoneNumberTF.placeholder =   "请输入您的手机号"
        passwordTF.placeholder = pawdBtn.isSelected ? "请输入密码" : "请输入验证码"
        
        passwordTF.isSecureTextEntry = pawdBtn.isSelected
        
        backViewLeadingCons.constant = pawdBtn.isSelected ? 0 : Screen_width / 2
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }

    }
    
    
    @IBOutlet weak var backViewLeadingCons: NSLayoutConstraint!
    @IBOutlet weak var backLineView: UIView!
    
    @IBOutlet weak var isSecretBtn: UIButton!
    
    ///发送验证码按钮
    @IBOutlet weak var sendMessageBtn: UIButton!
    @IBAction func sendMessageBtnClick(_ sender: UIButton) {
        
        if phoneNumberTF.text ?? "" == "" {
            SVProgressHUD.showError(withStatus: "请输入手机号")
            return
        }
        
        let nameString : NSString = phoneNumberTF.text! as NSString
        
        if nameString.isMobileNumber() || nameString.isEmailAddress() || nameString.isMobileNumberClassification() {
            
        }else{
            
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号")
            phoneNumberTF.text = ""
            return
        }
        
        if (phoneNumberTF.text! as NSString).isMobileNumber()  {
            
            NetworkerManager.shared.getCaptchaByLogin(phoneNumberTF.text!) {[weak self] (isSuccess) in
                
                if isSuccess == true {
                 self?.timer.fireDate = Date.distantPast
                }
            }
            
        }else{
            
            SVProgressHUD.showError(withStatus: "请输入正确的手机号")
        }

    }

    
    @IBOutlet weak var wechatBtn: UIButton!
    ///微信第三方登录
    @IBAction func wechatLogin(_ sender: UIButton) {

        UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: nil) { (result , error ) in
            
            let result  = result as? UMSocialUserInfoResponse
            
            if error == nil {
                
                NetworkerManager.shared.unionidIsExist(result?.unionId ?? "", complict: { (isSuccess, code) in
                    
                    if isSuccess == true{
                     
                        ///绑定手机号
                        if code == -2{
                            
                            DispatchQueue.main.async {
                            
                                let vc = WFWechaBindToPhoneControllerView()
                                vc.isLogView = true 
                                vc.unioid = result?.unionId ?? ""
                                self.navigationController?.pushViewController(vc, animated: false)
                            }

                        }else{
                            DispatchQueue.main.async {
                                self.isLoginSuccess(isSuccess, code)
                            }
                        }
                    }
                })
                
            }
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

///设置界面
extension WFLoginViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "登录"
        
        navgationBarConstant.constant = 130 + navigation_height - 64
        wechatBtn.isHidden = !UMSocialManager.default().isInstall(.wechatSession)
        
        self.phoneNumberTF.delegate = self
        setRightItem()
    }
    
    ///完成按钮
    private func setRightItem(){
        
        let btn  = UIButton.cz_textButton("注册", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        btn?.addTarget(self, action: #selector(rightItmClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn!)
        
//        sendMessageBtn.layer.borderWidth = 1
//        sendMessageBtn.layer.borderColor = #colorLiteral(red: 0.6549019608, green: 0.6549019608, blue: 0.6549019608, alpha: 1)
        
    }
    
    @objc func rightItmClick() {
        navigationController?.pushViewController(WFQuikeNumberViewController(), animated: true)
    }
    
}

extension WFLoginViewController{
    
    ///通过密码登录
    func loginWithPassword() {
        
        let passwordString = SWJiaMi.jiami(phoneNumberTF.text ?? "", passWord: passwordTF.text ?? "")
        
        NetworkerManager.shared.loginRequest(UsernameAndPassword: ["username":phoneNumberTF.text ?? "","password":passwordString ?? ""]) { (isSuccess , code ) in
            
            self.isLoginSuccess(isSuccess,code )
        }
        
    }
    
    ///通过验证码登录
    func loginWithCode() {
        
        NetworkerManager.shared.captchaLogin(userNameAndCode: ["username" : phoneNumberTF.text!,
                                                               "captcha"  :  passwordTF.text!
                                                               ]){ (isSuccess ,code ) in
         self.isLoginSuccess(isSuccess,code)
        }
        
    }
    
    func isLoginSuccess( _ isSuccess : Bool , _ code : Int) {
        
        if isSuccess == true {
            
            if code == -2  {
                
                let alertController = UIAlertController(title: "提示", message: "用户尚未注册，是否注册用户？", preferredStyle: .alert)
                
                let action  = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let action1  = UIAlertAction(title: "注册", style: .default, handler: {(_) in
                    alertController.dismiss(animated: false, completion: nil)
                    
//                    self.rightItmClick()
                    
                    let vc  = WFSetWechatPasswordController()

                    vc.phoneNumber = self.phoneNumberTF.text ?? ""
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                  })
                
                alertController.addAction(action)
                alertController.addAction(action1)
                present(alertController, animated: true, completion: nil)
                
                return
            }
            
            if NetworkerManager.shared.userCount.isPerfectInformation == "F" {
                
                let vc = WFPersonalInforViewController()
                vc.isNextStep = true
                self.navigationController?.pushViewController(vc, animated: true)
                
                return
            }
            AppDelegate.jpush_regest(set: [NetworkerManager.shared.userCount.id ?? ""], alias:NetworkerManager.shared.userCount.mobile ?? "")
            
            if self.isHtmlLogin == true {self.dismiss(animated: false , completion: nil)}
            
            UserDefaults.standard.set(self.phoneNumberTF.text, forKey: user_username)
            //                UserDefaults.standard.set(self.passwordTF.text, forKey: user_password)
            UserDefaults.standard.set(NetworkerManager.shared.userCount.id, forKey: user_userid)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
            
            if  self.isHtmlLogin == true {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
            }
            
            if isShowBack == true{
                dismiss(animated: true , completion: nil )
                return
            }
            
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}


///UITextField delegate
extension WFLoginViewController{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
//        if self.passwordTF == textField || self.phoneNumberTF == textField {
//
//            //限制只能输入数字，不能输入特殊字符
//
//            let length = string.lengthOfBytes(using: String.Encoding.utf8)
//
//            //            if (length as NSString).length > 11 {
//            //                return false
//            //            }
//
//            for loopIndex in 0..<length {
//
//                let char = (string as NSString).character(at: loopIndex)
//
//                if char < 48 {return false }
//
//                if char > 57 {return false }
//
//            }
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

    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//        if textField == self.phoneNumberTF {
//
//            if textField.text == "" {
//                return
//            }
//
//            let nameString : NSString = textField.text! as NSString
//
//            if nameString.isMobileNumber() || nameString.isEmailAddress() || nameString.isMobileNumberClassification() {
//
//            }else{
//
//                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号或邮箱")
//                textField.text = ""
//                textField.becomeFirstResponder()
//            }
//        }
//
//    }
    
}









