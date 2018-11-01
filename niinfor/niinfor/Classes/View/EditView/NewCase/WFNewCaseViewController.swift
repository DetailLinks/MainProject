//
//  WFNewCaseViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/14.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import TZImagePickerController
import ZLPhotoBrowser
import SVProgressHUD
import RealmSwift

class WFNewCaseViewController: BaseViewController  {
    
    enum ChooseImageType {
        case headimage
        case addNewimage
        case boolFileimage
        case video
    }
    
    enum CaseType {
        case old(String)
        case new
    }
    
    let realm = try! Realm()
    
    var caseType : CaseType = .new{
        didSet{
            switch caseType {
            case .new:
                createNewModel()
            case .old(let mainKey):
                getAdataSourceWithMainkey(mainKey)
            }
        }
    }
    fileprivate var ketID = 0
    fileprivate var btnright = UIButton.init()
    
    fileprivate var chooseImageType : ChooseImageType = .headimage
    
    fileprivate lazy var tableView : WFMoveCellTableView = WFMoveCellTableView.init(frame: CGRect.zero, style: .grouped)
    
    fileprivate var headerImageView : UIImageView?
    fileprivate var headerTitle : String = ""
    fileprivate var headerImagePath : String = ""
    
    
    fileprivate lazy var funcChooseView : WFFunctionChooseView = {
        
        let funcV = WFFunctionChooseView.init(frame: CGRect.init(x: Screen_width/2 - transWidth(378.0)/2, y:0  , width: transWidth(378.0), height: transWidth(378.0) * 123.0 / 378.0))
        
        return funcV
    }()
    
    fileprivate lazy var voiceRecoder : WFVoiceRecorder = WFVoiceRecorder.share()
    
    var article:WFMPArticle? = nil
    var articleType = "0" //1随笔
    fileprivate let headerHeight  = transHeight(517-202) + 10 + 50
    
    func imageEditV() -> ZLPhotoActionSheet {
        
        let imageP = ZLPhotoActionSheet.init()
        imageP.configuration.editAfterSelectThumbnailImage = true
        imageP.sender = self
        imageP.arrSelectedAssets = self.lastSelectAssets as? NSMutableArray
        imageP.configuration.allowEditVideo = true
        imageP.configuration.maxVideoDuration = 300
        imageP.configuration.showSelectBtn = false
        imageP.configuration.navBarColor = UIColor.white
        imageP.configuration.navTitleColor = UIColor.black
        imageP.configuration.allowSelectVideo = !isHiddenVideo
        imageP.configuration.maxSelectCount = uploadMaxCount
        
        imageP.selectImageBlock = {[weak self] (phpto , asset , isTrue ) in
            print("选择图片")
            
            guard let photo  = phpto else { return}
            //                self?.lastSelectAssets = asset
            self?.imageArr = photo
            //                self?.lastSelectPhotos = photo
            
            if self?.uploadMaxCount == 9 {
                var sectionNumber  = (self?.selectIndexPath?.row)!
                
                for item in photo{
                    
                    var model  = CaseDetailModel.init(nil, "")
                    model.imageName = item
                    model.fileType  = .image
                    mainDataSouce.insert(model, at:sectionNumber)
                    sectionNumber += 1
                }
                
                sectionNumber  = (self?.selectIndexPath?.row)!
                for item in asset{
                    self?.lastSelectAssets.insert(item, at: sectionNumber)
                    sectionNumber += 1
                }
                
            }else{
                
                mainDataSouce[(self?.selectIndexPath?.row)!].imageName  = photo[0]
                //self?.lastSelectAssets[(self?.selectIndexPath?.row)! ] = asset[0]
                
                switch asset[0].mediaType {
                case .unknown: mainDataSouce[(self?.selectIndexPath?.row)! ].fileType  = .unkown
                case .image  : mainDataSouce[(self?.selectIndexPath?.row)! ].fileType  = .image
                case .audio  : mainDataSouce[(self?.selectIndexPath?.row)! ].fileType  = .audio
                case .video  : mainDataSouce[(self?.selectIndexPath?.row)! ].fileType  = .video
                    
                }
            }
            if self?.isFirstupLoadImage == 0  && asset[0].mediaType == .image{
                mainDataSouce[0].imageName  = photo[0]
                mainDataSouce[0].fileType  = .image
                //               self?.isFirstupLoadImage = 1
            }
            
            self?.tableView.reloadData()
        }
        
        imageP.cancleBlock = {
            print("取消选择相册")
            imageP.sender = nil
        }
        
        return imageP
    }
    
    fileprivate var selectIndexPath : IndexPath? = IndexPath.init(row: 0, section: 0)
    
    fileprivate var lastSelectAssets = [PHAsset]()
    fileprivate var lastSelectPhotos = [UIImage]()
    fileprivate var imageArr = [UIImage]()
    fileprivate var isHiddenVideo = true
    
    fileprivate var isFirstupLoadImage : Int {
        
        if headerImageView?.image != nil {
            return 1
        }

        if mainDataSouce.count == 0 {
            return 0
        }
        
        for model in mainDataSouce {
            if model.fileType == .image {
                return 1
            }
        }
        return 0
    }
    fileprivate var uploadMaxCount = 9
    
    fileprivate var playingComplict : ((Bool)->())?
    
    fileprivate var audioPlayer:AVAudioPlayer!
    
    fileprivate var allowPickerVideo  = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        hideFuncView(true)
    }
}

///获取 数组中的image
extension WFNewCaseViewController{
    
    func getMaindataSourceImages() ->[ChooseImageModel]{
        
        var itemArr  = [ChooseImageModel]()
        
        for (index, item ) in mainDataSouce.enumerated() {
            if item.fileType == .image {
                print(item.isHeadImage)
                let model  =  ChooseImageModel.init(item.imageName!, item.isHeadImage)
                model.indexRow = index
                model.isEditImage = true
                itemArr.append(model)
            }
        }
        
        return itemArr
    }
    
    func updateDataFromArticle() {
        if let art = article {
            DispatchQueue.main.async {
            let data = art.content?.data(using: String.Encoding.utf8)
            let arr = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSArray
                self.headerTitle = art.title ?? ""
                self.headerImagePath = art.cover ?? ""
                var image : UIImage? = nil
                if !self.headerImagePath.isEmpty {
                    DispatchQueue.global().async {
                    if  let data = try? Data.init(contentsOf: URL.init(string: self.headerImagePath)!){
                        let imagee = UIImage.init(data: data)
                        image = imagee
                        }
                        
                    }
            }
            
            mainDataSouce.removeAll()
            var dataSource  = [CaseDetailModel]()
                
            for (index,obj ) in arr.enumerated() {
                let obj:NSDictionary = obj as! NSDictionary
                let item = CaseDetailModel(nil, "")
                let type:String = obj.object(forKey: "type") as! String
                switch type {
                case "txt" :
                    item.htmlString = obj["text"] as? String ?? ""
                    item.fileType = .unkown
                    break
                case "img":
                    item.htmlString = obj["text"] as? String ?? ""
                    item.imagePath = obj["resource"] as? String ?? ""
                    item.isHeadImage = obj["isCover"] as! Bool
                    item.fileType = .image
                case "sound":
                    item.htmlString = obj["text"] as? String ?? ""
                    item.videoPath = obj["resource"] as? String ?? ""
                    DispatchQueue.global().async {
                        if  let data = try? Data.init(contentsOf: URL.init(string: item.videoPath)!){
                            item.videoPath = data.saveToPath("\(index)")
                        }
                    }
                    item.fileType = .audio
                case "video":
                    item.htmlString = obj["text"] as? String ?? ""
                    item.videoPath = obj["resource"] as? String ?? ""
                    item.imagePath = obj["image"] as? String ?? ""
//                    DispatchQueue.global().async {
//                        if  let data = try? Data.init(contentsOf: URL.init(string: item.imagePath)!){
//                            let imagee = UIImage.init(data: data)
//                            item.imageName = imagee
//                            item.imagePath = (imagee?.saveImageToFile())!
//                        }
//                    }
                    DispatchQueue.global().async {
                        if  let data = try? Data.init(contentsOf: URL.init(string: item.videoPath)!){
                            item.videoPath = data.saveVideoToPath("\(index)")
                        }
                    }
                    item.fileType = .video
                default:
                    break
                }
                if !item.imagePath.isEmpty {

                    DispatchQueue.global().async {
                    if  let data = try? Data.init(contentsOf: URL.init(string: item.imagePath)!){
                        let imagee = UIImage.init(data: data)
                        item.imageName = imagee
                        item.imagePath = (imagee?.saveImageToFile())!
                    }
                    }

                    
                }
                item.title = self.removeHTML(item.htmlString)
                dataSource.append(item)
            }
                DispatchQueue.main.async {
                    mainDataSouce = dataSource
                    if !self.headerImagePath.isEmpty {
                        self.headerImageView?.image = image
                    }

                   self.tableView.reloadData()
                }
            }
        }
    }
    func removeHTML(_ htmlString : String)->String{
        return htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "&nbsp;", with: "")
    }
}


///设置界面
extension WFNewCaseViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        //        UIApplication.shared.openURL(URL.init(string: "itms-apps://itunes.apple.com/cn/app/id1049283424?mt=8&action=write-review")!)
        //        ///"http://itunes.apple.com/cn/app/shen-wai-zi-xun/id1049283424?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Softwaremt=8")!)
        //        //[[UIApplicationsharedApplication]openURL:[NSURLURLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=APPID&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]]
        
        let userdefault = UserDefaults.standard
        
        let isFirstLook = userdefault.value(forKey: user_isFirstLook)
        
        navItem.title = "发布"
        
        removeTabelView()
        
        view.addSubview(self.tableView)
        setChooseViewll()
        
        setTableView()
        setNavigationBtn()
        
        //从article获取mainDataSouce
        updateDataFromArticle()
        
        for item  in mainDataSouce {
            base_dataList.append(item as AnyObject)
        }
        
        tableView.insertSubview(funcChooseView, at: 0)
        funcChooseView.isHidden = true
        // audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        //MARK:加这段代码解决声音很小的问题
        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        
        if isFirstLook == nil {
            let v = WFFirstLookView()
            view.addSubview(v)
            v.setTitleConstrant()
            v.complict = {
                
                let v1 = WFFirstLookView()
                self.view.addSubview(v1)
                v1.setFuncConstrant()
                
                v1.complict = {
                    
                    let v2 = WFFirstLookView()
                    self.view.addSubview(v2)
                    v2.setVoiceConstrant()
                    v2.complict = {
                        let v3 = WFFirstLookView()
                        self.view.addSubview(v3)
                        v3.setImageConstrant()
                        v3.snp.makeConstraints { (maker ) in
                            maker.left.right.bottom.top.equalToSuperview()
                        }
                    }
                    v2.snp.makeConstraints { (maker ) in
                        maker.left.right.bottom.top.equalToSuperview()
                    }
                }
                v1.snp.makeConstraints { (maker ) in
                    maker.left.right.bottom.top.equalToSuperview()
                }
            }
            v.snp.makeConstraints { (maker ) in
                maker.left.right.bottom.top.equalToSuperview()
            }
        }
        
        userdefault.set("sjfaljfl", forKey: user_isFirstLook)
      }
    
    fileprivate func setNavigationBtn() {
        
        btnright   = UIButton.cz_textButton("下一步", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        //        btnright.setTitleColor(, for: .selected)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        
    }
    
    
    fileprivate func pushTextEditViewController(_ text : String , _ isCell : Bool = false ,_  index : IndexPath = IndexPath.init(row: 0, section: 0)) {
        
        let vc  = WFTextEditViewController()
        vc.htmlString = text
        
        vc.complictBlock = {[weak self] (text) in
            var model : CaseDetailModel = CaseDetailModel.init(nil, (self?.removeHTML(text.0))!)
            model.fileType = .unkown
            model.htmlString = text.1
            
            if isCell {
                model = mainDataSouce[index.row]
                model.title = (self?.removeHTML(text.0))!
                model.htmlString = text.1
            }else{
                
                mainDataSouce.insert(model, at: (self?.selectIndexPath?.row)!)
            }
            
            self?.tableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func setChooseViewll() {
        
        funcChooseView.imageBtn.rx.tap.asObservable().subscribe(onNext:{[weak self] in
            
            //            self?.uploadMaxCount = 9
            //            self?.isHiddenVideo = true
            //            self?.chooseImage(false,(self?.selectIndexPath)!)
            self?.chooseImageType = .addNewimage
            self?.uploadMaxCount = 9
            self?.isHiddenVideo = true
            self?.allowPickerVideo = false
            self?.chooseImageView(9)
            
        }).disposed(by: funcChooseView.disposeBag)
        
        funcChooseView.textBtn.rx.tap.asObservable().subscribe(onNext:{[weak self] in
            
            self?.hideFuncView(true)
            
            self?.pushTextEditViewController("")
            
        }).disposed(by: funcChooseView.disposeBag)
        
        funcChooseView.voiceBtn.rx.tap.asObservable().subscribe(onNext:{[weak self] in
            
            self?.hideFuncView(true)
            let vc  = WFVoiceViewController()
            vc.recordVoiceCoplict = {[weak self] (filePath) in
                
                let model : CaseDetailModel = CaseDetailModel.init(nil, "")
                model.fileType = .audio
                model.videoPath = filePath
                mainDataSouce.insert(model, at: (self?.selectIndexPath?.row)!)
                self?.tableView.reloadData()
            }
            
            let navigation = UINavigationController.init(rootViewController: vc)
            self?.present(navigation, animated: true, completion: nil)
            
        }).disposed(by: funcChooseView.disposeBag)
        
        funcChooseView.videoBtn.rx.tap.asObservable().subscribe(onNext:{[weak self] in
            
            self?.chooseImageType = .video
            self?.uploadMaxCount = 1
            self?.isHiddenVideo = true
            self?.allowPickerVideo = true
            self?.chooseImageView(1)
            
        }).disposed(by: funcChooseView.disposeBag)
        
    }
}

///数据源
var mainDataSouce : [CaseDetailModel] = {//UIImage.init(named:"Group 5")!
    return [
        //        CaseDetailModel.init(nil, "请设置标题："),
        //        CaseDetailModel.init(nil, "随笔是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"),
        //        CaseDetailModel.init(nil, "直播是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"),
        //        CaseDetailModel.init(nil, "草稿箱是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"),
        //        CaseDetailModel.init(nil, "已发布是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"),
        //        CaseDetailModel.init(nil, "文章投稿是捡垃圾垃圾发链接发放；阿来得及发；两地分居；案例都费劲啊；了费劲啊；浪费；阿里看见的法律都费劲啊来得及发来得及发来撒大家发了；费劲的；冷风机阿里的风景； 拉风的alfalfa发；奥拉夫安抚"),
    ]
}()

////数据库 操作
extension WFNewCaseViewController{
    
    fileprivate func getAdataSourceWithMainkey(_ key : String = "") {
        
        var keyCount = 0
        if key == "" {
            createNewModel()
        }else{
            keyCount = Int(key)!
            ketID = keyCount
            getOldDataSourceByMainKey(keyCount,realm)
        }
    }
    
    func createNewModel() {
        var keyCount = 0
        keyCount = UserDefaults.standard.value(forKey: user_data_mainKey) as! Int
        keyCount += 1
        UserDefaults.standard.set(keyCount, forKey: user_data_mainKey)
        
        ketID = keyCount
        realm.beginWrite()
        let model = MainCaseStoreModel()
        let date  = Date()
        let dateFommate = DateFormatter.init()
        dateFommate.dateFormat = "yyyy-MM-dd"
        model.creatTime = dateFommate.string(from: date)
        model.articleType = articleType
        realm.add(model)
        try! realm.commitWrite()
    }
    
    ///读
    fileprivate func getOldDataSourceByMainKey(_ key : Int , _ realm : Realm) {
        guard let mainDataSourceModel  = realm.object(ofType: MainCaseStoreModel.self, forPrimaryKey: key) else {
            return
        }
        
        if self.headerImageView == nil  {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.2) {
                if let imageData = mainDataSourceModel.fileData {
                    self.headerImageView?.image = UIImage.init(data: imageData)
                    if let path = self.headerImageView?.image?.saveImageToFile(){
                         self.headerImagePath = path
                    }
                }
            }
        }else{
            if let imageData = mainDataSourceModel.fileData {
                self.headerImageView?.image = UIImage.init(data: imageData)
                self.headerImagePath = (self.headerImageView?.image!.saveImageToFile())!
            }

        }
        

        headerTitle = mainDataSourceModel.title
        
        if mainDataSourceModel.models.count > 0 {
            var count  = 0
            for (_ , item) in mainDataSourceModel.models.enumerated(){
                count += 1
                let model = CaseDetailModel.init(nil, item.title)
                if let data = item.imageData {
                    model.imageName = UIImage.init(data: data)
                    model.imagePath = model.imageName?.saveImageToFile("\(count)") ?? ""
                }
                
                
                if item.getFileDataPath(item.filePath) == true {
                    model.imagePath = item.imagePath
                }
                
                switch item.fileType {
                case 0 : model.fileType = .unkown
                case 1 : model.fileType = .image
                case 2 : model.fileType = .video
//                     if let data = item.fileData {
                        model.videoPath = item.filePath//data.saveVideoToPath("\(count)")
//                        }
                case 3 : model.fileType = .audio
                       if let data = item.fileData {
                         model.videoPath = data.saveToPath("\(count)")
                        }
                default : break
                }
                
                model.isHeadImage = item.isHeadImage
                model.htmlString = item.htmlString
                
                mainDataSouce.append(model)
            }
            
            //self.tableView.reloadData()
        }
    }
    
    ///存
    func saveData() {
        //         realm.beginWrite()
        //        realm.add(mydog)
        
        var mainModel = MainCaseStoreModel.init()
        switch caseType {
        case .new:
            guard  let model  = realm.object(ofType: MainCaseStoreModel.self, forPrimaryKey: UserDefaults.standard.value(forKey: user_data_mainKey) as! Int) else{
                return
            }
            mainModel = model
        case .old(let string):
            guard  let model = realm.object(ofType: MainCaseStoreModel.self, forPrimaryKey: Int(string) ) else{
                return
            }
            mainModel = model
        default: break
            
        }
        
        
        try! realm.write {
            if  let image  = headerImageView?.image {
                mainModel.fileData = image.sd_imageData()
            }
            mainModel.articleType = articleType
            mainModel.title = headerTitle
            mainModel.imagePath = headerImagePath
//            mainModel.models.removeAll()
            
            realm.delete(mainModel.models)
            
            if mainDataSouce.count > 0 {
                
                for (_ , item) in mainDataSouce.enumerated(){
                    
                    let model = CaseDetailStoreModel()
                    model.title = item.title
                    model.isHeadImage = item.isHeadImage
                    
                    switch item.fileType.rawValue {
                    case 0 :
                        model.fileType = 0
                        model.htmlString = item.htmlString
                    case 1 :
                        model.fileType = 1
                        model.imageData = item.imageName?.sd_imageData()
                        model.imagePath = item.imagePath
                    case 2 :
                        model.fileType = 2
                        model.imageData = item.imageName?.sd_imageData()
                        model.imagePath = item.imagePath
                        model.filePath = item.videoPath
                        model.fileData = item.getFilePathData()
                    case 3 :
                        model.fileType = 3
                        model.filePath = item.videoPath
                        //model.fileData = item.getFilePathData()
                        
                    default : break
                    }
                    
                    mainModel.models.append(model)
                }
            }
            if mainModel.title == "" &&
                mainModel.models.count == 0 &&
                mainModel.fileData == nil {
                
            }else {
                SVProgressHUD.showInfo(withStatus: "已存为草稿")
                realm.add(mainModel)
            }
        }
    }
}

///视图生命周期
extension WFNewCaseViewController : NavigationClipToPopViewProtocol{
    func viewWillPopViewController()->Bool {
        
        if article == nil {
           
           saveData()
           return true
        }else{
            
            var isJump = false
            let alertController  = UIAlertController(title: "提示信息", message: "返回后文章将不会被保存", preferredStyle: .alert)
            
            let action1  = UIAlertAction(title:"确定", style: .default) { (_) in
                isJump = true
                self.navigationController?.popViewController(animated: true)
            }
            
            alertController.addAction(action1)
            
            let action2  = UIAlertAction(title:"取消", style: .cancel) { (_) in
                isJump = true
            }
            alertController.addAction(action2)
            self.present(alertController, animated: true, completion: nil)

            return isJump
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nav = self.navigationController as? WFNavigationController else {
            return
        }
        nav.clipDelegate = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let nav = self.navigationController as? WFNavigationController else {
            return
        }
        nav.clipDelegate = nil
    }
}

///响应事件
extension WFNewCaseViewController{
    
    @objc func rightBtnclick(){
        
        if headerTitle == "" {
            SVProgressHUD.showInfo(withStatus: "请添加标题")
            return
        }
        if mainDataSouce.count < 1 {
            SVProgressHUD.showInfo(withStatus: "请至少添加一个段落")
            return
        }
        let vc = WFPreviewViewConttoller()
        vc.dataSource = mainDataSouce
        vc.headerTitle = headerTitle
        vc.headerImagePath = headerImagePath
        vc.articleType = articleType
        vc.keyID = ketID
        if let art = article {
            vc.articleId = art.id!
            vc.articleType = art.type!
            vc.subSpecialModel = art.dicts!
            vc.permisson = art.permission ?? ""
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func addBtnClick(_ btn : UIButton) {
        
        if let cell =  btn.superview?.superview as? WFCaseContentCell,
            let indexPath = tableView.indexPath(for: cell){
            self.selectIndexPath = indexPath
            
            print(indexPath)
            var frame  = self.funcChooseView.frame
            let funcVY  = self.headerHeight + CGFloat(indexPath.row + 1) * 150.0 + 45.0 - 50
            print(indexPath)
            if funcVY == frame.origin.y {
                self.hideFuncView(!self.funcChooseView.isHidden)
                
            }else{
                
                frame.origin.y = funcVY
                self.funcChooseView.frame = frame
                self.hideFuncView(false)
            }
            self.selectIndexPath = IndexPath.init(row: indexPath.row + 1, section: 0)
            tableView.bringSubview(toFront: self.funcChooseView)
        }
    }
    
    @objc func imgBtnClick(_ btn : UIButton) {
        
        if let cell =  btn.superview?.superview as? WFCaseContentCell,
            let indexPath = tableView.indexPath(for: cell){
            self.selectIndexPath = indexPath
            print("点击图片\(indexPath)")
            
            guard let model = cell.model else {
                return
            }
            
            switch model.fileType {
            case .unkown:
                self.chooseImageType = .headimage
                self.uploadMaxCount = 1
                self.isHiddenVideo = false
                self.allowPickerVideo = false
                self.chooseImageView(self.uploadMaxCount)
                
                break
            case .image  :
                self.chooseImageType = .headimage
                self.uploadMaxCount = 1
                self.isHiddenVideo = false
                self.allowPickerVideo = false
                self.chooseImageView(self.uploadMaxCount,true)
                
                //                if mainDataSouce[indexPath.section].imageName == nil{
                //                    self.chooseImage(false,indexPath)
                //                }else{
                //                    self.chooseImage(true,indexPath)
                //                }
                break
            case .audio  :
                btn.isSelected = !btn.isSelected
                
                let url = URL(fileURLWithPath: model.videoPath)
                audioPlayer = try? AVAudioPlayer(contentsOf: url )
                audioPlayer.delegate = self
                audioPlayer.play()
                playingComplict = { (isFinished) in
                    btn.isSelected = true
                }
                //                 voiceRecoder.pausePlaying() :
                if  btn.isSelected == false {
                    voiceRecoder.startPlaying()
                    
                }else{
                    if audioPlayer != nil && audioPlayer.isPlaying{
                        voiceRecoder.pausePlaying()
                    }
                    btn.isSelected = true
                }
                
                voiceRecoder.playingComplict = {[weak self](isFinish) in
                    btn.isSelected = true
                    self?.voiceRecoder.playingComplict = nil
                }
                
                break
            case .video  :
                
                if mainDataSouce[indexPath.row].videoPath == "" {
                    return
                }
                let vc  = WFEditVideoController()
                vc.videoPath = mainDataSouce[indexPath.row].videoPath
                vc.isOnlylook = true
                vc.complict = {(path ) in
                    mainDataSouce[indexPath.row].videoPath = path
                }
                self.present(vc , animated: true, completion: nil)
                
                break
            }
        }
    }
    
    @objc func deleteBtnClick(_ btn : UIButton) {
        
        if let cell =  btn.superview?.superview as? WFCaseContentCell,
            let indexPath = tableView.indexPath(for: cell){
            print(indexPath)
            
            if mainDataSouce[indexPath.row].isHeadImage == true{
                mainDataSouce.remove(at: indexPath.row)
                
                if mainDataSouce.count > 0 {
                    for item in mainDataSouce {
                        if item.fileType == .image{
                            self.headerImageView?.image = item.imageName
                            item.isHeadImage = true
                            self.tableView.reloadData()
                            return
                        }
                    }
                }
                
                self.headerImageView?.image = nil
                
            }else{
                
                mainDataSouce.remove(at: indexPath.row)
            }
            self.tableView.reloadData()
        }
    }
    
    @objc func detailBtnClick(_ btn : UIButton) {
        
         SVProgressHUD.showInfo(withStatus: "长按并拖拽段落可调整排序")
//        if  let cell =  btn.superview?.superview as? WFCaseContentCell,
//            let indexPath = tableView.indexPath(for: cell){
//            mainDataSouce.remove(at: indexPath.section)
//            tableView.reloadData()
//        }
    }
    
    @objc func textClickBtnClick(_ btn : UIButton) {
        
        if  let cell =  btn.superview?.superview as? WFCaseContentCell,
            let indexPath = tableView.indexPath(for: cell){
            let htmlString = mainDataSouce[indexPath.row].htmlString
            pushTextEditViewController(htmlString,true,indexPath)
        }
    }
    
    @objc func tapGesturee(){
        hideFuncView(true)
    }
}

extension WFNewCaseViewController : AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            if playingComplict != nil {
                playingComplict!(true)
            }
            print("播放完成\(flag)")
        }else{
            print("播放未完成")
        }
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(error)
    }
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
        print("audioPlayerBeginInterruption")
    }
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
        print("audioPlayerEndInterruption")
    }
    
    
}


extension WFNewCaseViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFCaseContentCell().identfy, for: indexPath) as? WFCaseContentCell
        
        cell?.imgBtn.addTarget(self, action: #selector(imgBtnClick(_:)), for: .touchUpInside)
        
        cell?.deleteBtn.addTarget(self, action: #selector(deleteBtnClick(_:)), for: .touchUpInside)
        
        cell?.detailBtn.addTarget(self, action: #selector(detailBtnClick(_:)), for: .touchUpInside)
        
        cell?.clickBtn.addTarget(self, action: #selector(addBtnClick(_:)), for: .touchUpInside)
        
        cell?.textClickBtn.addTarget(self, action: #selector(textClickBtnClick(_:)), for: .touchUpInside)
        
        cell?.model = mainDataSouce[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0//section == 0 ? 50 : 0
//    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight//section == 0 ? (headerHeight) : 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainDataSouce.count//section == 0 ? 0 : 1
    }
    
    
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        return 1//mainDataSouce.count
    //    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 {
            
            let header  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WFCaseEditHeaderView") as? WFCaseEditHeaderView
            headerImageView = header?.imageV
            
            if !headerTitle.isEmpty {
                header?.titleView.text = headerTitle
            }
            if !headerImagePath.isEmpty {
                var path = headerImagePath
                if path.starts(with: "http") {
                    
                }
                else {
                    path = "file://"+headerImagePath
                }
                headerImageView?.sd_setImage(with: URL.init(string: path), completed: nil)
                
                //headerImageView?.image = try! UIImage.init(data: Data.init(contentsOf:)
            }
            header?.imageClickBtn.rx.tap.asObservable().subscribe(onNext: {
                //                self.changeHeaderImageView()
                let vc  = WFChooseBookImageController()
                if let image = self.headerImageView?.image {
                    vc.image = image
                    vc.dataSource.append(contentsOf: self.getMaindataSourceImages())
                    if vc.dataSource.count == 1{
                        let model  =  ChooseImageModel.init(image,true)
                        model.isEditImage = true
                        vc.dataSource.append(model)
                    }
                }
                
                vc.complict = {[weak self](moddel) in
                    
                    self?.headerImageView?.image = moddel.image
                    
                    if moddel.indexRow != -1{
                        //mainDataSouce[moddel.indexRow].imageName = moddel.image
                        let imagePath  = moddel.image!.saveImageToFile()
//                        mainDataSouce[moddel.indexRow].imagePath = imagePath
                        self?.headerImagePath = imagePath
                    }else{
                        let imagePath  = moddel.image!.saveImageToFile()
                        self?.headerImagePath = imagePath
                    }
                    
                    self?.tableView.reloadData()
                }
                let navigationController = WFNavigationController.init(rootViewController: vc)
                
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: (header?.disposeBag)!)
            
            ///还有一个标题的事件没有写
            header?.titleBtn.rx.tap.asObservable().subscribe(onNext: {
                let vc  = WFEditTitleViewController()
                vc.titleString = self.headerTitle
                vc.complict = {[weak self](title ) in
                    
                    header?.titleView.text = title
                    self?.headerTitle = title
                }
                self.navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: (header?.disposeBag)!)
            
            
            header?.clickBtn.rx.tap.asObservable().subscribe(onNext:{
                
                var frame  = self.funcChooseView.frame
                let funcVY  = self.headerHeight + CGFloat(section) * 150.0 + 45.0 - 50
                
                if funcVY == frame.origin.y {
                    self.hideFuncView(!self.funcChooseView.isHidden)
                    
                }else{
                    
                    frame.origin.y = funcVY
                    self.funcChooseView.frame = frame
                    self.hideFuncView(false)
                }
                self.selectIndexPath = IndexPath.init(row: 0, section: 0)
                tableView.bringSubview(toFront: self.funcChooseView)
            }).disposed(by: header?.disposeBag ?? DisposeBag())
            
            
            
            return header
        }else{
            return nil
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return nil
//        let  footerView  = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WFFooterView") as? WFFooterView
//        if section == 0 {
//
//            footerView?.clickBtn.rx.tap.asObservable().subscribe(onNext:{
//
//                var frame  = self.funcChooseView.frame
//                let funcVY  = self.headerHeight + CGFloat(section) * 150.0 + 45.0
//
//                if funcVY == frame.origin.y {
//                    self.hideFuncView(!self.funcChooseView.isHidden)
//
//                }else{
//
//                    frame.origin.y = funcVY
//                    self.funcChooseView.frame = frame
//                    self.hideFuncView(false)
//                }
//
//                tableView.bringSubview(toFront: self.funcChooseView)
//            }).disposed(by: footerView?.disposeBag ?? DisposeBag())
//
//            return footerView
//        }else{
//            return nil
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        hideFuncView(true)
    }
    
    ///隐藏显示选择视图
    func hideFuncView(_ isHidden : Bool) {
        
        if isHidden == true{
            
            UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                
                self.funcChooseView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
                
            }) { (isSuccess) in
                self.funcChooseView.isHidden = isHidden
                self.funcChooseView.layer.transform = CATransform3DMakeScale(1, 1, 1)
            }
        }else{
            
            self.funcChooseView.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
            self.funcChooseView.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self.funcChooseView.layer.transform = CATransform3DMakeScale(1, 1, 1)
                
            }) { (isTrue ) in
                UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
                    self.funcChooseView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                    
                }) { (isSuccess) in
                    self.funcChooseView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                }
            }
        }
        
        
    }
    
    func dataSource(inTableView tableView: WFMoveCellTableView) -> [AnyObject] {
        return mainDataSouce
    }
    
}

//设置tableView/
extension WFNewCaseViewController: MoveCellDelegate ,MoveCellDataSource{
    func returnDataSource(_ array: [AnyObject]) {
        mainDataSouce = array as! [CaseDetailModel]
    }
    
    
    func tableView(_ tableView: WFMoveCellTableView, customizeStartMovingAnimationWithimage image: UIImageView, fingerPoint point: CGPoint) {
        UIView.animate(withDuration: 0.25) {
            image.center = CGPoint.init(x: image.center.x, y: point.y)
        }
    }
    
    
    func setTableView() {
        
        self.tableView.register(WFCaseContentCell.self, forCellReuseIdentifier: WFCaseContentCell().identfy)
        
        self.tableView.register(WFFooterView.self , forHeaderFooterViewReuseIdentifier: "WFFooterView")
        self.tableView.register(WFCaseEditHeaderView.self , forHeaderFooterViewReuseIdentifier: "WFCaseEditHeaderView")
        tableView.delegatet = self
        tableView.dataSourcee = self
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UITableViewCell.self , forCellReuseIdentifier: "cell")
        //        tableView.isEditing = true
        tableView.bounces = false
        
        let tapGesture  = UITapGestureRecognizer.init(target: self, action: #selector(tapGesturee))
        
        tableView.addGestureRecognizer(tapGesture)
        if #available(iOS 11, *){
            self.tableView.contentInsetAdjustmentBehavior = .never
        }else{
            
        }
        self.automaticallyAdjustsScrollViewInsets = false
        self.tableView.rowHeight = 100
        self.tableView.sectionHeaderHeight = 0
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 70, 0)
        self.tableView.separatorColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.tableView.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        self.tableView.estimatedRowHeight = 0
        self.tableView.estimatedSectionFooterHeight = 0
        self.tableView.estimatedSectionHeaderHeight = 0
        self.tableView.contentOffset = CGPoint.init(x: 0, y: 0)
        
        self.tableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalToSuperview().offset(-navigation_height)
        }
        
    }
    
    
    
}

///更换头部视图图片
extension WFNewCaseViewController : UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate{
    
    func changeHeaderImageView() {
        let alertController  = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1  = UIAlertAction(title: "拍照", style: .default) { (_) in
            ///在数组里面添加数据 然后更新数据
            self.uploadImageWithCameare()
        }
        
        alertController.addAction(action1)
        
        let action2  = UIAlertAction(title: "从相册选择", style: .default) { (_) in
            self.chooseImageType = .boolFileimage
            self.chooseImageView()
        }
        alertController.addAction(action2)
        
        let action3  = UIAlertAction(title: "取消", style:  .cancel, handler: nil)
        alertController.addAction(action3)
        
        action3.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action2.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action1.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        
        present(alertController, animated: true, completion: nil)
    }
    
    ///从相册选择上传头像
    fileprivate func chooseImageView(_ maxCount : Int = 1 , _ isHasImage : Bool = false){
        hideFuncView(true)
        
        if isHasImage == true {
            let vc = WFEditImageViewController()
            let nav  = UINavigationController.init(rootViewController: vc)
            
            vc.image = mainDataSouce[(self.selectIndexPath?.row)!].imageName
            vc.blockCompliction = {[weak self](image) in
                mainDataSouce[(self?.selectIndexPath?.row)!].imageName = image
                
                var imagePath  = ""
                if let currentImage  = image{
                    imagePath = currentImage.saveImageToFile()
                    mainDataSouce[(self?.selectIndexPath?.row)!].imagePath = imagePath
                }
                
                
                self?.tableView.reloadData()
                
                //                if  self?.isFirstupLoadImage == 1 {
                //                    self?.headerImageView?.image = image
                //                    mainDataSouce[(self?.selectIndexPath?.row)!].isHeadImage = true
                //                }
                print("ImagePath : \(imagePath)")
                if mainDataSouce[(self?.selectIndexPath?.row)!].isHeadImage {
                    self?.headerImageView?.image = image
                    self?.headerImagePath = imagePath
                }
            }
            
            present(nav, animated: true, completion: nil)
            return
        }
        
        
        let vc = TZImagePickerController(maxImagesCount: maxCount , delegate: self )
        vc?.videoMaximumDuration = 300
        vc?.allowPickingImage = !allowPickerVideo
        vc?.allowPickingVideo = allowPickerVideo
        
        vc?.didFinishPickingPhotosHandle = {[weak self](_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
            
            switch (self?.chooseImageType)! {
            case .addNewimage:
                var rowNumber  = (self?.selectIndexPath?.row)!
                
                var number = 1
                for item in phots!{
                    let model  = CaseDetailModel.init(nil, "")
                    number += 1
                    let imagePath = item.saveImageToFile("\(number)")
                    model.imagePath = imagePath
                    
                    if  self?.isFirstupLoadImage == 0 {
                        self?.headerImageView?.image = phots?[0]
                        model.isHeadImage  = true
                        self?.headerImagePath = imagePath
                    }
                    
                    model.imageName = item
                    model.fileType  = .image
                    
                    
                    mainDataSouce.insert(model, at:rowNumber)
                    rowNumber += 1
                }
                
                self?.tableView.reloadData()
                break
                
            case .boolFileimage:
                self?.headerImageView?.image = phots?[0]
                break
                
            case .headimage:
                ///pass
                var  imagePath  = ""
                
                if  self?.isFirstupLoadImage == 0 {
                    self?.headerImageView?.image = phots?[0]
                    mainDataSouce[(self?.selectIndexPath?.row)!].isHeadImage  = true
                    imagePath = phots?[0].saveImageToFile() ?? ""
                    self?.headerImagePath = imagePath
                }else{
                    imagePath = phots?[0].saveImageToFile() ?? ""
                }
                print("imagePath")
                print(imagePath)
                mainDataSouce[(self?.selectIndexPath?.row)!].imagePath  = imagePath
                mainDataSouce[(self?.selectIndexPath?.row)!].imageName  = phots?[0]
                mainDataSouce[(self?.selectIndexPath?.row)!].fileType  = .image
                self?.tableView.reloadData()
                break
                
            case .video:
                let rowNumber  = (self?.selectIndexPath?.row)!
                let model  = CaseDetailModel.init(nil, "")
                model.imageName =  phots![0]
                model.fileType  = .video
                mainDataSouce.insert(model, at:rowNumber)
                self?.tableView.reloadData()
                break
                
            }
        }
        
        present(vc!, animated: true, completion: nil)
        
    }
    
    
    
    ///通过拍照上传图片
    private func uploadImageWithCameare() {
        
        let vc  = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraCaptureMode = .photo
        
        vc.allowsEditing = true
        vc.delegate = self
        
        present(vc, animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //储存照片到本地相册
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        
        headerImageView?.image = pickedImage
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: TZImagePickerController!, didFinishPickingVideo coverImage: UIImage!, sourceAssets asset: Any!) {
        
        let rowNumber  = (self.selectIndexPath?.row)!
        let model  = CaseDetailModel.init(nil, "")
        model.imageName =  coverImage
        
        let imagePath  = coverImage.saveImageToFile()
        model.imagePath = imagePath
        
        model.fileType  = .video
        
        var number  = 1
        
        SVProgressHUD.showInfo(withStatus: "正在载入中")
        TZImageManager.default().getVideoOutputPath(withAsset: asset, presetName: AVAssetExportPreset640x480, success: { (path) in
            SVProgressHUD.dismiss()
            model.videoPath = path!
            
            let vc  = WFEditVideoController()
            vc.videoPath = model.videoPath//mainDataSouce[indexPath.row].videoPath
            vc.complict = {(path ) in
//                mainDataSouce[rowNumber].videoPath = path

                if FileManager.default.fileExists(atPath: path) == true{
                
                    model.videoPath = path
                    if number == 1{
                       mainDataSouce.insert(model, at:rowNumber)
                       number = number - 1
                    }
                    self.tableView.reloadData()
                }else{
                    SVProgressHUD.showInfo(withStatus: "视频上传视频失败，请重新上传")
                }
            }
            self.present(vc , animated: true, completion: nil)
            
            
        }) { (info, error) in
            
        }
        
    }
}

///选择编辑照片
extension WFNewCaseViewController{
    
    func chooseImage(_ isHasImage : Bool , _ indexPath : IndexPath) {
        
        imageEditV().sender = self
        hideFuncView(true)
        if isHasImage {
            
            isHiddenVideo = false
            imageEditV().previewSelectedPhotos([mainDataSouce[indexPath.row].imageName!], assets: [self.lastSelectAssets[indexPath.row]], index: 0 , isOriginal: false)
        }else{
            self.selectIndexPath = indexPath
            imageEditV().showPhotoLibrary()
        }
        
    }
    
}


extension UIImage{
    
    func getFilePath() -> String {
        let path = NSTemporaryDirectory()//NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let filePath = (path) + "/\(getTimeStamp())record.png"
        return filePath
    }
    
    fileprivate  func getTimeStamp() -> String {
        
        let dataFommter = DateFormatter()
        dataFommter.dateFormat = "yyyyMMddhhmmss"
        let date  = Date()
        return dataFommter.string(from: date)
    }
    
    func saveImageToFile(_ pathN : String = "") -> String {
        
        var path  = getFilePath()
        path = path.components(separatedBy: ".").joined(separator: "\(pathN).")
        
        
        guard let data  = sd_imageData()//UIImagePNGRepresentation(self)
            else {
                return ""
        }
        print("data.count")
        print(data.count)
        let filePath = URL.init(fileURLWithPath: path)
        var error = NSError()
        
        do {
            try data.write(to: filePath)
            
        } catch let err as NSError {
            
            error = err
        }
        
        return path
    }
}

/**/
//var editeCellKey = "editeCellKey"
//var snapImageViewKey = "snapImageViewKey"
//var dataSouceArrayKey = "dataSouceArrayKey"
//var complictionBlockKey = "complictionBlocKey"
//var indexPathKey = "indexPathKey"
//var autoScrollDirectionKey = "autoScrollDirectionKey"
//var autoScrollTimerKey = "autoScrollTimerKey"
//
//var indexNumber : Int = 0
//extension UITableView{
//
//    var editeCell : UITableViewCell? {
//        set{
//            objc_setAssociatedObject(self, &editeCellKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &editeCellKey) as? UITableViewCell
//        }
//    }
//
//    var snapImageView : UIView? {
//        set{
//            objc_setAssociatedObject(self, &snapImageViewKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &snapImageViewKey) as? UIView
//        }
//    }
//
//    var dataSouceArray : [CaseDetailModel]? {
//        set{
//            objc_setAssociatedObject(self, &dataSouceArrayKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &dataSouceArrayKey) as?  [CaseDetailModel]
//        }
//    }
//
//    var indexPath : IndexPath {
//        set{
//            objc_setAssociatedObject(self, &indexPathKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &indexPathKey) as! IndexPath
//        }
//    }
//
//    var complictionBlock : (Array<CaseDetailModel>)->() {
//        set{
//            objc_setAssociatedObject(self, &complictionBlockKey, newValue, .OBJC_ASSOCIATION_COPY)
//        }
//        get{
//            return objc_getAssociatedObject(self, &complictionBlockKey) as!  (Array<CaseDetailModel>)->()
//        }
//    }
//
//    var autoScrollDirection : Int {
//        set{
//            objc_setAssociatedObject(self, &autoScrollDirectionKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &autoScrollDirectionKey) as!  Int
//        }
//    }
//
//    var autoScrollTimer : CADisplayLink? {
//        set{
//            objc_setAssociatedObject(self, &autoScrollTimerKey, newValue, .OBJC_ASSOCIATION_RETAIN)
//        }
//        get{
//            return objc_getAssociatedObject(self, &autoScrollTimerKey) as?  CADisplayLink
//        }
//    }
//
//
//    func setDataArray(_ dataSource : [CaseDetailModel] , _ complict : @escaping (([CaseDetailModel])->())){
//
//        dataSouceArray = [CaseDetailModel]()
//
//        for item  in dataSource {
//            dataSouceArray?.append(item)
//        }
//
//        complictionBlock = complict
//        addLongGesture()
//    }
//
//
//    //添加长按手势
//    private func addLongGesture() {
//
//        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPress(longP:)))
//        addGestureRecognizer(longPress)
//
//    }
//
//    ///长按手势事件
//    func longPress(longP : UILongPressGestureRecognizer) {
//
//        ///根据 手势的 开始 移动结束 手势来实现
//        switch longP.state {
//        case .began:
//
//            // why
//            reloadData()
//            hiddenViewFor(true)
//
//
//
//            let point  = longP.location(ofTouch: 0 , in:self )
//
//            guard let pointIndex = indexPathForRow(at: point)
//            else{
//                return
//            }
//            print("Point And offset")
//            print(point)
//            print(self.contentOffset)
//            print("Begin index Pa : \(pointIndex) ")
//            indexNumber = 0
//            break
//
//        case .changed:
//
//            let point  = longP.location(ofTouch: 0, in: longP.view)
//            var center = self.snapImageView?.center
//            center?.y = point.y
//            self.snapImageView?.center = center ?? center!
//
//            if checkIfSnapshotMeetsEdge() != 0{
//                startCreatTimer()
//            }else{
//                stopAutoScrollTimer()
//            }
//
//            ///检测 异常区域
//            guard let indexPath  = indexPathForRow(at: point)  else {
//                return
//            }
//
//            if indexNumber == 0 {
//                self.indexPath = indexPath
//                DispatchQueue.main.async {
//                    self.editeCell = self.cellForRow(at: self.indexPath)
//                    self.snapImageView  = UIImageView.init(image: self.editeCell?.xf_snapImage)//self.editeCell?.snapshotView(afterScreenUpdates: false) //
//                    self.snapImageView?.frame = self.editeCell?.frame ?? (self.snapImageView?.frame)!
//
//                    self.addSubview(self.snapImageView!)
//                    self.editeCell?.isHidden = true
//
//                    UIView.animate(withDuration: 0.1, animations: {
//                        self.snapImageView?.transform = CGAffineTransform(scaleX: 1.05, y: 1.07)
//                        self.snapImageView?.alpha = 0.8
//                    })
//                }
//
//                indexNumber += 1
//            }
//
////            if self.indexPath == indexPath{
////                return
////            }
//
////            print(point)
//            print(" Move self.indexP : \(self.indexPath) index Pa : \(indexPath)")
//               /// 更新数据源
//            updateDataWithIndexPath(indexPath)
////            moveRow(at: self.indexPath, to: indexPath)
//            moveSection(self.indexPath.section, toSection: indexPath.section )
//
//            self.indexPath = indexPath
//            break
//
//        case .ended:
//
//            indexNumber = 0
//            hiddenViewFor(false)
//
//            DispatchQueue.main.async {
//                self.editeCell = self.cellForRow(at: self.indexPath)
//                UIView.animate(withDuration: 0.2, animations: {
//                    self.snapImageView?.center = self.editeCell?.center ?? CGPoint.zero
//                    self.snapImageView?.transform = CGAffineTransform.identity
//                    self.snapImageView?.alpha = 1.0
//                }, completion: { (isTrue) in
//                    self.editeCell?.isHidden = false
//                    self.snapImageView?.removeFromSuperview()
//                    ///停止滚动器
//                    self.stopAutoScrollTimer()
//                })
//            }
//
//            break
//        default:break
//        }
//
//    }
//
//    private func updateDataWithIndexPath(_ moveIndexPath : IndexPath) {
//
//        if self.indexPath.section == moveIndexPath.section {
//
//            return
//        }else{
//            (dataSouceArray![self.indexPath.section],dataSouceArray![moveIndexPath.section]) =  (dataSouceArray![moveIndexPath.section],dataSouceArray![self.indexPath.section])
//
//        }
//
//        ///把生成的数组传递出去
//        complictionBlock(dataSouceArray!)
//        }
//
//    ///创建定时器
//     private func startCreatTimer() {
//        if self.autoScrollTimer == nil {
//            self.autoScrollTimer = CADisplayLink.init(target: self, selector: #selector(startScrow))
//            self.autoScrollTimer?.add(to: RunLoop.main, forMode: .commonModes)
//        }
//    }
//
//    ///停止计时器
//    @objc func stopAutoScrollTimer() {
//
//        if (self.autoScrollTimer != nil) {
//            self.autoScrollTimer?.invalidate()
//            self.autoScrollTimer = nil
//        }
//    }
//
//    ////开始滚动
//    @objc func startScrow() {
//
//        let pixelSpeed : CGFloat = 4
//        if self.autoScrollDirection == 1 {//top
//            if self.contentOffset.y > 0{
//                print("\(self.contentOffset)   frame : \(frame) contentsize : \(contentSize) ")
//                setContentOffset(CGPoint.init(x: 0, y: self.contentOffset.y - pixelSpeed), animated: true)
//                self.snapImageView?.center = CGPoint.init(x: self.snapImageView?.center.x ?? 0 , y:self.snapImageView?.center.y ?? 0 - pixelSpeed)
//            }
//            print("开始往上滚")
//
//        }else if (self.autoScrollDirection == 2 ){
//
//            if self.bounds.size.height + self.contentOffset.y - 70 < self.contentSize.height{
//
//                var offsetPoint  = self.contentOffset
//                 offsetPoint.y += pixelSpeed
//                self.contentOffset = offsetPoint
//
//                //setContentOffset(CGPoint.init(x: 0, y: self.contentOffset.y + pixelSpeed), animated: true)
//                print("移动后的contentOffset\(contentOffset.y)")
//                self.snapImageView?.center = CGPoint.init(x: self.snapImageView?.center.x ?? 0 , y:self.snapImageView?.center.y ?? 0 + pixelSpeed)
//            }
//            print("\(self.contentOffset)   frame : \(frame) contentsize : \(contentSize) ")
//            print("开始往下滚")
//        }else{
//            print("\(self.contentOffset)   frame : \(frame) contentsize : \(contentSize) ")
//            print("不让滚动 ")
//            stopAutoScrollTimer()
//        }
//
//        if let pcenter = self.snapImageView?.center ,
//           let exchangePath  = indexPathForRow(at:pcenter){
//            updateDataWithIndexPath(exchangePath)
//            moveSection(self.indexPath.section, toSection: exchangePath.section)
//            self.indexPath = exchangePath
//        }
//
//
//    }
//
//
//    ///检查视图是否超出边界
//    private func checkIfSnapshotMeetsEdge() -> Int {
//        let minY  = (self.snapImageView?.frame ?? CGRect.zero).minY
//        let maxY  = (self.snapImageView?.frame ?? CGRect.zero).maxY
//
//        if minY < self.contentOffset.y {
//            self.autoScrollDirection = 1 //top
//            print(self.contentOffset.y)
//            print("上面的")
//            return self.autoScrollDirection
//        }
//
//        if maxY > self.bounds.size.height + self.contentOffset.y {
//            self.autoScrollDirection = 2 //bottom
//            print(self.contentOffset.y)
//            print("下面的")
//            return self.autoScrollDirection
//        }
//        print(self.contentOffset.y)
//        print("最后的")
//        return 0
//    }
//
//
//    ///控制隐藏footer视图
//    private func  hiddenViewFor(_ isHidden : Bool ) {
//        for sview in subviews {
//            if sview.isMember(of: WFFooterView.self){
//                let s = sview as! WFFooterView
//
//                UIView.animate(withDuration: 0.2) {
//                    s.clickBtn.isHidden = isHidden
//                    s.clickBtn.alpha = isHidden ? 0 : 1
//                }
//            }
//        }
//    }
//}




