//
//  WFSecondTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFSecondTableViewCell: WFBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let titleLabel    = UILabel.init()
    fileprivate let timeLabel     = UILabel.init()
    fileprivate let durationLabel = UILabel.init()
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFSecondTableViewCell
        
        if let model  = model as? WFVideoClassModel {
            cell?.configCell(model.videoList[indexPath.row])
        }
        
        return cell!
    }
    
    func configCell(_ model : WFVideoListModel) {
        
        titleLabel.text    = model.name
        titleLabel.textColor = model.isDefaultModel ? #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1) : #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1)
        
        let timeString = model.addTime == "" ? "" : (model.addTime as NSString).substring(to: 10)
        
        timeLabel.text     = model.authorsName//timeString
        
        let second  = model.duration % 60
        let minit   = (model.duration / 60) //% 60
//        let hour    = (model.duration / 60) / 60
        
//        if hour  == 0 {
        
            if minit == 0{
                durationLabel.text = " 00:\(String.init(format: "%02d", second))分钟"
            }else{
                durationLabel.text = "\(String.init(format: "%02d", minit)):\(String.init(format: "%02d", second))分钟"
            }
            
//        }else{
//            durationLabel.text = "\(String.init(format: "%02d", hour)):\(String.init(format: "%02d", minit)):\(String.init(format: "%02d", second))分钟"
//        }
        
        
    }
}

extension WFSecondTableViewCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        titleLabel.text    = "1 神经内径的操作视频"
        timeLabel.text     = "2018-9-07 神经内径的操作视神经内径的操作视神经内径的操作视神经内径的操作视"
        durationLabel.text = "19:22分钟"
        durationLabel.textAlignment = .right
        
        setLabelConfige(titleLabel, 15, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        setLabelConfige(timeLabel, 12, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        setLabelConfige(durationLabel, 12, #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(durationLabel)
        contentView.addSubview(timeLabel)
    }
    fileprivate func setConstraint() {
        
        durationLabel.snp.makeConstraints { (maker) in
            maker.height.top.bottom.equalToSuperview()
            maker.width.equalTo(transWidth(120))
            maker.right.equalToSuperview().offset(-12)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(12)
            maker.left.equalToSuperview().offset(13)
            maker.right.equalTo(durationLabel.snp.left)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(durationLabel.snp.left).offset(-10)
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)//UIFont(name: fontNameString, size: size)
        //UIFont.init(name: fontNameString , size: size)
    }
}
