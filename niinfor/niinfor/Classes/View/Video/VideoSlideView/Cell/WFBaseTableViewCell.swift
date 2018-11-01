//
//  WFBaseTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/19.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFBaseTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        lineImageView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        contentView.addSubview(lineImageView)
        lineImageView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.left.equalToSuperview().offset(13)
            maker.right.equalToSuperview().offset(-15)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let lineImageView = UIImageView.init()
    
    class func dequneceTableView(_ tableView : UITableView , _ cellString : String , _ indexPath : IndexPath , _ model : AnyObject) -> UITableViewCell{
        return UITableViewCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
 
    }

}
