//
//  WFMoreCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/25.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFMoreCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        contentView.addSubview(textBtn)
        
        textBtn.isUserInteractionEnabled = false
        textBtn.layer.cornerRadius = 12.5
        textBtn.layer.borderWidth = 1
        textBtn.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        textBtn.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
            maker.height.equalTo(25)
            maker.width.equalTo(68)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let textBtn = UIButton.init()
    
    
    func setSelect(_ isSelect : Bool , _ title : String) {
        
        if isSelect == true {
            textBtn.setAttributedTitle(NSAttributedString.init(string: title, attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : UIColor.white ]  ), for: .normal)
            textBtn.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
            textBtn.layer.borderColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        }else{
            textBtn.setAttributedTitle(NSAttributedString.init(string: title, attributes:[NSFontAttributeName : UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.3215686275, alpha: 1) ]  ), for: .normal)
            textBtn.backgroundColor = UIColor.white
            textBtn.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        }
    }
    
    
    func setTitle(_ title : String) {
 
        let att = [NSFontAttributeName : UIFont.systemFont(ofSize: 13),NSForegroundColorAttributeName : #colorLiteral(red: 0.3215686275, green: 0.3215686275, blue: 0.3215686275, alpha: 1) ] as [String : Any]

        textBtn.setAttributedTitle(NSAttributedString.init(string: title, attributes:att ), for: .normal)
        
        var width = (title as NSString).boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: 25), options: .usesLineFragmentOrigin, attributes: att , context: nil).size.width
        
        if width > 58 {
            width += 20
        }else{
            width = 68
        }
        print(width)
        print(title)
        
        textBtn.snp.updateConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
            maker.height.equalTo(25)
            maker.width.equalTo(width)
        }

    }
    
    
    
    
}
