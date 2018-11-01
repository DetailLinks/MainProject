//
//  WFImageCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/7.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFImageCollectionViewCell: UICollectionViewCell {

    
    var deletImageData : ((_ cell : UICollectionViewCell )->())?
		
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   ///删除按钮点击
    @IBAction func deleteBtnClick(_ sender: Any) {
        deletImageData?(self)
    }
    
    @IBOutlet weak var mainImageView: UIImageView!
    
}
