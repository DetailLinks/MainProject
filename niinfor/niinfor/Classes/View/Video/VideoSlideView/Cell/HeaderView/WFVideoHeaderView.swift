//
//  WFVideoHeaderView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

protocol MoreBtnClickProtocol {
    func headerViewMoreBtnClick(_ video : WFVideoHeaderView)
}

class WFVideoHeaderView: UIView {

    var title : String?{
        return titleView.text
    }
    
    
    init(_ title : String ,_ frame: CGRect , _ contentString : String) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setUI()
        
        titleView.text = title
        contentLabel.text = contentString
        moreBtnView.isHidden = contentString != ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : MoreBtnClickProtocol?
    
    
    fileprivate var colorView    = UIView.init()
    fileprivate var titleView    = UILabel.init()
    fileprivate var contentLabel  = UILabel.init()
    fileprivate var moreBtnView  = UIButton.init()
    
    @objc func moreBtnClick(_ btn : UIButton) {
        if let delegate = delegate {
            delegate.headerViewMoreBtnClick(self)
        }
    }
}
extension WFVideoHeaderView{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        titleView.text   = "华山医院神经外科：动脉瘤脑鸡血"
        colorView.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        
        setLabelConfige(titleView, 16, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        setLabelConfige(contentLabel, 12, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        
        moreBtnView.setAttributedTitle(NSAttributedString.init(string: "更多", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        
        moreBtnView.addTarget(self, action: #selector(moreBtnClick(_:)), for: .touchUpInside)
        addSubview(titleView)
        addSubview(colorView)
        addSubview(contentLabel)
        addSubview(moreBtnView)
    }
    fileprivate func setConstraint() {
        colorView.snp.makeConstraints { (maker) in
            maker.width.equalTo(4)
            maker.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.left.equalToSuperview().offset(15)
        }
        titleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(colorView).offset(10)
            maker.top.height.equalTo(colorView)
        }
        contentLabel.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-13)
            maker.bottom.top.equalToSuperview()
        }
        moreBtnView.snp.makeConstraints { (maker) in
            maker.width.equalTo(50)
            maker.bottom.top.right.equalToSuperview()
        }
}
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }
}
