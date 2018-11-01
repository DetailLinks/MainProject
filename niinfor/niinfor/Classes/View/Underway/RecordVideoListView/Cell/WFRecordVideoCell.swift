//
//  WFRecordVideoCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDWebImage

class WFRecordVideoCell: UITableViewCell {

    var model : WFMeetingModel?{
        didSet{
            titleLabel.text = model?.meetingName ?? ""
            timeLabel.text = model?.meetingDate ?? ""
            
            contentImageView.sd_setImage(with: URL(string:model?.titlePicString ?? ""), placeholderImage: #imageLiteral(resourceName: "video_img_thumbnail"))
            
        }
    }
    
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var contentImageView: UIImageView!
    
    @IBOutlet weak var firstRankLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        firstRankLabel.text = ""
        secondLabel.text = ""
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
