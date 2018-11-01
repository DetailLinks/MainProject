//
//  WFHospitalTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/29.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFHospitalTableViewCell: UITableViewCell {

    @IBOutlet weak var headerCons: NSLayoutConstraint!
    @IBOutlet weak var headimageView: UIImageView!
    @IBOutlet weak var hospitalBtn: UIButton!
    
    @IBAction func HospitalClick(_ sender: Any) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        headerCons.constant = btnSpace
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
