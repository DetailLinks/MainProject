//
//  WFPublishCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/8.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFPublishCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var model : WFMPArticle? {
        didSet{
//            guard let model = model else {
//                return
//            }
            titleLabel.text = model?.title ?? "" == "" ? "请添加一个标题" :  model?.title ?? ""
            //timeLabel.text = model?.creationTime ?? ""  == "" ? "" : ((model?.creationTime ?? "") as NSString).substring(to: 10)
            
            deletBtn.isHidden = !(model?.isDraft)!
            deleteImage.isHidden = !(model?.isDraft)!
            lookBtn.isHidden = (model?.isDraft)!
            commentBtn.isHidden = (model?.isDraft)!
            priseBtn.isHidden = (model?.isDraft)!
            timeLabel.isHidden = (model?.isDraft)!
            if let cover = model?.cover ,
               let url = URL.init(string:  cover){
                
                headImageView.sd_setImage(with: url) { (_, _, _,_ ) in
                    self.headImageView.snp.updateConstraints({ (maker) in
                        maker.height.equalTo(cover == "" ? 0 : 150)
                    })
                }
            }else{
                
                if model?.isDraft == true && model?.imageData != nil{
                    
                    self.headImageView.image = UIImage.init(data: (model?.imageData!)!)
                    
                    self.headImageView.snp.updateConstraints({ (maker) in
                        maker.height.equalTo(150)
                    })

                }else{
                    self.headImageView.snp.updateConstraints({ (maker) in
                        maker.height.equalTo(0)
                    })
                }
            }
            
            if  let stutas = model?.permission{
            
            privateBtn.snp.updateConstraints { (maker) in
                maker.width.equalTo(stutas == "PU" ? 0 : 100)
            }
            }
            
            lookBtn.setAttributedTitle(NSMutableAttributedString(
                string: " \(String(describing: model?.showViews ?? "0"))",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                     for: .normal)
            commentBtn.setAttributedTitle(NSMutableAttributedString(
                string: " \(String(describing: model?.comments ?? "0"))",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                     for: .normal)
            priseBtn.setAttributedTitle(NSMutableAttributedString(
                string: " \(String(describing: model?.showDiggs ?? "0"))",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                    UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                     for: .normal)
            
            let timeFormate  = DateFormatter()
            timeFormate.dateStyle = .medium
            timeFormate.timeStyle = .short
            timeFormate.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            guard let model = model ,
                let creationTime = model.creationTime ,
                let pastDate  = timeFormate.date(from:creationTime ) else {
                return
            }
            let currentDate  = Date()
            
            let clender = Calendar.current
            
            let comps = clender.dateComponents([.day,.hour,.minute,.second], from: pastDate, to: currentDate)
            
            if comps.day ?? 0 > 0 {
                timeLabel.text = model.creationTime ?? ""  == "" ? "" : ((model.creationTime ?? "") as NSString).substring(to: 10)

            }else if comps.hour ?? 0 < 24 && comps.hour ?? 0 >= 1 {
                timeLabel.text = "\(comps.hour ?? 0)小时前"
                
            }else if comps.minute ?? 0 > 10 &&  comps.minute ?? 0 < 59{
                timeLabel.text = "\(comps.minute ?? 0)分钟前"
                
            }else if comps.minute ?? 0 >= 0 &&  comps.minute ?? 0 < 10 && comps.hour ?? 0 == 0 {
                  timeLabel.text = "刚刚"
            }
            
       
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* var id : String?
     var templateId : String?
     var type : String?
     var title : String?
     var cover : String?
     var content : String?
     var permission : String?
     var password : String?
     var allowComment : String?
     var views : String?
     var comments : String?
     var diggs : String?
     var status : String?
     var creationTime : String?
     var articleUrl : String?
     var dicts : String?*/
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    fileprivate var bacView  : UIView = {
        let label = UIView.init()
        label.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        return label
    }()

    fileprivate var bacWiterView  : UIView = {
        let label = UIView.init()
        
        return label
    }()
    
   fileprivate var titleLabel : UILabel = {
        let label = UILabel.init()
        label.textAlignment = .left
        label.textColor = #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 18)
        return label
    }()
    
    
   fileprivate var headImageView : UIImageView = {
        let label = UIImageView.init()
        label.contentMode = .scaleAspectFill
        label.clipsToBounds = true
        return label
    }()

    
   fileprivate var timeLabel : UILabel = {
        let label = UILabel.init()
        label.textColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()

    
   fileprivate var privateBtn : UIButton = {
        let label = UIButton.init()
        label.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        label.setAttributedTitle(NSMutableAttributedString(
        string: " 仅自己可见",
        attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
            UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                           for: .normal)
        label.setImage(#imageLiteral(resourceName: "Clip 2"), for: .normal)
        return label
    }()
    
    var deletBtn : UIButton = {
        let label = UIButton.init()
        //label.addTarget(self, action: #selector(deleteBtnClick(_:)), for: .touchUpInside)
        return label
    }()
    
    fileprivate var deleteImage  : UIImageView = {
        let label = UIImageView.init()
        label.clipsToBounds = true
        label.contentMode = .scaleAspectFill
        label.image = #imageLiteral(resourceName: "snallDelete")
        return label
    }()

    
    fileprivate var priseBtn : UIButton = {
        let label = UIButton.init()
        label.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        label.setAttributedTitle(NSMutableAttributedString(
            string: " 0",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                 for: .normal)
        label.setImage(#imageLiteral(resourceName: "prise"), for: .normal)
        return label
    }()
    
    fileprivate var lookBtn : UIButton = {
        let label = UIButton.init()
        label.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        label.setAttributedTitle(NSMutableAttributedString(
            string: " 0",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                 for: .normal)
        label.setImage(#imageLiteral(resourceName: "Group 3-1"), for: .normal)
        return label
    }()
    
    fileprivate var commentBtn : UIButton = {
        let label = UIButton.init()
        label.tintColor = #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        label.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        label.setAttributedTitle(NSMutableAttributedString(
            string: " 0",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 12) ??
                UIFont.systemFont(ofSize: 12),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                 for: .normal)
        label.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        return label
    }()
    

    @objc func deleteBtnClick(_ cell : UIButton) {
          NotificationCenter.default.post(name: NSNotification.Name.init(notifi_draft_delete_infomaton), object: self)
    }
}

extension WFPublishCell{
    fileprivate func setUI()  {
        contentView.addSubview(bacView)
        contentView.addSubview(bacWiterView)

        bacWiterView.addSubview(titleLabel)
        bacWiterView.addSubview(headImageView)
        bacWiterView.addSubview(timeLabel)
        bacWiterView.addSubview(privateBtn)
        contentView.addSubview(deleteImage)
        contentView.addSubview(deletBtn)
        bacWiterView.addSubview(commentBtn)
        bacWiterView.addSubview(lookBtn)
        bacWiterView.addSubview(priseBtn)
        setConstant()
    }
    
    private func setConstant()  {
        bacView.snp.makeConstraints { (maker) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(10)
        }
        bacWiterView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(bacView.snp.bottom)
        }

        titleLabel.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(12)
            maker.top.equalToSuperview().offset(10)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(40)
        }

        headImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalTo(titleLabel.snp.bottom).offset(0)
            maker.right.equalToSuperview().offset(-16)
            maker.height.equalTo(0)
        }

        privateBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-14)
            maker.top.equalTo(headImageView.snp.bottom).offset(16)
            maker.height.equalTo(20)
            maker.width.equalTo(0)
        }

        timeLabel.snp.makeConstraints { (maker) in
            maker.right.equalTo(privateBtn.snp.left)
            maker.top.bottom.equalTo(privateBtn)
            maker.height.equalTo(20)
        }
        deletBtn.snp.makeConstraints { (maker) in
            maker.right.top.equalToSuperview()
            maker.height.width.equalTo(40)
        }
        deleteImage.snp.makeConstraints { (maker) in
            maker.center.equalTo(deletBtn)
            maker.height.width.equalTo(12)
        }
        lookBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(timeLabel.snp.top)
            maker.left.equalTo(headImageView)
            maker.height.equalTo(timeLabel)
//            maker.width.equalTo(50)
        }
        commentBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(lookBtn.snp.top)
            maker.left.equalTo(lookBtn.snp.right).offset(10)
            maker.height.equalTo(timeLabel)
//            maker.width.equalTo(50)
        }
        priseBtn.snp.makeConstraints { (maker) in
            maker.top.equalTo(lookBtn.snp.top)
            //maker.top.equalTo(headImageView.snp.bottom).offset(16)
            maker.left.equalTo(commentBtn.snp.right).offset(10)
            maker.height.equalTo(timeLabel)
//            maker.width.equalTo(50)
        }

    }
}



