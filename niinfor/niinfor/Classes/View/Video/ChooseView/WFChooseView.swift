//
//  WFChooseView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/18.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

protocol ChooseFuncBtnProtocol  {
    func btnClickWith(_ funcEnum : Int )->()
}

class WFChooseView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setUPUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var delegate : ChooseFuncBtnProtocol?
    
    fileprivate let  bacImageView = UIImageView.init()
    fileprivate let  complaintBtn = UIButton.init()
    fileprivate let  saveBtn      = UIButton.init()
    fileprivate let  projectSreen = UIButton.init()
}

///Public
extension WFChooseView {
    func setSaveBtnStatus(_ isSelected : Bool) {
         saveBtn.isSelected = isSelected
    }
}
///Action
extension WFChooseView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var chooseFrame  =  frame
        
        UIView.animate(withDuration: 0.3, animations: {
            chooseFrame.origin.x += chooseFrame.size.width
            self.frame = chooseFrame
        }) { (isTrue) in
            self.removeFromSuperview()
        }
    }
    @objc func btnClick(_ btn : UIButton){
        if (delegate != nil) {
            delegate?.btnClickWith(btn.tag)
        }
    }
}

///UI
extension WFChooseView {
    fileprivate func setUPUI() {
        addSubViews()
        setConsTaint()
    }
    
    fileprivate func addSubViews() {
        
        bacImageView.backgroundColor = UIColor.black
        bacImageView.alpha = 0.7
        
        complaintBtn.setImage(#imageLiteral(resourceName: "other_qinquan"), for: .normal)
        saveBtn.setImage(#imageLiteral(resourceName: "other_save"), for: .normal)
        saveBtn.setImage(#imageLiteral(resourceName: "other_save_on"), for: .selected)
        projectSreen.setImage(#imageLiteral(resourceName: "other_touping"), for: .normal)
        
        complaintBtn.setTitle("侵权", for: .normal)
        saveBtn.setTitle("收藏", for: .normal)
        saveBtn.setTitle("收藏", for: .selected)
        projectSreen.setTitle("投屏", for: .normal)
        
        complaintBtn.imageEdgeInsets = UIEdgeInsetsMake(-30, 0, 0, -32)
        complaintBtn.titleEdgeInsets = UIEdgeInsetsMake(30, 0, 0, 32)
        saveBtn.imageEdgeInsets      = complaintBtn.imageEdgeInsets
        saveBtn.titleEdgeInsets      = complaintBtn.titleEdgeInsets
        projectSreen.imageEdgeInsets = complaintBtn.imageEdgeInsets
        projectSreen.titleEdgeInsets = complaintBtn.titleEdgeInsets
        
        
        complaintBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        saveBtn.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        projectSreen.addTarget(self, action: #selector(btnClick(_:)), for: .touchUpInside)
        
        addSubview(bacImageView)
        addSubview(complaintBtn)
        addSubview(saveBtn)
        addSubview(projectSreen)
    }
    
    fileprivate func setConsTaint() {
        
        bacImageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
        complaintBtn.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview()
            maker.centerY.equalToSuperview()
            maker.width.height.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
        saveBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(complaintBtn.snp.right)
            maker.width.height.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
        projectSreen.snp.makeConstraints { (maker) in
            maker.centerY.equalToSuperview()
            maker.left.equalTo(saveBtn.snp.right)
            maker.width.height.equalToSuperview().multipliedBy(1.0 / 3.0)
        }
    }
}
