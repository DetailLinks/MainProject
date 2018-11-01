//
//  WFApproveidController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/3.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import TZImagePickerController
import SDWebImage
import SVProgressHUD

class WFApproveidController: BaseViewController,TZImagePickerControllerDelegate {
    
    var upLoadImageSuccessComletion : (()->())?
    
    var isHtmlApprove = false
    
    ///认证照片
    var empcard : String?
    
    var  isRegest  =  false
    
    
    /// 上传成功的视图
    lazy var loadSuccessView : WFUploadSuccessView = {
        
              let v =  WFUploadSuccessView.uploadSuccessView()
              UIApplication.shared.delegate?.window??.addSubview(v)
              v.isHidden = true
              return v
    }()
    
    ///上传的图片
    @IBOutlet weak var uploadImageView: UIImageView!
    
    ///上传图片按钮
    @IBOutlet weak var uploadBtn: UIButton!
    
    ///点击上传图片
    @IBAction func uploadBtnClick(_ sender: Any) {
        
        let vc = TZImagePickerController(maxImagesCount: 1 , delegate: self)
        
        vc?.didFinishPickingPhotosHandle = {(_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
            
            self.uploadImageView.image = phots?[0]
            
        }
        
        present(vc!, animated: true, completion: nil)

        
    }
    
    ///完成按钮点击
    @IBAction func accomplishBtnClick(_ sender: Any) {
        
        
        if self.uploadImageView.image == nil  {
            
            SVProgressHUD.showInfo(withStatus: "请选择照片上传");return
        }
        
        
        NetworkerManager.shared.uploadEmpcard([self.uploadImageView.image ?? UIImage() ], complict: { (isSuccess, json) in
            
        if isSuccess == true {
                
                //self.uploadImageView.sd_setImage(with:URL(string: Photo_Path + (json["empcard"] ?? "")) , placeholderImage: UIImage())
            NetworkerManager.shared.userCount.isAuth = 2
            self.loadSuccessView.isHidden = false
            if let upLoadImageSuccessComletion = self.upLoadImageSuccessComletion {
                upLoadImageSuccessComletion()
            }
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: "1")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
//                self.navigationController?.popViewController(animated: true)
            }
            
        })

    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_returnto_toot), object: nil)
    }
}

///设置界面
extension WFApproveidController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "认证信息"
        
        let url  = URL(string:   (empcard ?? ""))//Photo_Path
        
        uploadImageView.sd_setImage(with: url)
        
        NotificationCenter.default.addObserver(self, selector: #selector(popRootViewController), name: NSNotification.Name(rawValue: notifi_returnto_toot), object: nil)
        
        isHtmlApprove ? () : setRightItem()
        
    }
    
    ///设置右边的按钮
    private func setRightItem() {
        
        let btn  = UIButton(type: .custom)
        
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        
        
        btn.addTarget(self, action: #selector(popRootViewController), for: .touchUpInside)
        
        btn.setAttributedTitle(NSMutableAttributedString(
            string: "跳过",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 15) ??
                UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                               for: .normal)
        
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }

    
     func popRootViewController() {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        
        if isHtmlApprove == true {
            
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_approve_html_success), object: nil)
        }
        
        if self.isRegest == true{
            navigationController?.popToRootViewController(animated: true)
        }else{
            navigationController?.popViewController(animated: true)
            dismiss(animated: false, completion: { 
                
            })
        }
    }
    
}
