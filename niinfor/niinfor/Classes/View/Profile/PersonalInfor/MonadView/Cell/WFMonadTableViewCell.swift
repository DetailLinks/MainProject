//
//  WFMonadTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMonadTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hospitalLabel: UILabel!

    var model : WFEducationModel?{
        didSet{
            hospitalLabel.text =  model?.name ?? ""
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
