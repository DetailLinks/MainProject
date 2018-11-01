
//
//  WFCaseDiscussCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDWebImage


class WFCaseDiscussCell: UITableViewCell {

    var model : WFDiscussModel?{
        didSet{
            
//         model?.publishTime 
           
            imageWidth.constant = Screen_width - 20
            
            let currentTimeInterval : TimeInterval  = Date().timeIntervalSince1970
            
            /*var  time = (currentTimeInterval - (model?.publishTime ?? 0))  / 1000
            
            if time > 0 &&  time < 3600 {
                
                timeLabel.text = "\(time/60)分钟之前"
            }
            
            time = time/3600
            
            if time > 1 && time < 24 {
                timeLabel.text = String(format: "%.0f小时之前", time)
            }
            
            time = time/24
        
            if time > 1 && time < 30 {
                timeLabel.text = String(format: "%.0f天之前", time)
            }

            time = time/30
            
            if time > 1 && time < 12 {
                timeLabel.text = String(format: "%.0f月之前", time)
            }

            time = time/12
            
            if time > 1  {
                timeLabel.text = String(format: "%.0f年之前", time)
            }*/

            timeLabel.text = model?.publishTime
            
            if timeLabel.text ?? "" == "0" {
                timeLabel.text = ""
            }
            
            
           nameLabel.text = model?.publisher?.realName ?? ""
           titleLabel.text = model?.title ?? ""
           
            discussBtn.setAttributedTitle(NSMutableAttributedString(string: " \(String(describing: model?.comments ?? 0)) ",
                              attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                                                UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                              for: .normal)
            prisebtn.setAttributedTitle(NSMutableAttributedString(string: " \(String(describing: model?.diggs ?? 0)) ",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .normal)
            lookBtn.setAttributedTitle(NSMutableAttributedString(string: " \(String(describing: model?.views ?? 0)) ",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .normal)
            
            discussBtn.setAttributedTitle(NSMutableAttributedString(string: " \((model?.comments ?? 0) + 1) ",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .selected)
            prisebtn.setAttributedTitle(NSMutableAttributedString(string: " \((model?.diggs ?? 0) + 1 ) ",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .selected)
            lookBtn.setAttributedTitle(NSMutableAttributedString(string: " \((model?.views ?? 0) + 1 ) ",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12), NSForegroundColorAttributeName : #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)]),
                                          for: .selected)
            
            
            
            if let url  = URL(string: model?.publisher?.avatarAddress ?? "" )   {
                     avatarImageView.sd_setImage(with: url, placeholderImage: nil)
                avatarImageView.sd_setImage(with: url, placeholderImage: NetworkerManager.shared.userCount.gender == "F" ? #imageLiteral(resourceName: "profile_img_portrait_woman") : #imageLiteral(resourceName: "profile_img_portrait_man"))
            }
           
            if (model?.imgs.count ?? 0) > 0  {
                if let url  = URL(string: self.model?.imgs[0].thumbnailString ?? "")   {
                    firstImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "discuss_img_neuro"))
                }
            }
            
            if (model?.imgs.count ?? 0) > 1  {
                imageWidth.constant = (Screen_width - 30) / 2
                if let url  = URL(string: self.model?.imgs[1].thumbnailString ?? "")   {
                    secondImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "discuss_img_neuro"))
                }
            }
            if (model?.imgs.count ?? 0) > 2  {
                imageWidth.constant = (Screen_width - 40) / 3
                if let url  = URL(string: self.model?.imgs[2].thumbnailString ?? "")   {
                    thirdImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "discuss_img_neuro"))
                }
            }

        }
    }
    
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var discussBtn: UIButton!
    @IBAction func discusBtn(_ sender: Any) {
        //discussBtn.isSelected = !discussBtn.isSelected
    }
    
    @IBOutlet weak var prisebtn: UIButton!
    @IBAction func priseBtnClick(_ sender: Any) {
       prisebtn.isSelected = !prisebtn.isSelected
    }
    
    @IBOutlet weak var lookBtn: UIButton!
    @IBAction func lookbtnClick(_ sender: Any) {
       // lookBtn.isSelected = !lookBtn.isSelected
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var firstImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
