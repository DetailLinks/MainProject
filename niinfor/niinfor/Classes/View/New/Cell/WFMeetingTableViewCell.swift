//
//  WFMeetingTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/24.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMeetingTableViewCell: UITableViewCell {

    var model : WFMeetingModel?{
        didSet{
            
            titleLabel.text = model?.meetingName ?? ""
            meetingTimeLabel.text = "会议时间：" + (model?.meetingDate ?? "")
            
            guard  let url  = URL(string: model?.titlePicString ?? "") else{
                return
            }
            
            headerImageView.sd_setImage(with: url)
            
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
    
    ///title
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var baomingBtn: UIButton!
    @IBAction func baomingBtnCLick(_ sender: Any) {
    }
    
    @IBOutlet weak var meetingTimeLabel: UILabel!
    
    ///头像
    @IBOutlet weak var headerImageView: UIImageView!
}
