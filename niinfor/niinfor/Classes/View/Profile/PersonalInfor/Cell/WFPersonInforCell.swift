//
//  WFPersonInforCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFPersonInforCell: UITableViewCell ,UITextFieldDelegate{

    var model : AnyObject? {
        didSet{
            verifyLabel.isHidden = true
            avatarImageView.isHidden = true
            rightImageView.isHidden = true
            starImageView.isHidden = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTF.delegate = self
        
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = mainLabel.text
        if textField.text == "请输入电子邮箱" {
          textField.text = ""
        }
        mainLabel.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if headTitle.text == "邮箱" {
            
            if isValidEmail(textField.text ?? "") == false {
                mainLabel.text = textField.text ?? ""
//                SVProgressHUD.showInfo(withStatus: "邮箱格式不正确")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_person_change_infomaton), object: nil, userInfo: ["title":mainLabel.text ?? "","tag":"\(textField.tag)"])

                return
            }
        }
        
        if textField.text != "" {
            mainLabel.text = textField.text
            mainLabel.isHidden = false
            textField.text = ""
        }else{
            mainLabel.isHidden = false
        }
        
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_person_change_infomaton), object: nil, userInfo: ["title":mainLabel.text ?? "","tag":"\(textField.tag)"])
       
    }
    
    
    private func isValidEmail(_ emailString : String ) -> Bool {
        
        let precidtString  = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailP : NSPredicate =  NSPredicate(format: "SELF MATCHES %@", precidtString)
        
        return emailP.evaluate(with: emailString)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
          

    }
    
    
    @IBOutlet weak var buttomLabel: UIImageView!
    /// 内容label
    @IBOutlet weak var mainLabel: UILabel!
    
    /// 右边箭头视图
    @IBOutlet weak var rightImageView: UIImageView!
    
    /// namelabel
    @IBOutlet weak var headTitle: UILabel!
    
    /// 星星视图
    @IBOutlet weak var starImageView: UIImageView!
 
    /// 主要内容标题
    @IBOutlet weak var contentTF: UITextField!
    
    /// 用户图像
    @IBOutlet weak var avatarImageView: UIImageView!
    
    /// 认证标题
    @IBOutlet weak var verifyLabel: UILabel!
    
    
}
