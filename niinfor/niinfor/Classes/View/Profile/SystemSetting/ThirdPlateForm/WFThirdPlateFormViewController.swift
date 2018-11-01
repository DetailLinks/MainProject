//
//  WFThirdPlateFormViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/7.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFThirdPlateFormViewController: BaseViewController {

    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        navItem.title = "第三方平台"
        
       bindBtn.layer.cornerRadius = 4
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NetworkerManager.shared.getUserByLogin(NetworkerManager.shared.userCount.id ?? "") { (isSuccess ) in
            
            if isSuccess == true {
                
                DispatchQueue.main.async {
                    self.bindBtn.isSelected = NetworkerManager.shared.userCount.weixinUid ?? "" != ""
                }
                
            }
        }
    }
    
    @IBOutlet weak var bindBtn: UIButton!
    
    @IBAction func bindToBtnClick(_ sender: UIButton) {
      
        if sender.isSelected {
            
         NetworkerManager.shared.cancleBindWeixin { (isSuccess, code ) in
            
            if isSuccess == true{
                NetworkerManager.shared.userCount.weixinUid = ""
                sender.isSelected = !sender.isSelected
            }
            
            }
            
        }else{
            
            UMSocialManager.default().getUserInfo(with: .wechatSession, currentViewController: nil) { (result , error ) in
                
                let result  = result as? UMSocialUserInfoResponse
                print(result?.unionId)
                if error == nil {
                    
                    NetworkerManager.shared.unionidIsExist(result?.unionId ?? "", complict: { (isSuccess, code) in
                        
                        if isSuccess == true{
                            
//                            ///绑定手机号
//                            if code == -2{
//
//                                DispatchQueue.main.async {
//
//                                    let vc = WFWechaBindToPhoneControllerView()
//                                    vc.unioid = result?.unionId ?? ""
//                                    self.navigationController?.pushViewController(vc, animated: false)
//                                }
//
//                            }else{
////                                DispatchQueue.main.async {
////                                   NetworkerManager.shared
////                                }
//                            }
//
//                        }
                            
                            NetworkerManager.shared.userIdBindWeixin(result?.unionId ?? "", complict: { (isSuccess, code ) in
                                
                                DispatchQueue.main.async {
                                    
                                    if isSuccess == true {
                                        sender.isSelected = !sender.isSelected
                                    }
                                    
                                }
                                
                                
                            })
                        }

                            
                    })
                    
                }
            }
            
            
        }
        
    }
    
}
