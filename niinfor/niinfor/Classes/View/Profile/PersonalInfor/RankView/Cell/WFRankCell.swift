//
//  WFRankCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFRankCell: UITableViewCell {

    
    var complictSelected : ((WFRankCell)->())?
    
    
    var isSelectedCell : Bool = false
    
    var model : WFEducationModel?{
        didSet{
            rankTitle.text = model?.name ?? ""
            
            rankBtn.isSelected = isSelectedCell
        }
    }
    
    @IBOutlet weak var rankTitle: UILabel!
    
    @IBOutlet weak var rankBtn: UIButton!
    
    @IBAction func rankBtnClick(_ sender: Any) {
        
        complictSelected?(self)
        
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        rankBtnClick(self)
    }
    
}
