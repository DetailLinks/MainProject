//
//  WFClickBtnTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFClickBtnTableViewCell : WFBaseTableViewCell  {

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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)
        return cell
    }
    
    fileprivate let backpackbtn     = WFTitleButton.init()
    fileprivate let schdulebtn      = WFTitleButton.init()
    fileprivate let rankingListkbtn = WFTitleButton.init()
}

extension WFClickBtnTableViewCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        setBtnConfige(backpackbtn, "书包", #imageLiteral(resourceName: "btn_bag"))
        setBtnConfige(schdulebtn, "学习计划", #imageLiteral(resourceName: "btn_plan"))
        setBtnConfige(rankingListkbtn, "排行榜", #imageLiteral(resourceName: "btn_ranking"))
        
        contentView.addSubview(backpackbtn)
        contentView.addSubview(schdulebtn)
        contentView.addSubview(rankingListkbtn)
    }
    fileprivate func setConstraint() {
        backpackbtn.snp.makeConstraints { (maker) in
            maker.width.equalTo((Screen_width - 30) / 3.0)
            maker.top.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
            maker.height.equalTo(83)
        }
        schdulebtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(backpackbtn)
            maker.left.equalTo(backpackbtn.snp.right)
            maker.top.equalToSuperview()
            maker.height.equalTo(83)
        }
        rankingListkbtn.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.width.equalTo(schdulebtn)
            maker.left.equalTo(schdulebtn.snp.right)
            maker.top.equalToSuperview()
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo(83)
        }
        
    }
    
    func setBtnConfige(_ btn : UIButton , _ title  : String , _ image   : UIImage) {
        btn.setAttributedTitle(NSAttributedString.init(string: title, attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        btn.setImage(image, for: .normal)
        
    }
}
