//
//  WFFunctionChooseView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/17.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxSwift

class WFFunctionChooseView: UIView {

    let disposeBag = DisposeBag()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpUI()
        setConstant()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var backImageView : UIImageView  = {
        let imageV = UIImageView()
        imageV.image = #imageLiteral(resourceName: "Group 12")
        return imageV
    }()
    
    var imageBtn  : UIButton  = {
        let imageV = UIButton()
        return imageV
    }()

    var textBtn  : UIButton  = {
        let imageV = UIButton()
        return imageV
    }()

    var voiceBtn  : UIButton  = {
        let imageV = UIButton()
        return imageV
    }()

    var videoBtn  : UIButton  = {
        let imageV = UIButton()
        return imageV
    }()

    private func setUpUI() {
        
        addSubview(backImageView)
        addSubview(imageBtn)
        addSubview(textBtn)
        addSubview(voiceBtn)
        addSubview(videoBtn)
    }
    
    private func setConstant() {
        
        backImageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
        imageBtn.snp.makeConstraints { (maker ) in
            maker.top.bottom.left.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.25)
        }
        textBtn.snp.makeConstraints { (maker ) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalTo(imageBtn.snp.right)
            maker.width.equalTo(imageBtn)
        }
        voiceBtn.snp.makeConstraints { (maker ) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalTo(textBtn.snp.right)
            maker.width.equalTo(textBtn)//equalToSuperview().multipliedBy(0.25)
        }
        videoBtn.snp.makeConstraints { (maker ) in
            maker.top.bottom.right.equalToSuperview()
            maker.left.equalTo(voiceBtn.snp.right)
            //maker.width.equalToSuperview().multipliedBy(0.25)
        }

        
    }
    
}
