//
//  WFFirstLookView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/28.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit

class WFFirstLookView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setUI()
    }
    
    var complict : (()->())?
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var kownBtn = UIButton.init()
    var backImageView  = UIImageView.init()
    var bacView   = UIView.init()
    
}

extension WFFirstLookView {
    
    func setUI () {
        
        kownBtn.setBackgroundImage(#imageLiteral(resourceName: "guide_btn_know"), for: .normal)
        bacView.backgroundColor = UIColor.black
        bacView.alpha = 0.7
        kownBtn.sizeToFit()
        self.addSubview(bacView)
        self.addSubview(kownBtn)
        self.addSubview(backImageView)
        
        kownBtn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        bacView.snp.makeConstraints { (maker) in
            maker.left.top.bottom.right.equalToSuperview()
        }

    }
    
    func setTitleConstrant() {
        backImageView.image = #imageLiteral(resourceName: "guide_mp_s0")
        backImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.top.equalToSuperview().offset(navigation_height + 5)
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(backImageView.snp.bottom).offset(60)
        }
    }
    
    func setFuncConstrant() {
        backImageView.image = #imageLiteral(resourceName: "guide_mp_s1")
        backImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset( transHeight(300))
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(backImageView.snp.bottom).offset(60)
        }
    }
    
    func setVoiceConstrant() {
        backImageView.image = #imageLiteral(resourceName: "guide_mp_s3")//guide_mp_s
        backImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(transHeight(260))
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(backImageView.snp.bottom).offset(60)
        }
    }
    
    func setImageConstrant() {
        backImageView.image = #imageLiteral(resourceName: "guide_mp_s2")
        backImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.top.equalToSuperview().offset(transHeight(506))
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(backImageView.snp.bottom).offset(50)
        }
    }


    func setSubspical() {
        backImageView.image = #imageLiteral(resourceName: "guide_btn_private")//guide_btn_private
        backImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-45)
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        let otherImageV  = UIImageView.init()
        otherImageV.image = #imageLiteral(resourceName: "guide_btn_subspec")
        addSubview(otherImageV)
        otherImageV.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview().offset(-30)
            maker.right.equalToSuperview().offset(-transWidth(80))
        }
        
        let privateBtn  = WFShadowButton.init()
        let subspecialtyBtn  = WFShadowButton.init()
        self.addSubview(privateBtn)
        self.addSubview(subspecialtyBtn)
        
        privateBtn.backgroundColor = UIColor.white
        privateBtn.setImage(#imageLiteral(resourceName: "公开"), for: .normal)
        privateBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 公开",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2509803922, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                      for: .normal)
        
        subspecialtyBtn.backgroundColor = UIColor.white
        subspecialtyBtn.setImage(#imageLiteral(resourceName: "专业"), for: .normal)
        subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 亚专业",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]),
                                           for: .normal)
        
        privateBtn.snp.makeConstraints { (maker ) in
            maker.left.bottom.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(Screen_width / 2)
        }
        subspecialtyBtn.snp.makeConstraints { (maker ) in
            maker.right.bottom.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(Screen_width / 2)
        }
    }
    
    func setEssay() {
        backImageView.image = #imageLiteral(resourceName: "guide_btn_private")//guide_btn_private
        backImageView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().offset(-45)
        }
        kownBtn.snp.makeConstraints { (maker) in
            maker.centerX.centerY.equalToSuperview()
        }
        let privateBtn  = WFShadowButton.init()
        self.addSubview(privateBtn)
        
        privateBtn.backgroundColor = UIColor.white
        privateBtn.setImage(#imageLiteral(resourceName: "公开"), for: .normal)
        privateBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 公开",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2509803922, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                      for: .normal)
        
        privateBtn.snp.makeConstraints { (maker ) in
            maker.centerX.bottom.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(Screen_width / 2)
        }
    }

    
    @objc func btnClick() {
        removeFromSuperview()
        if complict != nil  {
           complict!()
        }
    }
}












