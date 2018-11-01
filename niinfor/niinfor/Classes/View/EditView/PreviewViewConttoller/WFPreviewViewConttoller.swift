//
//  WFPreviewViewConttoller.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/7.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD
import RealmSwift
class WFPreviewViewConttoller: BaseViewController {

    var dataSource : [CaseDetailModel] = []
    var headerTitle: String = ""
    var headerImagePath: String = ""
    var articleId = ""
    var articleType = "0" //0代表病例讨论，1代表随笔
    var permisson  = "PU"{
        didSet{
            privateBtn.isSelected  = permisson == "PU"
        }
    }
    var subSpecialModel = [WFMPSubSpecialty]()
    //以上是传入进来的参数
    
    fileprivate let realm = try! Realm()
    fileprivate var webView = WKWebView()
    
    let privateBtn  = UIButton.init()
    let subspecialtyBtn  = UIButton.init()
    
    var keyID = 0 ///数据库主键
    var chooseSubView : WFSubspecialtyView = WFSubspecialtyView.init(frame: CGRect.zero)
    
    fileprivate var localFiles:[String] = []
    fileprivate var uploadResults = [String:String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    private func initUI() {
        webView.frame = CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height-navigation_height - 50)
        //        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.backgroundColor = .white
        
        webView.scrollView.isScrollEnabled = true
        webView.scrollView.bounces = false
        //        webView.scrollView.delegate = self
        webView.scrollView.clipsToBounds = false
        
        self.view.insertSubview(webView, belowSubview: self.navBar)//addSubview(webView)
        
        if let filePath = Bundle.main.path(forResource: "tmp1", ofType: "html", inDirectory:"") {
            do {
                var html = try String.init(contentsOfFile: filePath)
                html = html.replacingOccurrences(of: "___JSON__DATA___", with: data2Json())
                webView.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
            } catch {
                print("Unexpected error: \(error).")
            }
            
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadMpSubspecialty()
    }
    
    func formatResourceUrl(_ url:String) ->String {
        if url.starts(with: "http") {
            return url
        }
        return "file://" + url
    }
    
    func data2Json() -> String {
        let arr = NSMutableDictionary()//Dictionary<String, Any>()
        arr["name"] = NetworkerManager.shared.userCount.realName ?? ""
        arr["job"] = NetworkerManager.shared.userCount.title ?? ""
        arr["title"] = headerTitle
        arr["image"] = NetworkerManager.shared.userCount.avatarAddress ?? ""
        let items = NSMutableArray();
        arr["html"] = items
        for model in dataSource {
            let item = NSMutableDictionary()
            switch model.fileType {
            case .image:
                item["type"] = "img"
                item["text"] = model.htmlString
                item["src"] = formatResourceUrl(model.imagePath)
                break
            case .audio:
                item["type"] = "audio"
                item["text"] = model.htmlString
                item["src"] = formatResourceUrl(model.videoPath)
                break
            case .video:
                item["type"] = "video"
                item["text"] = model.htmlString
                item["src"] = formatResourceUrl(model.videoPath)
                item["poster"] = formatResourceUrl(model.imagePath)
                break
            default:
                item["type"] = "text"
                item["text"] = model.htmlString
                break
            }
            items.add(item)
        }
        
        let data : NSData = try! JSONSerialization.data(withJSONObject: arr, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        return JSONString! as String
    }
}

extension WFPreviewViewConttoller {
   
   @objc func privateBtnClick(_ btn : UIButton)  {
              btn.isSelected = !btn.isSelected
    }
   @objc func subspecialtyBtnClick(_ btn : UIButton)  {
              btn.isSelected = true
    
              if chooseSubView.dataSource.count == 0 {
                 loadMpSubspecialty()
              }else{
                 chooseSubView.isHidden = false
    }
    }
}

extension WFPreviewViewConttoller {
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        
        setNavigationBtn()
        title = "预览"
        setBottomBtn()
        uploadResults.removeAll()
        
        let userdefault = UserDefaults.standard
        
        if articleType == "0" {
        
        let isFirstLook = userdefault.value(forKey: user_subspicl_isFirstLook)

        if isFirstLook == nil  {
            let v = WFFirstLookView()
            self.view.addSubview(v)
            v.setSubspical()
            v.snp.makeConstraints { (maker ) in
                maker.left.right.bottom.top.equalToSuperview()
            }
        }
        userdefault.set("sjfaljfl", forKey: user_subspicl_isFirstLook)
        }else{
                
                let isFirstLook = userdefault.value(forKey: user_essey_isFirstLook)
                
                if isFirstLook == nil  {
                    let v = WFFirstLookView()
                    self.view.addSubview(v)
                    v.setEssay()
                    v.snp.makeConstraints { (maker ) in
                        maker.left.right.bottom.top.equalToSuperview()
                    }
                }
        userdefault.set("sjfaljfl", forKey: user_essey_isFirstLook)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        let videoPauseJSStr = "document.documentElement.getElementsByTagName(\"video\")[0].pause()"
//        self.webView.evaluateJavaScript(videoPauseJSStr, completionHandler: nil)
          self.webView.reload()
    }
    
    fileprivate func setBottomBtn() {
    
        privateBtn.backgroundColor = UIColor.white
        privateBtn.setImage(#imageLiteral(resourceName: "lock"), for: .normal)
        privateBtn.setImage(#imageLiteral(resourceName: "公开"), for: .selected)
        privateBtn.addTarget(self, action: #selector(privateBtnClick(_:)), for: .touchUpInside)
        privateBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 仅自己可见",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)]),
                                     for: .normal)
        privateBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 公开",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2509803922, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                      for: .selected)
        privateBtn.isSelected = true
        view.addSubview(privateBtn)
        
        subspecialtyBtn.backgroundColor = UIColor.white
        subspecialtyBtn.setImage(#imageLiteral(resourceName: "专业"), for: .normal)
        subspecialtyBtn.setImage(#imageLiteral(resourceName: "release_zhuanye2"), for: .selected)
        subspecialtyBtn.addTarget(self, action: #selector(subspecialtyBtnClick(_:)), for: .touchUpInside)
        subspecialtyBtn.titleLabel?.lineBreakMode = .byTruncatingTail
        subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 分类",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]),
                                      for: .normal)
        subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
            string: " 分类",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName :#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                      for: .selected)

        view.addSubview(subspecialtyBtn)
        
        let privateWidth = articleType == "0" ? Screen_width / 2 :  Screen_width
        subspecialtyBtn.isHidden = articleType != "0"
        
        privateBtn.snp.makeConstraints { (maker ) in
            maker.left.bottom.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(privateWidth)
        }
        subspecialtyBtn.snp.makeConstraints { (maker ) in
            maker.right.bottom.equalToSuperview()
            maker.height.equalTo(50)
            maker.width.equalTo(privateWidth)
        }
        
        chooseSubView.complict = {[weak self](model) in
            self?.subSpecialModel = model
            
            if model.count == 0 {
                self?.subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
                    string: " 分类",
                    attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                        UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                   for: .selected)
                self?.subspecialtyBtn.isSelected = false
                return
            }
            
            var btnString = ""
            
            for (index,item ) in model.enumerated() {
                if index == model.count - 1{
                    btnString = btnString + item.name
                }else{
                    btnString = btnString + item.name + ","
                }
            }
            
            self?.subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
                string: " \(btnString)",
                attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                    UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                               for: .selected)
        }
        view.addSubview(chooseSubView)
        view.bringSubview(toFront: chooseSubView)
        chooseSubView.isHidden = true
        chooseSubView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
    }
    
    fileprivate func setNavigationBtn() {
        
        var btnright = UIButton.init()
        btnright = UIButton.cz_textButton("", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        btnright.setImage(#imageLiteral(resourceName: "发布"), for: .normal)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        
    }
    func toUploadJson() -> String {
        let items = NSMutableArray();
        var order = 0;
        for model in dataSource {
            let item = NSMutableDictionary()
            item["isCover"] = false
            switch model.fileType {
            case .image:
                item["id"] = 0
                item["type"] = "img"
                item["text"] = model.htmlString
                item["resource"] = model.imagePath
                item["image"] = ""
                item["isCover"] = model.isHeadImage
                item["order"] = order
                break
            case .audio:
                item["id"] = 0
                item["type"] = "sound"
                item["text"] = model.htmlString
                item["resource"] = model.videoPath
                item["image"] = ""
                item["order"] = order
                break
            case .video:
                item["id"] = 0
                item["type"] = "video"
                item["text"] = model.htmlString
                item["resource"] = model.videoPath
                item["image"] = model.imagePath
                item["order"] = order
                break
            default:
                item["id"] = 0
                item["type"] = "txt"
                item["text"] = model.htmlString
                item["resource"] = ""
                item["image"] = ""
                item["order"] = order
                break
            }
            items.add(item)
            order = order+1
        }
        
        let data : NSData = try! JSONSerialization.data(withJSONObject: items, options: []) as NSData
        let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
        print(JSONString)
        return JSONString! as String
    }
    
    func filesNeedUpload() -> [String] {
        var files = [String]()
        for model in dataSource {
            switch model.fileType {
            case .image:
                if !model.imagePath.starts(with: "http") {
                    files.append(model.imagePath)
                }
                break
            case .audio:
                if !model.videoPath.starts(with: "http") {
                    files.append(model.videoPath)
                }
                break
            case .video:
                if !model.videoPath.starts(with: "http") {
                    files.append(model.videoPath)
                }
                if !model.imagePath.starts(with: "http") {
                    files.append(model.imagePath)
                }
                break
            default:
                break
            }
        }
        return files
    }
    func replacePathWithUrl() {
        let urls = uploadResults
        for model in dataSource {
            switch model.fileType {
            case .image:
                if !model.imagePath.starts(with: "http") {
                    if let newurl = urls[model.imagePath] {
                        model.imagePath = newurl
                    }
                }
                break
            case .audio:
                if !model.videoPath.starts(with: "http") {
                    if let newurl = urls[model.videoPath] {
                        model.videoPath = newurl
                    }
                }
                break
            case .video:
                if !model.videoPath.starts(with: "http") {
                    if let newurl = urls[model.videoPath] {
                        model.videoPath = newurl
                    }
                }
                if !model.imagePath.starts(with: "http") {
                    if let newurl = urls[model.imagePath] {
                        model.imagePath = newurl
                    }
                }
                break
            default:
                break
            }
        }
    }
    private func uploadResouces() {
//        let filepaths = filesNeedUpload()
        if (localFiles.count > 0) {
            let filepath:String = localFiles.last!
            NetworkerManager.shared.uploadMPFile(filepath) {
                (isSuccess, fileurl) in
                if isSuccess == true {
                    self.uploadResults[filepath] = fileurl
                    let _ = self.localFiles.popLast()
                    if self.localFiles.count > 0 {
                        self.uploadResouces()
                    }
                    else {
                        self.replacePathWithUrl()
                        //上传内容
                        self.uploadArticle()
                    }
                }
            }
        }
    }
    
    private func uploadHeaderImage() {
        if headerImagePath.isEmpty {
            uploadFilesAndArticle()
            return
        }
        if headerImagePath.starts(with: "http") {
            uploadFilesAndArticle()
            return
        }
        NetworkerManager.shared.uploadMPFile(headerImagePath) {
            (isSuccess, fileurl) in
            if isSuccess == true {
                self.headerImagePath = fileurl
                self.uploadFilesAndArticle()
            }
        }
    }
    private func uploadFilesAndArticle() {
        localFiles = filesNeedUpload()
        if (localFiles.count > 0) {
            //上传资源，成功后自动调用uploadArticle()
            uploadResouces()
        }
        else {
            uploadArticle()
        }
    }
    @objc func rightBtnclick(){
        //递归调用去上传，封面图->递归 资源 ->文章
        uploadHeaderImage()
    }
    private func uploadArticle() {
        var params = [String:String]()
        params["userid"] = NetworkerManager.shared.userCount.id
        params["type"] = articleType //文章类型，其中0代表病例讨论，1代表随笔
        params["title"] = headerTitle //文章标题
        params["cover"] = headerImagePath //封面图地址（绝对路径URL，可为空）
        params["content"] = toUploadJson() //文章内容, json数据
        params["permission"] = privateBtn.isSelected ? "PU" : "PR" //阅读权限，其中PU代表公开，SH代表不公开，仅被分享的人可见，PA代表加密，凭密码访问，PR代表私密，仅自己可见
        params["allowComment"] = "T" //允许评论，其中T代表允许，F代表不允许
        
        
        var subspecialtyIdsString  = ""
        if subSpecialModel.count == 0 && articleType == "0" {
            SVProgressHUD.showInfo(withStatus: "请选择分类")
            return
        }
        
        for (index,item)  in subSpecialModel.enumerated() {
            index == 0 ? (subspecialtyIdsString += item.id) : (subspecialtyIdsString += ",\(item.id)")
        }
        
        if (params["type"] == "0") {
            params["subspecialtyIds"] = subspecialtyIdsString//亚专业ID,多个ID用英文逗号“,”分隔
        }
        if articleId.isEmpty {
            NetworkerManager.shared.mpSaveArticle(params as [String : AnyObject]) {
                (isSuccess, json) in
                if isSuccess == true {
//                    print(json)
                    
                    //发布成功
                 let vc = WFPublishSuccessController()
                 vc.model.articleUrl = Photo_Path + (json["articleUrl"] as? String ?? "")
                 vc.model.title = json["title"] as? String ?? ""
                 vc.model.cover = json["cover"] as? String ?? ""
                 self.navigationController?.pushViewController(vc , animated: true)
                    
                    self.realm.beginWrite()
                    
                    guard  let model  = self.realm.object(ofType: MainCaseStoreModel.self, forPrimaryKey:self.keyID) else{
                        try? self.realm.commitWrite()
                        return
                    }
                    self.realm.delete(model)
                    try? self.realm.commitWrite()

                    
                }else{
                    SVProgressHUD.showInfo(withStatus: "已存为草稿")
                }
            }
        }
        else {
            params["articleId"] = articleId
            NetworkerManager.shared.mpUpdateArticle(params as [String : AnyObject]) {
                (isSuccess, json) in
                if isSuccess == true {
                    //修改成功
                    let vc = WFPublishSuccessController()
                    self.navigationController?.pushViewController(vc , animated: true)
                }
            }
        }
        
    }
    
    //加载亚专业
    fileprivate func loadMpSubspecialty () {
        NetworkerManager.shared.getMpSubspecialty{ (isSuccess, json) in
            if isSuccess == true {

                self.chooseSubView.dataSource = json
                var arr = [Int]()
                var btnString = ""
                for (i, item) in json.enumerated() {
                    for spec in self.subSpecialModel {
                        if spec.id == item.id {
                            btnString = btnString + spec.name + ","
                            arr.append(i)
                            break
                        }
                    }
                }
                
                if !arr.isEmpty{
                    self.subspecialtyBtn.isSelected = true
                    self.subspecialtyBtn.setAttributedTitle(NSMutableAttributedString(
                        string: " \((btnString as NSString).substring(to: btnString.count-1))",
                        attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                            UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                            for: .selected)
                }

                self.chooseSubView.selectArray = arr
                self.chooseSubView.isHidden = true
            }
            
        }
    }
}
