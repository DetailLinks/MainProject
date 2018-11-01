
//
//  WFDownloadCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFDownloadCell: WFBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var btnClickComplict : ((UIButton,WFDownloadCell)->())?
    
    fileprivate let titleLabel   = UILabel.init()
    fileprivate let timeBtn      = UIButton.init()
    fileprivate let sizeBtn      = UIButton.init()
    fileprivate let selectImageV = UIImageView.init()
    fileprivate let selectBtn    = UIButton.init()
//    video_del_off
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFDownloadCell
        
        if let model  = model as? WFVideoListModel {
           cell?.configCell(model)
        }
        
        return cell!
    }
    
    func configCel(_ model : VideoDetailModel) {
        titleLabel.text   =  model.title
        timeBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.druationString)", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        sizeBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.totalSize / 1024 / 1024)M", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        selectBtn.isSelected = model.isSelected
    }
    
    func configCell(_ model : WFVideoListModel) {
        titleLabel.text   =  model.name
        timeBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.druationString)", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        sizeBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.size / 1024 / 1024)M", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        selectImageV.isHidden = !model.isSelectDownload
    }
    
    func setIsdeleteMode (_ isTrue : Bool) {
        selectBtn.snp.updateConstraints { (maker) in
            maker.width.equalTo(isTrue ? 60 : 0)
            maker.top.left.bottom.equalToSuperview()
        }
    }
}

//public Func
extension WFDownloadCell{
    func setDownload()->Bool {
        selectImageV.isHidden = !selectImageV.isHidden
        return !selectImageV.isHidden
    }
}


extension WFDownloadCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
        
        titleLabel.text   = "华山医院神经外科：动脉瘤脑鸡血"
        timeBtn.setAttributedTitle(NSAttributedString.init(string: " 10:23", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        sizeBtn.setAttributedTitle(NSAttributedString.init(string: " 23M", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        
        timeBtn.setImage(#imageLiteral(resourceName: "icon_time"), for: .normal)
        sizeBtn.setImage(#imageLiteral(resourceName: "icon_video2"), for: .normal)
        
        selectImageV.image = #imageLiteral(resourceName: "icon_checked")
        selectImageV.isHidden = true
        
        selectBtn.setImage(#imageLiteral(resourceName: "video_del_off"), for: .normal)
        selectBtn.setImage(#imageLiteral(resourceName: "icon_checked"), for: .selected)
        selectBtn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
    }
    
    @objc func btnclick(){
        if btnClickComplict != nil {
           btnClickComplict!(selectBtn,self)
        }
    }
    
    fileprivate func  addViews() {
        
        setLabelConfige(titleLabel, 15, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        
        contentView.addSubview(selectBtn)
        contentView.addSubview(titleLabel)
        contentView.addSubview(timeBtn)
        contentView.addSubview(sizeBtn)
        contentView.addSubview(selectImageV)
    }
    
    fileprivate func setConstraint() {
        
        selectBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(0)
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview()
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(-80)
            maker.top.equalToSuperview().offset(12)
            maker.left.equalTo(selectBtn.snp.right).offset(15)//equalToSuperview().offset(15)
        }
        timeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel)
            maker.top.equalTo(titleLabel.snp.bottom).offset(10)
            maker.bottom.equalToSuperview().offset(-10)
        }
        sizeBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(timeBtn.snp.right).offset(25)
            maker.top.bottom.equalTo(timeBtn)
        }
        selectImageV.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-15)
            maker.centerY.equalToSuperview()
        }
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)//UIFont(name: fontNameString, size: size)
        //UIFont.init(name: fontNameString , size: size)
    }
}
