//
//  WFTableViewCollectionViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFTableViewCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    var model : WFFreeClassModel = WFFreeClassModel(){
        didSet{
           mainTitleLabel.text = model.name
           guard let url  = URL.init(string: model.image) else { return }
           headerImageView.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "paper_img_neuro"), options: [], completed: nil)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var headerImageView = UIImageView.init()
    fileprivate var mainTitleLabel  = UILabel.init()
}

extension WFTableViewCollectionViewCell{
    fileprivate func setUI()  {
        addSubView()
        setConstriant()
    }
    fileprivate func addSubView(){
        headerImageView.backgroundColor = UIColor.cz_random()
        mainTitleLabel.text = "这就是一个医院啊就分手了就服"
        mainTitleLabel.font = UIFont.systemFont(ofSize: 13)
        mainTitleLabel.numberOfLines = 0
        contentView.addSubview(headerImageView)
        contentView.addSubview(mainTitleLabel)
    }
    fileprivate func setConstriant()  {
        headerImageView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(75)
            maker.top.equalToSuperview().offset(5)
        }
        mainTitleLabel.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(headerImageView.snp.bottom)
        }
    }

}
