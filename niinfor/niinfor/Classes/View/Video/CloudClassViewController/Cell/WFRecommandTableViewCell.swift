//
//  WFRecommandTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFRecommandTableViewCell: WFBaseTableViewCell {

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
    }
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFRecommandTableViewCell
        if let model  = model as? WFVideoViewModel {
           cell?.configModel(model.recommandClassArray[indexPath.row])
        }
        return cell!
    }
    
    
    func configModel(_ model : WFFreeClassModel) {
       
        titleView.text = model.name
        if let url  = URL.init(string: model.image) {
            headerImageView.sd_setImage(with: url, completed: nil)
        }
        
        let scoretext = model.score == "" ? "" : model.score + "分 "
        let pointtext = model.views == "" ? "" : model.views + "人 "
        let viewtext = model.score == "" ? ""  : ""//: model.score + " "
        subTitleView.text = scoretext + pointtext + viewtext
        
        tagView.clearView()
        tagView.configView(title:model.tags)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let headerImageView = UIImageView.init()
    fileprivate let titleView       = UILabel.init()
    fileprivate let subTitleView    = UILabel.init()
    fileprivate let tagView         = WFTagView.init()
}

extension WFRecommandTableViewCell{
    func setUI(){
        setConstraint()
        
        titleView.text           = "刀治疗血管内部分栓塞的脑动脉畸形"
        subTitleView.text        = "身外资讯  4.5分 1234人播放"
        headerImageView.image    = #imageLiteral(resourceName: "paper_img_neuro")
        //tagView.configView(title: ["院士论坛", "百家争鸣"])
    }
    
    fileprivate func setConstraint() {
        
        setLabelConfige(titleView, 16, #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
        setLabelConfige(subTitleView, 10, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        titleView.numberOfLines = 0
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(subTitleView)
        contentView.addSubview(tagView)
        
        headerImageView.snp.makeConstraints { (maker) in
            maker.right.bottom.equalToSuperview().offset(-15)
            maker.top.equalToSuperview().offset(15)
            maker.width.equalTo(102)///120)
            maker.height.equalTo(67.5)//90)
        }
        titleView.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(15)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.height.lessThanOrEqualTo(50)
        }
        subTitleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(titleView.snp.bottom).offset(10)
            
        }
        tagView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(subTitleView.snp.bottom).offset(10)
            maker.height.equalTo(18)
        }

    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }
}


