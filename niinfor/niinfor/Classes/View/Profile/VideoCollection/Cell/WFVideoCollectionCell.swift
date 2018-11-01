//
//  WFVideoCollectionCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFVideoCollectionCell: UICollectionViewCell {

    
    var  model : WFCollectionModel?{
        didSet{
            timeLabel.text = model?.publishDate ?? ""
            mainTitle.text = model?.title ?? ""
            hospitalName.text = model?.authors?[0].authorName ?? ""
            
            guard let url  = URL(string: model?.infoImgString ?? "") else {
                return
            }
            
            mainImage.sd_setImage(with: url)
            
        }
    }
    @IBOutlet weak var mainImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var hospitalName: UILabel!
    
}
