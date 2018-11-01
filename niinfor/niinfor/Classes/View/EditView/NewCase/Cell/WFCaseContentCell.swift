//
//  WFCaseContentCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/15.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import YYImage
import RealmSwift

class WFCaseContentCell: UITableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        contentView.addSubview(bacImageView)
        contentView.addSubview(headerImageView)
        contentView.addSubview(shadowImageView)
        contentView.addSubview(imgBtn)
        contentView.addSubview(contentLabel)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(detailBtn)
//        contentView.addSubview(backView)
        contentView.addSubview(clickBtn)
        contentView.addSubview(textClickBtn)
        selectionStyle = .none
        ///设置约束
        setConstant()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
     var disposeBug = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBug = DisposeBag()
    }
    
    var model : CaseDetailModel? {
        didSet{
            
            
            if let imageN = model?.imageName {
                headerImageView.image = imageN//UIImage.init(data: (model?.imageName)!)////UIImage.init(named: model?.imageName ?? "")
            }else{
//                headerImageView.image = #imageLiteral(resourceName: "paper_img_neuro")
                if let urlString = model?.imagePath,
                    let url = URL.init(string:  urlString){
                    headerImageView.sd_setImage(with: url, placeholderImage:#imageLiteral(resourceName: "editePlaceholder") )
                }else{
                   headerImageView.image = #imageLiteral(resourceName: "editePlaceholder")
                }
            }
            
            imgBtn.isSelected = false
            contentLabel.text = model?.title ?? ""
            
            guard let modelType  = model?.fileType else { return }
            shadowImageView.image = nil
            switch modelType {
            case .unkown,.image :
                imgBtn.isSelected = false
                imgBtn.setImage(nil, for: .normal)
            case .audio  ://YYImage.init(named: "release_soundss.gif")
                  shadowImageView.image = YYImage.init(named: "release_soundss.gif")
                  //YYImage.init(named: "video_item")
//                break
                imgBtn.setImage(#imageLiteral(resourceName: "video_item"), for: .selected)
                imgBtn.isSelected = true
//             imgBtn.setBackgroundImage(#imageLiteral(resourceName: "release_sounds"), for: .normal)//imgBtn.setImage(#imageLiteral(resourceName: "语音"), for: .normal)
            case .video  : imgBtn.setImage(#imageLiteral(resourceName: "播放 (1)"), for: .normal)//imgBtn.setImage(#imageLiteral(resourceName: "播放 "), for: .normal)
               // #imageLiteral(resourceName: "播放 ")
            }
            
        }
    }
    
    
    
    ///头部图片
    lazy var bacImageView : UIImageView = {
        
        let imageV = UIImageView.init()
        imageV.backgroundColor = UIColor.white
        
        return imageV
    }()

    ///头部图片
    lazy var headerImageView : UIImageView = {
        
        let imageV = UIImageView.init()
        imageV.layer.cornerRadius = 2
        
        return imageV
    }()
    
    //声音视频图片
    lazy var shadowImageView : YYAnimatedImageView = {
        
        let imageV = YYAnimatedImageView.init()
        
        return imageV
    }()

    //点击button
    lazy var imgBtn : UIButton = {
        
        let btn = UIButton.init()

        return btn
    }()
    
    ///显示内容
    lazy var contentLabel : UILabel = {
        
        let label = UILabel.init()
        
        label.text = "是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = #colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1)
        label.numberOfLines = 0
        
        return label
    }()
    
    ///删除btn
    lazy var deleteBtn : UIButton = {
        
        let btn = UIButton.init()
            btn.setImage(#imageLiteral(resourceName: "删除"), for: .normal)
        
        return btn
    }()
    
    ///
    lazy var detailBtn : UIButton = {
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "Group 3"), for: .normal)
        
        return btn
    }()
    
    ///加号 按钮
    var clickBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        btn.setImage( #imageLiteral(resourceName: "Add to"), for: .normal)
        
        return btn
    }()
    var backView  : UIView  = {
        
        let btn : UIView = UIView.init()
        
        btn.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        return btn
    }()

    var textClickBtn : UIButton  = {
        
        let btn : UIButton = UIButton.init(type: .custom)
        
        return btn
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

///添加约束
extension WFCaseContentCell{

    func setConstant() {
        
        bacImageView.snp.makeConstraints { (maker ) in
            maker.left.right.top.equalToSuperview()
            maker.height.equalTo(100)
        }
        
        headerImageView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.top.equalToSuperview().offset(11.5)
            maker.height.equalTo(77)
            maker.width.equalTo(77)
        }
        
        shadowImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(headerImageView)
        }
        
        imgBtn.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalTo(headerImageView)
//            maker.center.equalTo(headerImageView)
//            maker.height.width.equalTo(38.5)
        }

        deleteBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-16 )//7.5)
            maker.top.equalToSuperview().offset(12)//-3.25)
            maker.width.height.equalTo(12)//23.5)
        }

        detailBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(deleteBtn)
            maker.top.equalTo(deleteBtn.snp.bottom).offset(16.5)//deleteBtn.xf_height)
            maker.width.height.equalTo(deleteBtn)
        }
        
        clickBtn.snp.makeConstraints { (maker ) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(contentView.snp.bottom).offset(-50)
        }

        contentLabel.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(7.5)
            maker.bottom.lessThanOrEqualTo(clickBtn.snp.top).offset(5)//-11.5)
            maker.left.equalTo(headerImageView.snp.right).offset(8)
            maker.right.equalTo(deleteBtn.snp.left).offset(-12)
        }
        
        textClickBtn.snp.makeConstraints { (maker) in
            maker.top.left.right.bottom.equalTo(contentLabel)
        }

        
        
//        backView.snp.makeConstraints { (maker ) in
//            maker.left.right.top.bottom.equalTo(clickBtn)
//        }
    }
    
}


class CaseDetailModel : NSObject {
    
    enum FileType : Int {
        case unkown = 0
        case image  = 1
        case video  = 2
        case audio  = 3
    }
    
    var title : String
    
    var imageName : UIImage?
    
    var imagePath : String = ""
    
    var fileType : FileType
    
    var isHeadImage : Bool = false
    
    var htmlString  = ""
    
    ///视频
    var videoPath = ""
    
    ///音频
    var filePath = ""
    
    init(_ imageNam : UIImage? , _ titl : String) {
        
         title = titl
         htmlString = titl
        
         if title == "" {
           title = "点击添加文字"
         }
        
         imageName = imageNam
         fileType = .unkown
         super.init()
    }
    
    func getFilePathData() -> Data? {
        
        let url  = URL.init(fileURLWithPath: videoPath)
        
        do{
            return try? Data.init(contentsOf: url)
        }catch {
            return nil
        }
//         guard let url  = URL.init(string: videoPath) else { return nil }
//
//         do{
//            return try? Data.init(contentsOf: url)
//         }catch {
//            return nil
//         }
    }
    
//    func getVideoPathData() -> Data? {
//
//        guard let url  = URL.init(fileURLWithPath: videoPath) else { return nil }
//
//        do{
//            return try? Data.init(contentsOf: url)
//        }catch {
//            return nil
//        }
//    }

    
}


///储存中间层 meditor
class CaseDetailStoreModel : Object {
    
    ///数据类型
   @objc dynamic var dataType : Int = 0
    
   @objc dynamic var title : String = ""
   
   @objc dynamic var filePath : String = ""
    
   @objc dynamic var fileData : Data?
   
   @objc dynamic var imageData : Data?
    
   @objc dynamic var imagePath : String = ""
    
   @objc dynamic var fileType : Int = 0
    
   @objc dynamic var isHeadImage : Bool = false
    
   @objc dynamic var htmlString  = ""
    
   let owners = LinkingObjects(fromType: MainCaseStoreModel.self, property: "models")
    
   
    func getFileDataPath(_ filePath : String) -> Bool {
        
        guard let url  = URL.init(string: filePath) else { return false }
        
        do{
            let data = try? Data.init(contentsOf: url)
            if data?.count ?? 0 > 100 {
                return true
            }
            return false
        }catch {
            return false
        }
    }
}

///主要存储对象
class MainCaseStoreModel : Object {
    
      @objc dynamic var id : Int = UserDefaults.standard.value(forKey: user_data_mainKey) as! Int
      @objc dynamic var title : String = ""
      @objc dynamic var imagePath : String = ""
      @objc dynamic var fileData : Data? = nil
      @objc dynamic var creatTime : String = ""
      @objc dynamic var articleType : String = "0"
      let models = List<CaseDetailStoreModel>()
    
      override static func primaryKey() -> String? {
         return "id"
      }

}




