//
//  WFPlayingViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDWebImage

class WFPlayingViewCell: UITableViewCell {

    var model : WFPlayModel?{
        didSet{
           
            titleLabel.text = model?.meetingName ?? ""
            timeLabel.text = model?.meetingDate ?? ""
            
            if let url  = URL(string: model?.titlePicString ?? "" )   {
                imageLabel.sd_setImage(with: url, placeholderImage: nil)
            }

            
            buttomViewHeightCons.constant = 9
            if (model?.meetingFields.count ?? 0) > 0  {
                
              firstLabel.attributedText = setAttribute("会场1：" +  (model?.meetingFields[0].subject ?? ""))
              buttomViewHeightCons.constant =  34
            }
            
            if (model?.meetingFields.count ?? 0) > 1  {
                
                secLabel.attributedText = setAttribute("会场2："  + (model?.meetingFields[1].subject ?? ""))
              buttomViewHeightCons.constant =  59
            }

            if (model?.meetingFields.count ?? 0) > 2  {
                
                thirdLabel.attributedText = setAttribute("会场3：" + (model?.meetingFields[2].subject ?? ""))
                buttomViewHeightCons.constant =  76
            }
            
            if (model?.meetingFields.count ?? 0) > 3 {
                
                let listCount  = (model?.meetingFields.count ?? 0) - 3
                
                buttomViewHeightCons.constant =  CGFloat(76 + listCount * 25)
                
                for item  in 3..<(model?.meetingFields.count ?? 0) {
                    
                    switch item {
                    case 4 :fourLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                    case 5 :fiveLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                    case 6 :sixLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                            case 7 :svenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                            case 8 :eightLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 9 :nineLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 10 :tenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 11 :elevenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 12 :twoveLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 13 :thirteenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 14 :fourteenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                                            case 15 :fifteenLabel.attributedText = setAttribute("会场\(item)：" + (model?.meetingFields[2].subject ?? ""))
                    default: break
                    }
                }
            }
            
            if (model?.meetingFields.count ?? 0) > 3  {
                
                fourLabel.attributedText = setAttribute("会场4：" + (model?.meetingFields[3].subject ?? ""))
                buttomViewHeightCons.constant =  76 + 25
            }

            
            
            self.layoutIfNeeded()
        }
    }
    
   private func setAttribute(_ title : String) -> NSAttributedString {
        
        return NSMutableAttributedString(string: title , attributes: [NSUnderlineStyleAttributeName  : 1 , NSUnderlineColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ?? UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)  ])
    }
    
    
    
    @IBAction func firstBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[0].fieldUrl ?? "" )
        
       }
    
    @IBAction func secondBtnClick(_ sender: Any) {
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[1].fieldUrl ?? "" )
    }
    
    @IBAction func thirdBtnClick(_ sender: Any) {
        
         NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[2].fieldUrl ?? "" )
    
    }
    
        @IBAction func fourBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[3].fieldUrl ?? "" )
        
    }
    @IBAction func fifBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[4].fieldUrl ?? "" )
        
    }
    @IBAction func sixBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[5].fieldUrl ?? "" )
        
    }
    @IBAction func svenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[6].fieldUrl ?? "" )
        
    }
    @IBAction func eightBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[7].fieldUrl ?? "" )
        
    }
    @IBAction func ninBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[8].fieldUrl ?? "" )
        
    }
    @IBAction func tenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[9].fieldUrl ?? "" )
        
    }
    @IBAction func elevenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[10].fieldUrl ?? "" )
        
    }
    @IBAction func twivBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[11].fieldUrl ?? "" )
        
    }
    @IBAction func thirteenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[12].fieldUrl ?? "" )
        
    }
    
    @IBAction func fourteenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[13].fieldUrl ?? "" )
        
    }
    
    @IBAction func fifteenBtnClick(_ sender: Any) {
        
        NotificationCenter.default.post(name:NSNotification.Name(rawValue: notifi_little_meeting_number), object: model?.meetingFields[14].fieldUrl ?? "" )
        
    }

    
    @IBOutlet weak var buttomViewHeightCons: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secLabel: UILabel!
    
    @IBOutlet weak var thirdLabel: UILabel!
    
    @IBOutlet weak var fourLabel: UILabel!
    @IBOutlet weak var fiveLabel: UILabel!
    @IBOutlet weak var sixLabel: UILabel!
    @IBOutlet weak var svenLabel: UILabel!
    @IBOutlet weak var eightLabel: UILabel!
    @IBOutlet weak var nineLabel: UILabel!
    @IBOutlet weak var tenLabel: UILabel!
    @IBOutlet weak var elevenLabel: UILabel!
    @IBOutlet weak var twoveLabel: UILabel!
    @IBOutlet weak var thirteenLabel: UILabel!
    @IBOutlet weak var fourteenLabel: UILabel!
    @IBOutlet weak var fifteenLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
