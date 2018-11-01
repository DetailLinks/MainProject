//
//  WFCaseHeaderView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/17.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class WFCaseEditHeaderView: UITableViewHeaderFooterView {


    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setUpUI()
        setUpConstaint()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var disposeBag = DisposeBag()
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    
    
    lazy var textView : UITextView = {
        //let contener = NSTextContainer.init()
        let tView =  UITextView.init(frame: CGRect.zero)//, textContainer: contener)
        return tView
    }()
    
    lazy var imageV : UIImageView = {
        let tView =  UIImageView.init()
//        tView.image = #imageLiteral(resourceName: "img_banner")
        tView.isUserInteractionEnabled = true
        tView.contentMode = .scaleAspectFill
        tView.clipsToBounds = true
        tView.backgroundColor = #colorLiteral(red: 0.1607843137, green: 0.8, blue: 0.737254902, alpha: 1)
        return tView
    }()

    lazy var changeImageViewBtn : UIButton = {
        let btn =  UIButton.init()
        btn.setTitle("更换封面", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        return btn
    }()
    
    lazy var btnBackView : UIView = {
        let tView =  UIView.init()
        tView.backgroundColor = .black
        tView.alpha = 0.7
        tView.layer.cornerRadius = 12
        return tView
    }()
    
    lazy var titleView : UILabel = {
        let tView =  UILabel.init()
        tView.textAlignment = .left
        tView.text = "请设置标题："
        tView.textColor = UIColor.white
        tView.font = UIFont.systemFont(ofSize: 18)
        return tView
    }()
    ///加号 按钮
    var clickBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        btn.setImage( #imageLiteral(resourceName: "Add to"), for: .normal)
        
        return btn
    }()
    var backView  : UIView  = {
        
        let btn : UIView = UIView.init()
        
        btn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        return btn
    }()
    
    var titleBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        return btn
    }()

    var imageClickBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        return btn
    }()

    

}

extension WFCaseEditHeaderView{
    
    func setUpUI() {
        contentView.addSubview(textView)
        contentView.addSubview(imageV)
        imageV.addSubview(btnBackView)
        imageV.addSubview(changeImageViewBtn)
        imageV.addSubview(titleView)
        contentView.addSubview(backView)
        contentView.addSubview(clickBtn)
        contentView.addSubview(titleBtn)
        contentView.addSubview(imageClickBtn)
    }
    
    func setUpConstaint() {
        textView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(10)
            maker.height.equalTo(0)//transHeight(202))
        }
        
        imageV.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(textView.snp.bottom).offset(0)//11.5)
            maker.height.equalTo(transHeight(315))
        }

        changeImageViewBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(12)
            maker.bottom.equalToSuperview().offset(-13.5)
            maker.height.equalTo(24)
            maker.width.equalTo(94.3)
        }
        
        btnBackView.snp.makeConstraints { (maker) in
            maker.right.left.top.bottom.equalTo(changeImageViewBtn)
        }

        titleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.top.equalToSuperview().offset(17)
            maker.right.equalToSuperview().offset(-17)
            maker.height.equalTo(30)
        }
        clickBtn.snp.makeConstraints { (maker ) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(contentView.snp.bottom).offset(-50)
        }
        
        backView.snp.makeConstraints { (maker ) in
            maker.left.right.top.bottom.equalTo(clickBtn)
        }
        
        titleBtn.snp.makeConstraints { (maker ) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(50)
        }

        imageClickBtn.snp.makeConstraints { (maker ) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(titleBtn.snp.bottom)
            maker.bottom.equalToSuperview().offset(-50)
        }


//        contentView.updateConstraints()
//        btnBackView.addCorner(roundingCorners: .topLeft, cornerSize: btnBackView.xf_size)
//        btnBackView.addCorner(roundingCorners: .bottomLeft, cornerSize: btnBackView.xf_size)
    }
}








