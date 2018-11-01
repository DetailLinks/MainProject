//
//  WFSubCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/9.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFSubCollectionViewCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(subBtn)
        
        subBtn.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    func configModel(_ model : WFMPSubSpecialty, _ selected : Bool = false ) {
        subBtn.setAttributedTitle(NSMutableAttributedString(
            string: "\(model.name)",
            attributes: [NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size: 15) ??
                UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName : #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)]),
                               for: .normal)
        subBtn.setAttributedTitle(NSMutableAttributedString(
            string: "\(model.name)",
            attributes: [NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size: 15) ??
                UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]),
                                  for: .selected)
        
        if selected {
            subBtn.isSelected = true
        }

    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var subBtn : UIButton = {
        let but =  UIButton.init()
        but.layer.borderWidth = 0.5
        but.layer.cornerRadius = 2
        but.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
        but.isUserInteractionEnabled = false
        return but
    }()
}
