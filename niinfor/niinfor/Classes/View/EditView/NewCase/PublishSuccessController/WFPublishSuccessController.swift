//
//  WFPublishSuccessController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/9.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFPublishSuccessController: BaseViewController {

    var model  = WFMPArticle()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navBar.isHidden = false
    }
}



extension WFPublishSuccessController{
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        addSubView()
    }
    
    func addSubView() {
        
        let mainBackView = UIView.init()
        mainBackView.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        view.addSubview(mainBackView)
        
        mainBackView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(20)
            maker.left.right.equalToSuperview()
            maker.height.equalTo(250)
        }
        
        let btnView = UIButton.init()
        btnView.backgroundColor = UIColor.white
        btnView.setAttributedTitle(NSMutableAttributedString(
            string: "✔️",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 22) ??
                UIFont.systemFont(ofSize: 22),NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]),
                                     for: .normal)

        btnView.layer.cornerRadius = 27
        mainBackView.addSubview(btnView)
        
        btnView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.width.equalTo(54)
            maker.top.equalTo(50)
        }

        let textButton = UIButton.init()
        textButton.setTitle("恭喜你！病例发布成功", for: .normal)
        mainBackView.addSubview(textButton)
        
        textButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(22)
            maker.top.equalTo(btnView.snp.bottom).offset(8)
        }

        let shareButton = UIButton.init()
        shareButton.setTitle("去分享", for: .normal)
        shareButton.backgroundColor = #colorLiteral(red: 1, green: 0.7450980392, blue: 0.1490196078, alpha: 1)
        shareButton.addTarget(self, action: #selector(shareView), for: .touchUpInside)
        shareButton.layer.cornerRadius = 22
        mainBackView.addSubview(shareButton)
        
        shareButton.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(44)
            maker.width.equalTo(170)
            maker.bottom.equalToSuperview().offset(-30)
        }
        
        let backButton = UIButton.init()
        backButton.addTarget(self, action: #selector(bacView), for: .touchUpInside)
        backButton.setImage(#imageLiteral(resourceName: "返回"), for: .normal)
        view.addSubview(backButton)
        
        backButton.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
            maker.height.width.equalTo(64)
        }

    }
    
    @objc func bacView(){
        self.navigationController?.viewControllers = [self.navigationController?.viewControllers[0]] as! [UIViewController];        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareView(){
        
        AppDelegate.shareUrl(model.articleUrl ?? "", imageString: model.cover ?? "", title: model.title ?? "", descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范", viewController: self, .wechatSession)
    }
}
