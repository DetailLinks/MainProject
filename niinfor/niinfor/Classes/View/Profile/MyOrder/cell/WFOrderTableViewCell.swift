//
//  WFOrderTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var unpaidLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var localLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var deleteLabel: UIButton!{
        didSet{
            deleteLabel.layer.borderWidth = 1
            deleteLabel.layer.borderColor = UIColor(red: 153.0/255.0,
                                                                               green: 153.0/255.0,
                                                                               blue: 153.0/255.0,
                                                                               alpha: 1).cgColor
        }
    }

    @IBOutlet weak var paylabel: UIButton!
}
