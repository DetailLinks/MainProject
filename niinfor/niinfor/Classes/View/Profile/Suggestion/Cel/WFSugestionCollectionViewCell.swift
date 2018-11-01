//
//  WFSugestionCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/5.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFSugestionCollectionViewCell: UICollectionViewCell {

    var cellSelected  = false {
        didSet{
            if cellSelected == true  {
                
               suggestionBtn.isSelected = true
               suggestionBtn.layer.borderColor = #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1).cgColor
                
            }
        }
    }
    
    
    
    var cellTitle : String?{
        didSet{
            
            suggestionBtn.setAttributedTitle(NSMutableAttributedString(
                string: cellTitle ?? "",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                    UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                         for: .selected)
            
            suggestionBtn.setAttributedTitle(NSMutableAttributedString(
                string: cellTitle ?? "",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                    UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                             for: .normal)
 
            suggestionBtn.isSelected = false 
        }
    }
    
    
    @IBOutlet weak var suggestionBtn: UIButton!
   
    @IBAction func suggestionBtnClick(_ sender: Any) {
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        suggestionBtn.isUserInteractionEnabled = false
        suggestionBtn.layer.borderWidth = 1
        suggestionBtn.layer.borderColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
    }

}
