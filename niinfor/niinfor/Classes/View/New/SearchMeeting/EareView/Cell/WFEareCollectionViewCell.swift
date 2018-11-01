//
//  WFEareCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFEareCollectionViewCell: UICollectionViewCell {

    var model : WFEducationModel?{
        didSet{
           
            mainLabel.setAttributedTitle(NSMutableAttributedString(string: "\(model?.name ?? "" )",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 16) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .normal)
            
        }
    }
    
    
    @IBOutlet weak var mainLabel: UIButton!
    
    @IBOutlet weak var leadingCons: NSLayoutConstraint!
    
    @IBAction func cellClick(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_eraeBtn_click), object: model?.name  ?? "" )
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        leadingCons.constant = btnSpace
    }

}
