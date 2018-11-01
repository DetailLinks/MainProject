//
//  WFQuikeNumberViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFQuikeNumberViewController: BaseViewController {
    

    ///手机号
    @IBOutlet weak var phoneTF: UITextField!

   ///发送验证吗
    @IBAction func sendCodeBtnClick(_ sender: Any) {
        
        if phoneTF.text == "" {
           SVProgressHUD.showInfo(withStatus: "请输入手机号")
            return
        }
        
        let nameString : NSString = phoneTF.text! as NSString
        
        if nameString.isMobileNumber()  || nameString.isMobileNumberClassification() {
            
        }else{
            
            SVProgressHUD.showInfo(withStatus: "请输入正确的手机号")
            phoneTF.text = ""
            phoneTF.becomeFirstResponder()
            return
        }

        
        NetworkerManager.shared.getFastRegisterSign(["phoneno":phoneTF.text ?? ""]) { (isSuccess) in
            
            if isSuccess == true {
                
                let vc = WFQuikeRegestController()
                     vc.phoneNumer = self.phoneTF.text ?? ""
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}

///设置界面
extension WFQuikeNumberViewController : UITextFieldDelegate{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        phoneTF.delegate = self
        navItem.title = "快速注册"
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
                    //限制长度
        
                    let proposeLength = (textField.text?.lengthOfBytes(using: String.Encoding.utf8))! - range.length + string.lengthOfBytes(using: String.Encoding.utf8)
        
                    if proposeLength > 11 { return false }
        
    
            return true
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
            
            if textField.text == "" {
                return
            }
            
            let nameString : NSString = textField.text! as NSString
            
            if nameString.isMobileNumber()  || nameString.isMobileNumberClassification() {
                
            }else{
                
                SVProgressHUD.showInfo(withStatus: "请输入正确的手机号")
                textField.text = ""
                textField.becomeFirstResponder()
            }
        }
    

}
