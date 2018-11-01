//
//  WFSplitTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SDCycleScrollView

class WFSplitTableViewCell: WFBaseTableViewCell {

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
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFSplitTableViewCell
        
        if let model = model as?  WFVideoViewModel  {
           cell?.configModel(model)
        }
        return cell!
    }

    func configModel(_ model : WFVideoViewModel) {
        
        cycleScrollView.delegate = model
        
        var titleArray = [String]()
        var imageArray = [String]()
        
        for  item in model.adArray {
            
            titleArray.append(item.name ?? "")
            imageArray.append(item.imageString )
            
        }
        //            self.cycleScrollView.titlesGroup = titleArray
        self.cycleScrollView.imageURLStringsGroup = imageArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate let cycleScrollView = SDCycleScrollView.init()
}

extension WFSplitTableViewCell{
    func setUI(){
        contentView.addSubview(cycleScrollView)
        cycleScrollView.layer.cornerRadius = 3
        cycleScrollView.layer.masksToBounds = true
        configCycirView()
        cycleScrollView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.top.equalToSuperview().offset(6)
            maker.right.equalToSuperview().offset(-15)
            maker.height.equalTo((Screen_width - 30) / 690.0 * 230.0)
            maker.bottom.equalToSuperview()
        }
    }
    
    func configCycirView() {
        
        cycleScrollView.titleLabelBackgroundColor = UIColor.clear
        cycleScrollView.autoScrollTimeInterval = 5
        cycleScrollView.showPageControl = true
        cycleScrollView.placeholderImage = #imageLiteral(resourceName: "首页banner")//24911529466020_.pic_hd// #imageLiteral(resourceName: "casediscuss_img_neuro")//casediscuss_img_neuro
        cycleScrollView.itemDidScrollOperationBlock = {(offset) in
        }
    }
}
