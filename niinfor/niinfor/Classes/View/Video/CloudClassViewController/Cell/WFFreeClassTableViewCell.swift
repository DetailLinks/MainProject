//
//  WFFreeClassTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFFreeClassTableViewCell: WFBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
        lineImageView.isHidden = true
    }
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFFreeClassTableViewCell
        cell?.configModel((model as! WFVideoViewModel).freeClassArray[indexPath.row])
        return cell!
    }

    func configModel(_ model : WFFreeClassModel) {
        
        titleView.text = model.name
        
//        guard let url  = URL.init(string: model.image) else { return  }
//        headerImageView.sd_setImage(with: url, completed: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let headerImageView = UIImageView.init()
    fileprivate let titleView       = UILabel.init()
}

extension WFFreeClassTableViewCell{
    func setUI(){
        
        headerImageView.image = #imageLiteral(resourceName: "icon_video")
        titleView.font        = UIFont.systemFont(ofSize: 16)
        titleView.textColor   = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleView)
        
        headerImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.centerY.equalToSuperview()
        }
        titleView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(44)
            maker.left.equalToSuperview().offset(35)
        }
        
    }
}

