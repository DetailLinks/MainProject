//
//  WFFirstAuthorMessageCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFFirstAuthorMessageCell: WFBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let headImageView   = UIImageView.init()
    fileprivate let titleLabel      = UILabel.init()
    fileprivate let authorLabel     = UILabel.init()
    fileprivate let titleBtn        = UIButton.init()
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFFirstAuthorMessageCell
        if let model = model as? WFDetailVideoModel {
            if !model.authors.isEmpty{
               cell?.configModel(model.authors[indexPath.row - 2])
            }
        }
        return cell!
    }
    
    func configModel(_ model : WFAuthorsModel) {
        
        titleLabel.text = model.authorName
        authorLabel.text = model.mdescription
        
        titleBtn.setTitle("  " + model.company + "  ", for: .normal)
        titleBtn.sizeToFit()
        
        titleBtn.isHidden = model.company == ""
        
        if let url  = URL.init(string: model.headImage ){

            headImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar"), options: [], completed: nil)
        }else{
            headImageView.image = #imageLiteral(resourceName: "avatar")
        }
    }
}

extension WFFirstAuthorMessageCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        titleLabel.text   = "华山医院"
        authorLabel.text  = "讲者：神经介入资讯 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls 身外资讯sfsfasfjalsfjaljflajflsjlfjsalfjls"
        authorLabel.numberOfLines = 0
        
        setLabelConfige(titleLabel, 16, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        setLabelConfige(authorLabel, 13, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        headImageView.image = #imageLiteral(resourceName: "avatar")
        headImageView.layer.cornerRadius = 22
        headImageView.layer.masksToBounds = true
        headImageView.contentMode = .scaleAspectFill
        
        titleBtn.backgroundColor = UIColor.orange
        titleBtn.layer.cornerRadius = 10
        titleBtn.setTitle("主任医师", for: .normal)
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(authorLabel)
        contentView.addSubview(headImageView)
        contentView.addSubview(titleBtn)
    }
    
    fileprivate func setConstraint() {
        headImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(44)
            maker.top.equalToSuperview().offset(10)
            maker.left.equalToSuperview().offset(13)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(headImageView)
            maker.left.equalTo(headImageView.snp.right).offset(15)
        }
        titleBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(headImageView)
            maker.left.equalTo(titleLabel.snp.right).offset(15)
            maker.height.equalTo(20)
        }
        authorLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(-26)
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(headImageView.snp.bottom).offset(15)
            maker.bottom.equalToSuperview().offset(-15)
        }
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)//UIFont(name: fontNameString, size: size)
        //UIFont.init(name: fontNameString , size: size)
    }
}
