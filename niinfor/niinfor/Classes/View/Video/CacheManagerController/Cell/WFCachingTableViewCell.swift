//
//  WFCachingTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/25.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WFCachingTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var btnClickComplict : ((UIButton,WFCachingTableViewCell)->())?

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate let headerImageView = UIImageView.init()
    fileprivate let titleView       = UILabel.init()
    fileprivate let subTitleView    = UILabel.init()

    fileprivate let classTitleView    = UILabel.init()
    
    
    fileprivate let backView        = UIView.init()
    fileprivate let progressView    = UIProgressView.init()
    fileprivate let speedView       = UILabel.init()
    fileprivate let totalSizeView   = UILabel.init()
    
    fileprivate let pauseImageView  = UIImageView.init()
    
    fileprivate let selectBtn    = UIButton.init()
    
    var model : DownloadCellModel  = DownloadCellModel(){
        didSet{
        }
    }
    
    func configCell(_ model : MainClassVideoStoreModel) {

        selectBtn.isSelected = model.isSelected
        
        pauseImageView.isHidden = true
        titleView.text = model.title
        classTitleView.text = "共\(model.totalClass)课程  已缓存\(model.downloadedNum())课程"
        
        if model.imagePath == ""{
           headerImageView.image      = #imageLiteral(resourceName: "paper_img_neuro")
        }else{
            
            if let url  = URL.init(string: model.imagePath) {
                headerImageView.sd_setImage(with: url, completed: nil)
            }
        }
    }

    
    func configCell(_ model : DownloadCellModel) {
        
        selectBtn.isSelected = model.isSelected
            
        self.model = model
        titleView.text = model.mInfo.title
        totalSizeView.text = "\(model.mInfo.size / 1024 / 1024)M"
        progressView.progress = Float(model.mInfo.downloadProgress) / 100.0
        
        pauseImageView.isHidden = !model.mCanStart
        
        if model.mInfo.coverURL == nil || model.mInfo.coverURL == ""{
            
        }else{
        
        if let url  = URL.init(string: model.mInfo.coverURL) {
            headerImageView.sd_setImage(with: url, completed: nil)
        }
        }
    }
    
    func setProgress(_ progress : CGFloat ,_ downloadSize : CGFloat) {
        backView.isHidden = false
        progressView.progress = Float(progress / 100.0)
        speedView.text        = "\(downloadSize)M"
    }
    
    func setIsdeleteMode (_ isTrue : Bool) {
        selectBtn.snp.updateConstraints { (maker) in
            maker.width.equalTo(isTrue ? 60 : 0)
            maker.top.left.bottom.equalToSuperview()
        }
    }

}

class DownloadCellModel {
    var mInfo:AliyunDownloadMediaInfo!
    var mSource:AliyunDataSource!
    var mCanStop = false
    var mCanPlay = false
    var mCanStart = true
    ///是否选中
    var isSelected = false
    var downloadStatus = 0
    
    
}

extension WFCachingTableViewCell{
    
    func setClassTitleViewHidden() {
         backView.isHidden = false
         classTitleView.isHidden = true
    }
    
    func setProgressViewTitleViewHidden() {
         classTitleView.isHidden = false
         backView.isHidden = true
    }
    
    func setUI() {
         
        setConstraint()
        
        titleView.text             = "刀治疗血管内部分栓塞的脑动脉畸形"
        subTitleView.text          = ""//"神经外科资讯"
        
        classTitleView.text        = "共10课程  已缓存2课程"
        speedView.text             = ""
        totalSizeView.text         = "99M"
        headerImageView.image      = #imageLiteral(resourceName: "paper_img_neuro")
        pauseImageView.image       = #imageLiteral(resourceName: "播放 (1)")
        pauseImageView.isHidden    = true
        progressView.setProgress(0.66, animated: true)
        
    }
    
    @objc func btnclick(){
        if btnClickComplict != nil {
            btnClickComplict!(selectBtn,self)
        }
    }

    
    fileprivate func setConstraint() {
        
        setLabelConfige(titleView, 16, #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
        setLabelConfige(subTitleView, 10, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        
        setLabelConfige(classTitleView, 10, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        setLabelConfige(speedView, 12, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        setLabelConfige(totalSizeView, 12, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        totalSizeView.textAlignment = .right
        
        progressView.progressTintColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        progressView.trackTintColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        contentView.addSubview(selectBtn)
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(subTitleView)
        contentView.addSubview(pauseImageView)
        //
        contentView.addSubview(classTitleView)
        
        contentView.addSubview(backView)
        backView.addSubview(progressView)
        backView.addSubview(speedView)
        backView.addSubview(totalSizeView)
        
        
        selectBtn.setImage(#imageLiteral(resourceName: "video_del_off"), for: .normal)
        selectBtn.setImage(#imageLiteral(resourceName: "icon_checked"), for: .selected)
        selectBtn.addTarget(self, action: #selector(btnclick), for: .touchUpInside)
        
        selectBtn.snp.makeConstraints { (maker) in
            maker.width.equalTo(0)
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview()
        }
        
        headerImageView.snp.makeConstraints { (maker) in
            maker.right.bottom.equalToSuperview().offset(-15)
            maker.top.equalToSuperview().offset(15)
            maker.width.equalTo(102)///120)
            maker.height.equalTo(67.5)//90)
        }
        
        pauseImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(headerImageView)
        }
        
        titleView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(12)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.height.equalTo(30)
            maker.left.equalTo(selectBtn.snp.right).offset(15)
        }
        subTitleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleView)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(titleView.snp.bottom).offset(0)
        }
        
        //
        classTitleView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleView)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(subTitleView.snp.bottom).offset(10)
        }
        
        backView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleView)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(subTitleView.snp.bottom).offset(10)
            maker.bottom.equalToSuperview().offset(-25)
        }

        progressView.snp.makeConstraints { (maker) in
            maker.right.top.equalToSuperview()
            maker.left.equalTo(titleView)
        }
        speedView.snp.makeConstraints { (maker) in
            maker.bottom.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
            maker.top.equalTo(progressView.snp.bottom)
            maker.left.equalTo(progressView)
        }
        totalSizeView.snp.makeConstraints { (maker) in
            maker.right.bottom.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
            maker.top.equalTo(progressView.snp.bottom)
        }


        
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }
}



import RealmSwift


///课程存储对象
class MainClassVideoStoreModel : Object {
    
    @objc dynamic var id : Int = UserDefaults.standard.value(forKey: user_class_video_mainKey) as! Int
    @objc dynamic var classId : String = ""
    @objc dynamic var userId : String = ""
    @objc dynamic var title : String = ""
    @objc dynamic var imagePath : String = ""
    @objc dynamic var fileData : Data? = nil
    @objc dynamic var creatTime : String = ""
    @objc dynamic var articleType : String = "0"
    @objc dynamic var totalClass : Int = 0
    @objc dynamic var isSelected  : Bool = false
    let models = List<VideoDetailModel>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    func cellModel(_ row:Int) -> VideoDetailModel {
        var index = 0;
        for m in models {
            if m.downloadStatus == 2 {
                if (index == row) {
                    return m
                }
                index = index+1;
            }
        }
        return VideoDetailModel()
    }
    func downloadedNum()-> Int {
        return models.filter({detailModel -> Bool in
            return detailModel.downloadStatus == 2
        }).count
    }
}

///储存中间层 meditor
class VideoDetailModel : Object {
    
    ///数据类型
    @objc dynamic var vid : String = ""
    
    @objc dynamic var title : String = ""
    
    @objc dynamic var imagePath : String = ""
    
    @objc dynamic var totalSize : Int = 0
    
    @objc dynamic var duration : Int = 0
    
    @objc dynamic var quality : String = ""
    
    @objc dynamic var isSelected  : Bool = false
    
    @objc dynamic var videoPath : String = ""
    
    @objc dynamic var downloadStatus  : Int = 0 /// downloadStatus 0 未下载 1 正在下载  2 下载完成 -1 下载失败
    @objc dynamic var mainKey  : Int = 0
    
    let owners = LinkingObjects(fromType: MainClassVideoStoreModel.self, property: "models")
    
    var druationString : String{
        let second  = duration % 60
        let minit   = (duration / 60) //% 60
        if minit == 0{
            return " 00:\(String.init(format: "%02d", second))分钟"
        }else{
            return "\(String.init(format: "%02d", minit)):\(String.init(format: "%02d", second))分钟"
        }
    }
}






