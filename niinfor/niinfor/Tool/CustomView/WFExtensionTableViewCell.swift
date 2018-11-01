//
//  WFExtensionTableViewCell.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/22.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFExtensionTableViewCell: UITableViewCell {

    
    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        label.textColor = UIColor.green
    }
    
}
