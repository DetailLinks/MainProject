//
//  WFFirstContntLabelCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/19.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFFirstContntLabelCell: WFBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFFirstContntLabelCell
        
        cell?.titleLabel.text = model as? String
        return cell!
    }
    
    fileprivate let titleLabel   = UILabel.init()
}
extension WFFirstContntLabelCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        titleLabel.text  = "华山医院神经外科：动脉瘤脑鸡血华山医院神经外科：动脉瘤脑鸡血华山医院神经外科：动脉瘤脑鸡血华山医院神经外科：动脉瘤脑鸡血华山医院神经外科：动脉瘤脑鸡血华山医院神经外科：动脉瘤脑鸡血"
        titleLabel.numberOfLines = 0
        setLabelConfige(titleLabel, 13, #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
        
        contentView.addSubview(titleLabel)
    }
    fileprivate func setConstraint() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(-26)
            maker.top.equalToSuperview().offset(15)
            maker.left.equalToSuperview().offset(13)
            maker.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }
}

