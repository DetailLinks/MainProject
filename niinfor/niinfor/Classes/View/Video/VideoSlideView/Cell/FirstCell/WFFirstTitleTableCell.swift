//
//  WFFirstTitleTableCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/19.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFFirstTitleTableCell: WFBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel   = UILabel.init()
    fileprivate let authorLabel  = UILabel.init()
    fileprivate let purchesLabel = UILabel.init()
    fileprivate let tagView      = WFTagView.init()
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFFirstTitleTableCell
        if let model  = model as? WFDetailVideoModel {
            var  author = ""
            for item in model.authors{
                author = author + " " + item.authorName
            }
            cell?.configCell(model.name,"讲者：\(author)","观看人数：\(model.course.views)人",model.course.tags)
        }
        return cell!
    }
    
    
    func configCell(_ title : String , _ author : String , _ buyers : String , _ tags : [TagModel]) {
        titleLabel.text   = title
//        authorLabel.text  = author
        purchesLabel.text = buyers
        
        tagView.clearView()
        tagView.configView(title: tags)
        
    }
}

extension WFFirstTitleTableCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
        
        //tagView.configView(title: ["院士论坛", "百家争鸣"])
        titleLabel.text   = "华山医院神经外科：动脉瘤脑鸡血"
        authorLabel.text  = ""//"讲者：神经介入资讯 身外资讯"
        purchesLabel.text = "购买：1122331人"

    }
    fileprivate func  addViews() {
        
        setLabelConfige(titleLabel, 16, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        setLabelConfige(authorLabel, 13, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        setLabelConfige(purchesLabel, 13, #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1))
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(purchesLabel)
        contentView.addSubview(tagView)
    }
    fileprivate func setConstraint() {
        titleLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.top.equalToSuperview().offset(5)
            maker.left.equalToSuperview().offset(13)
        }
        authorLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        purchesLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview()
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
        tagView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalToSuperview().offset(-15)
            maker.top.equalTo(purchesLabel.snp.bottom).offset(10)
            maker.height.equalTo(18)
            maker.bottom.equalToSuperview().offset(-10)
        }
    }

    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
         label.textColor = color
         label.font = UIFont.systemFont(ofSize: size)//UIFont(name: fontNameString, size: size)
         //UIFont.init(name: fontNameString , size: size)
    }
}
