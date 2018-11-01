//
//  WFMessageCell.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/11.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFMessageCell: UITableViewCell {

    
    var model : WFMessageModel?{
        didSet{
            
            mainTitle.text = model?.title ?? ""
            contentLabel.text = model?.content ?? ""
            
            let timeFormate  = DateFormatter()
            timeFormate.dateStyle = .medium
            timeFormate.timeStyle = .short
            timeFormate.dateFormat = "yyyy-MM-dd-HH:MM:ss"
            
            let pastDate  = Date(timeIntervalSince1970: Double(model?.timeString ?? "") ?? 0 )
            //let pastString  = timeFormate.string(from: pastDate)
            
            let currentTimeInterval : TimeInterval  = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
            
            let currentDate  = Date(timeIntervalSince1970: currentTimeInterval)
           // let currentString  = timeFormate.string(from: currentDate)

            let secondS  = currentDate.timeIntervalSince(pastDate)
            
            print(pastDate,currentDate)
            print("时间----")
            print(model?.timeString ?? 0,currentTimeInterval)
            print(secondS)
            
            var  time = secondS
            
            print(time)
            time = time / 60
            
            if time > 0 &&  time < 60 {
                
                if time < 2 {
                 
                    timeLabel.text = String(format: "刚刚", time)
                }else {
                
                timeLabel.text = String(format: "%.0f分钟前", time)
                }
            }
            
            time = time/60
            
            if time > 1 && time < 24 {
                timeLabel.text = String(format: "%.0f小时前", time)
            }
            
            time = time/24
            
            if time > 1 && time < 30 {
                timeLabel.text = String(format: "%.0f天前", time)
            }
            
            time = time/30
            
            if time > 1 && time < 12 {
                timeLabel.text = String(format: "%.0f月前", time)
            }
            
            time = time/12
            
            if time > 1  {
                timeLabel.text = String(format: "%.0f年前", time)
            }
        }
    }
    
    
    @IBOutlet weak var mainTitle: UILabel!
    
    @IBOutlet weak var contentLabel: UILabel!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func deleteClick(_ sender: Any) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_mymessage_deleteBtn_click), object: self, userInfo: nil)

    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
