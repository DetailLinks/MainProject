//
//  WFSettingTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/29.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFSettingTableViewCell: UITableViewCell {

    var dict :[String : String]? {
        didSet{
            headInage.image = UIImage(named: "profile_icon_" + (dict!["image"] ?? ""))
            titleLabel.text = dict!["title"]
            
            buttomImage.isHidden = titleLabel.text == "系统设置"
            
        }
    }
    
    
    @IBOutlet weak var buttomImage: UIImageView!
    @IBOutlet weak var headInage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
