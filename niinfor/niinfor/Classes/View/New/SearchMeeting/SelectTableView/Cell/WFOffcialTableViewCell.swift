//
//  WFOffcialTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFOffcialTableViewCell: UITableViewCell {

    @IBOutlet weak var titleBtnLeftCons: NSLayoutConstraint!
    @IBOutlet weak var titlebtn: UIButton!
    
    var model : WFEducationModel?{
        didSet{
            titlebtn.setAttributedTitle(NSMutableAttributedString(string: "\(model?.name ?? "" )",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 16) ??
                    UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                         for: .normal)

        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       // titlebtn.isEnabled = false
        titleBtnLeftCons.constant = btnSpace
        
        
    }

    @IBAction func btnClick(_ sender: Any) {
       // setSelected(true, animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
           
    }
    
}
