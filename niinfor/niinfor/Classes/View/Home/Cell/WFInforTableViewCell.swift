//
//  WFInforTableViewCell.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/9.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFInforTableViewCell: UITableViewCell {

    var model : WFCollectionModel?{
        
        didSet{
            
            titleLabel.text = model?.title ?? (model?.infoTitle ?? "")
            timeLabel.text = model?.publishDate ?? ""
            
            guard let url  = URL(string: model?.infoImgString ?? "")  else { return  }
            
            headerImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "paper_img_neuro"))
        }
    }
    

    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var headerImageView: UIImageView!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
