//
//  WFResetPasswordViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFResetPasswordViewController: BaseViewController {

    
    @IBOutlet weak var oldPasswordTF: UITextField!
    
    @IBOutlet weak var newPasswordTF: UITextField!
    
    @IBAction func oldPasswordClick(_ sender: Any) {
        
        let btn  = sender as? UIButton
        btn?.isSelected = !(btn?.isSelected ?? true)
        self.oldPasswordTF.isSecureTextEntry = !(btn?.isSelected ?? true)
        
    }
    
    @IBAction func newPasswordClick(_ sender: Any) {
        let btn  = sender as? UIButton
        btn?.isSelected = !(btn?.isSelected ?? true)
        self.newPasswordTF.isSecureTextEntry = !(btn?.isSelected ?? true)
    }
    
    @IBAction func accmplichBtnClick(_ sender: Any) {
        
        if oldPasswordTF.text == ""   {
            SVProgressHUD.showInfo(withStatus: "请输入旧密码")
            return
        }
        
        if newPasswordTF.text == ""   {
            SVProgressHUD.showInfo(withStatus: "请输入新密码")
            return
        }
        
        if  newPasswordTF.text?.count ?? 0 < 6  {
            SVProgressHUD.showInfo(withStatus: "新密码不能少于6位")
            return
        }

        
        
       let oldPWD = SWJiaMi.jiami(NetworkerManager.shared.userCount.id ?? "", passWord: oldPasswordTF.text ?? "")
       let newPWD = SWJiaMi.jiami(NetworkerManager.shared.userCount.id ?? "", passWord: newPasswordTF.text ?? "")
        NetworkerManager.shared.updatePassword(oldPWD ?? "", newPWD ?? "") { (isSuccess) in
            
            if isSuccess == true {

                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

///设置界面
extension WFResetPasswordViewController : UITextFieldDelegate{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "修改密码"
        
        newPasswordTF.delegate = self
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let  textString : NSString  = string as NSString
        
        let s  = (textString.components(separatedBy: CharacterSet(charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890.@_").inverted) as NSArray).componentsJoined(by: "")
        
        
        return textString as String == s
        
    }

}
