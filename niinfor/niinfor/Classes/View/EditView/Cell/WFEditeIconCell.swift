//
//  WFEditeIconCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/14.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFEditeIconCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
//        contentView.addSubview(clikBtn)
        
        ///添加约束
        setConstant()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)
    }
    
    
    func configModel(_ model : CollectionModel)  {
        
        iconImageView.image = UIImage.init(named: model.imageName)
        titleLabel.text = model.title
    }
    
    
    lazy var origenRect : CGRect = CGRect.zero
    
    lazy var iconImageView : UIImageView = {
        
        let imageView = UIImageView.init()
        
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        
        let label = UILabel.init()
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: transWidth(24.0))
        
        return label
    }()
    
    lazy var clikBtn : UIButton  = {
        
        let btn = UIButton.init(type: .custom)
        
        return btn
    }()
    
}

extension WFEditeIconCell{
    
    func setConstant() {
        
        iconImageView.snp.makeConstraints { (maker) in
            maker.top.left.width.right.equalToSuperview()
            maker.height.equalTo(contentView).offset( -contentView.xf_height + contentView.xf_width)
        }
        
        titleLabel.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalTo(contentView)
            maker.height.equalTo(transHeight(31.0))
        }

//        clikBtn.snp.makeConstraints { (maker) in
//            maker.top.left.bottom.right.equalTo(contentView)
//        }

    }
    
}

struct CollectionModel {
    
    var  title : String
    var imageName : String
    
    init(_ imageNam : String , _ titl : String) {
        title = titl
        imageName = imageNam
    }
}

