
//
//  WFDownloadView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
import RealmSwift

class WFDownloadView: UIView {

    let realm  = try! Realm()
    
    
    enum ScrolDirction {
        case top
        case bottom
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate var selectVideoArray = ["流畅","标清","高清"]
    
    fileprivate var scrolNum : CGFloat = 10000//上次选择的按钮
    
    fileprivate var lastSelectNumber = 0//上次选择的按钮
    
    fileprivate var scrolDirction : ScrolDirction    = .top
    
    var topView                      = UIView.init()
    fileprivate var topLabelView     = UILabel.init()
    fileprivate var topBtnView       = UIButton.init()
                var topDeleteBtnView = UIButton.init()
    fileprivate var deleteImageView  = UIImageView.init()
    fileprivate var lineView         = UIImageView.init()
    fileprivate var mainTableView    = UITableView.init(frame: CGRect.zero, style: .plain)

    fileprivate var blackImageV      = UIImageView.init()
    fileprivate var selectBacV       = UIView.init()
    fileprivate var selectScrol      = UIPickerView.init()
    
    fileprivate var btnlineView      = UIImageView.init()
     var cacheBtnView                = UIButton.init()
     var cacheManagerBtnView         = UIButton.init()
    
    fileprivate var bottomView       = UIView.init()
    fileprivate var sapceView        = UILabel.init()
    fileprivate var sapceSizeView    = UILabel.init()
    
    var isSaveClass      = false
    var saveModel : MainClassVideoStoreModel?
    var className = ""
    var classid = ""
    var classimage = ""
    
    
    var videoQuality : AliyunVodPlayerVideoQuality = AliyunVodPlayerVideoQuality(rawValue: UInt(UserDefaults.standard.value(forKey: user_video_qulity_key) as? Int ?? 2))!{
        didSet{
            getCourseVideoInfos(classid, Int(videoQuality.rawValue))
            UserDefaults.standard.set(videoQuality.rawValue, forKey: user_video_qulity_key)
        }
    }
    
    var videoClassListModel  : WFVideoClassModel = WFVideoClassModel(){
        didSet{
            
            if saveModel != nil  {
                for item in videoClassListModel.videoList{
                    item.isSelectDownload = false
                    for model in (saveModel?.models)!{
                        if item.vid == model.vid{
                            item.isSelectDownload = true
                        }
                    }
                }
            }
            
            getCourseVideoInfos(classid, Int(videoQuality.rawValue))
            mainTableView.reloadData()
        }
    }
    
    override var isHidden: Bool{
        didSet{
            if isHidden == false {
                
                var string = ""
                if videoQuality.rawValue == 0 {
                    string = "流畅"
                } else if videoQuality.rawValue == 1 {
                    string = "标清"
                }else{
                    string = "高清"
                }
                topBtnView.setAttributedTitle(NSAttributedString.init(string: string, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16) , NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]), for: .normal)
                
                if saveModel == nil {return}
                
                let videoArr = realm.objects(MainClassVideoStoreModel.self)
                for item  in videoArr {
                    if item.classId == saveModel?.classId {
                        saveModel = item
                        let temP  = videoClassListModel
                        for ite in temP.videoList{
                            ite.isSelectDownload = false
                            for mm in item.models{
                                if mm.vid == ite.vid{
                                    ite.isSelectDownload = true
                                }
                            }
                        }
                        videoClassListModel = temP
                        return
                    }
                }
                saveModel = nil
                let temP  = videoClassListModel
                videoClassListModel = temP
            }
        }
    }
    
    
}


//private Func
extension WFDownloadView{
    
    @objc fileprivate func slideBtnCLick(_ btn : UIButton) {

        
    }
    
    @objc fileprivate func deleteBtnClick(){
          isHidden = true
    }
    
    @objc fileprivate func cacheAllVideo(_ btn : UIButton) {
        
        if saveModel?.models.count == videoClassListModel.videoList.count {
           SVProgressHUD.showInfo(withStatus: "视频已经全部缓存，请勿重复添加")
           return
        }
        if saveModel == nil {
            
            var keyCount = UserDefaults.standard.value(forKey: user_class_video_mainKey) as! Int
            keyCount += 1
            UserDefaults.standard.set(keyCount, forKey: user_class_video_mainKey)
            
            let saModel = MainClassVideoStoreModel.init()
            saModel.title = className
            saModel.classId = classid
            saModel.imagePath = classimage
            saModel.id = keyCount
            saModel.totalClass = videoClassListModel.videoList.count
            
            saveModel = saModel
            
            
            var indexRow = 0
            
            for _ in videoClassListModel.videoList {
                let indexPath = IndexPath.init(row: indexRow, section: 0)
                saveVidToDownLoad(indexPath)
                getPlayAuthWithIndexPath(indexPath)
                indexRow += 1
            }
            
            
        }else{
            
            if  saveModel?.models.count == 0 {
                var indexRow = 0
                for _ in videoClassListModel.videoList {
                    let indexPath = IndexPath.init(row: indexRow, section: 0)
                    saveVidToDownLoad(indexPath)
                    getPlayAuthWithIndexPath(indexPath)
                    indexRow += 1
                }
            }else{
                
                for(index,model) in videoClassListModel.videoList.enumerated(){
                    var  isHasModel  = false
                    
                    for item in (saveModel?.models)!{
                    if model.vid == item.vid{
                       isHasModel = true
                       break
                    }
                    }
                    if isHasModel == false{
                       saveVidToDownLoad(IndexPath.init(row: index, section: 0))
                       getPlayAuthWithIndexPath(IndexPath.init(row: index, section: 0))
                    }
                }
            }
        }
        mainTableView.reloadData()
        
        for model  in videoClassListModel.videoList {
            model.isSelectDownload = true//btn.isSelected
        }
        mainTableView.reloadData()
    }
    
    @objc fileprivate func videoBtnClick(_ btn : UIButton) {

        blackImageV.isHidden = false
        selectBacV.isHidden = false
            selectBacV.snp.updateConstraints { (maker) in
                maker.left.bottom.right.equalToSuperview()
                maker.top.equalToSuperview().offset(transHeight(400))
            }
            UIView.animate(withDuration: 0.3) {
                self.selectBacV.layoutIfNeeded()
            }
    }
    
    @objc func tapGesture() {
        blackImageV.isHidden = true
        selectBacV.snp.updateConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.top.equalToSuperview().offset(transHeight(400))
        }
        UIView.animate(withDuration: 0.3) {
            self.selectBacV.layoutIfNeeded()
        }
        selectBacV.isHidden = true
        topBtnView.setAttributedTitle(NSAttributedString.init(string: selectVideoArray[selectScrol.selectedRow(inComponent: 0)], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16) , NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]), for: .normal)
        
        videoQuality  = AliyunVodPlayerVideoQuality(rawValue: UInt(selectScrol.selectedRow(inComponent: 0)))!
        getCourseVideoInfos(classid, Int(videoQuality.rawValue))

    }
    
}

extension WFDownloadView{
    fileprivate func setUpUI() {
        addSubView()
        setConstraint()
        topLabelView.text = "视频"
        setTableView()
    }
    
    fileprivate func addSubView() {
        backgroundColor = UIColor.white
        topLabelView.font = UIFont.systemFont(ofSize: 16)
        lineView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        btnlineView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        topBtnView.addTarget(self, action: #selector(videoBtnClick(_:)), for: .touchUpInside)
        cacheBtnView.addTarget(self, action: #selector(cacheAllVideo(_:)), for: .touchUpInside)
        
        topBtnView.setAttributedTitle(NSAttributedString.init(string: "高清", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16) , NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]), for: .normal)
        
        cacheBtnView.setAttributedTitle(NSAttributedString.init(string: "缓存全部视频", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]), for: .normal)
//        cacheBtnView.setAttributedTitle(NSAttributedString.init(string: "取消缓存全部视频", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]), for: .selected)
        cacheManagerBtnView.setAttributedTitle(NSAttributedString.init(string: "缓存管理", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]), for: .normal)
        
        
        blackImageV.backgroundColor = UIColor.black
        blackImageV.alpha = 0.6
        blackImageV.isHidden = true
        blackImageV.isUserInteractionEnabled = true
        
        let tap  = UITapGestureRecognizer.init(target: self, action: #selector(tapGesture))
        
        blackImageV.addGestureRecognizer(tap)
        
        deleteImageView.image = #imageLiteral(resourceName: "删除")
        selectBacV.backgroundColor = UIColor.white
        selectScrol.backgroundColor = UIColor.white
        selectBacV.isHidden = true
        
        sapceView.text = "可用空间"
        sapceView.font = UIFont.systemFont(ofSize: 10)
        sapceView.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        sapceView.textAlignment = .right
        
        sapceSizeView.textColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        sapceSizeView.text = NSString().freeDiskSpaceInBytes()
        sapceSizeView.font = UIFont.systemFont(ofSize: 10)
        sapceSizeView.textAlignment = .left
        
//        selectScrol.isHidden = true
        selectScrol.delegate = self
        selectScrol.dataSource = self
        
        bottomView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        
        addSubview(topView)
        topView.addSubview(topLabelView)
        topView.addSubview(topBtnView)
        topView.addSubview(lineView)
        topView.addSubview(deleteImageView)
        topView.addSubview(topDeleteBtnView)
        addSubview(btnlineView)
        addSubview(mainTableView)
        addSubview(cacheBtnView)
        addSubview(cacheManagerBtnView)
        addSubview(bottomView)
        bottomView.addSubview(sapceView)
        bottomView.addSubview(sapceSizeView)
        addSubview(blackImageV)
        addSubview(selectBacV)
        selectBacV.addSubview(selectScrol)

        topView.bringSubview(toFront: topDeleteBtnView)
    
    }
    
    fileprivate func setConstraint() {

        topView.snp.makeConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(44)
        }
        topLabelView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalToSuperview().offset(15)
        }
        topBtnView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.left.equalTo(topLabelView.snp.right).offset(30)
        }
        topDeleteBtnView.snp.makeConstraints { (maker) in
            maker.top.bottom.equalToSuperview()
            maker.right.equalToSuperview().offset(-10)
            maker.width.equalTo(44)
        }
        deleteImageView.snp.makeConstraints { (maker) in
            maker.center.equalTo(topDeleteBtnView)
            maker.width.height.equalTo(12)
        }
        lineView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.width.equalTo(60)
        }
        
        blackImageV.snp.makeConstraints { (maker) in
            maker.left.bottom.right.top.equalToSuperview()
        }
        selectBacV.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.top.equalToSuperview().offset(transHeight(400))
        }
        selectScrol.snp.makeConstraints { (maker) in
            maker.left.bottom.right.top.equalToSuperview()
        }
        
        bottomView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(22)
        }
        cacheBtnView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(bottomView.snp.top)
            maker.height.equalTo(50)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        cacheManagerBtnView.snp.makeConstraints { (maker) in
            maker.bottom.top.width.height.equalTo(cacheBtnView)
            maker.right.equalToSuperview()
        }
        btnlineView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(cacheManagerBtnView.snp.top)
        }
        sapceView.snp.makeConstraints { (maker) in
            maker.left.bottom.top.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        sapceSizeView.snp.makeConstraints { (maker) in
            maker.right.bottom.top.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        mainTableView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(topView.snp.bottom)
            maker.bottom.equalTo(cacheManagerBtnView.snp.top).offset(-0.5)
        }

    }
}

extension WFDownloadView{
    ///视频列表信息 根据不同的 清晰度来切换
    fileprivate func getCourseVideoInfos(_ id : String , _ definty : Int) {
        
        var idty = "LD"
        if definty == 0 {
            idty = "FD"
        }else if definty == 1{
            idty = "LD"
        }else{
            idty = "SD"
        }
        NetworkerManager.shared.getCourseVideoInfos(id,idty) { (isSuccess, code) in
            if isSuccess{
                for item in self.videoClassListModel.videoList{
                    for model in code{
                        if item.vid == model.vid{
                            item.size = model.size
                        }
                    }
                }
                self.mainTableView.reloadData()
            }
        }
    }

}

////mainScrollView
extension WFDownloadView {

    fileprivate func setTableView(){
        
        configTalbeView(mainTableView)
        
        mainTableView.register(WFDownloadCell.self, forCellReuseIdentifier: WFDownloadCell().identfy)
    }
    
    fileprivate func configTalbeView(_ tableView : UITableView){
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsetsMake(0, 13, 0, 15)
        tableView.bounces = false
        tableView.separatorColor = UIColor.clear
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.sectionFooterHeight = 0.01
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.white
        tableView.tableHeaderView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 0, height: 0.01))
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
}

///delegate dataSource
extension WFDownloadView : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videoClassListModel.videoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return WFDownloadCell.dequneceTableView(tableView, WFDownloadCell().identfy, indexPath, videoClassListModel.videoList[indexPath.row] as AnyObject)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if NetworkerManager.shared.userCount.isLogon == false {
            var nextView = self.superview
            while nextView != nil  {
                let nextResponder = nextView?.next
                if (nextResponder?.isKind(of: UIViewController.self))!{
                    let vc = WFLoginViewController()
                    vc.isShowBack = true
                    let nav = WFNavigationController.init(rootViewController: vc)
                    (nextResponder as! UIViewController).present(nav , animated: true, completion: nil)
                    return
                }else {
                    nextView = nextView?.superview
                }
            }
        }
        
        if saveModel == nil {
            
           var keyCount = UserDefaults.standard.value(forKey: user_class_video_mainKey) as! Int
            keyCount += 1
            UserDefaults.standard.set(keyCount, forKey: user_class_video_mainKey)
            
            let saModel = MainClassVideoStoreModel.init()
            saModel.title = className
            saModel.classId = classid
            saModel.imagePath = classimage
            saModel.id = keyCount
            saModel.totalClass = videoClassListModel.videoList.count
            
            saveModel = saModel
            saveVidToDownLoad(indexPath)
            getPlayAuthWithIndexPath(indexPath)
            
        }else{
            
            if  saveModel?.models.count == 0 {
                saveVidToDownLoad(indexPath)
                getPlayAuthWithIndexPath(indexPath)
            }else{
                
                for model in (saveModel?.models)!{
                    if model.vid == videoClassListModel.videoList[indexPath.row].vid{
                        SVProgressHUD.showInfo(withStatus: "该任务已经存在任务列表中")
                        return
                    }
                }
                saveVidToDownLoad(indexPath)
                getPlayAuthWithIndexPath(indexPath)
            }
        }
        videoClassListModel.videoList[indexPath.row].isSelectDownload = true
        tableView.reloadRows(at: [indexPath], with: .none)
//        if let downloadArr = AliyunVodDownLoadManager.share().allMedias(){
        
//        for item  in  downloadArr {
//            if item.vid == videoClassListModel.videoList[indexPath.row].vid{
//                SVProgressHUD.showInfo(withStatus: "该任务已经存在任务列表中")
//                return
//            }
//        }
//        }
        
        
        
         guard let cell  = tableView.cellForRow(at: indexPath) as? WFDownloadCell else { return }
         
//         videoClassListModel.videoList[indexPath.row].isSelectDownload = cell.setDownload()
//
//        if videoClassListModel.videoList[indexPath.row].isSelectDownload == false && cacheBtnView.isSelected == true {
//            cacheBtnView.isSelected = false
//            return
//        }
//
//        if videoClassListModel.videoList[indexPath.row].isSelectDownload == false{
//            return
//        }
//        for model  in videoClassListModel.videoList {
//            if model.isSelectDownload == false{
//                return
//            }
//        }
//        cacheBtnView.isSelected = true
        
    }
    
    fileprivate func saveVidToDownLoad(_ indexPah : IndexPath) {
    try! realm.write {
        let model  = VideoDetailModel.init()
        model.vid = videoClassListModel.videoList[indexPah.row].vid
        model.title = videoClassListModel.videoList[indexPah.row].name
        model.duration = videoClassListModel.videoList[indexPah.row].duration
        model.totalSize = videoClassListModel.videoList[indexPah.row].size
        saveModel?.models.append(model)
        realm.add(saveModel!)
        }
        WFCacheManagerController.share.loadClassDataList()
    }
    
    fileprivate  func getPlayAuthWithIndexPath(_ indexPath : IndexPath) {
        
        NetworkerManager.shared.getPlayAuth(videoClassListModel.videoList[indexPath.row].vid) { (isSuccess, playAuthon) in
            if isSuccess == true{
                let dataSource  = AliyunDataSource.init()
                dataSource.vid = self.videoClassListModel.videoList[indexPath.row].vid
                dataSource.playAuth = playAuthon
                dataSource.quality = self.videoQuality
                dataSource.format = "m3u8"
                AliyunVodDownLoadManager.share().prepareDownloadMedia(dataSource)
                AliyunVodDownLoadManager.share().startDownloadMedia(dataSource)
            }
        }
    }
}

///delegate dataSource
extension WFDownloadView : UIPickerViewDelegate,UIPickerViewDataSource{
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectVideoArray.count
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView != mainTableView {
            if scrolNum == 10000 {
               scrolNum = scrollView.contentOffset.y
                return
            }
            
            if scrollView.contentOffset.y - scrolNum > 0{
               scrolDirction = .bottom
            }else{
               scrolDirction = .top
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
//        print("\(row) \(pickerView.selectedRow(inComponent: 0))")
        if row == pickerView.selectedRow(inComponent: 0){
           return NSAttributedString.init(string: selectVideoArray[row], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)])
        }
        
        return NSAttributedString.init(string: selectVideoArray[row], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 13), NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        for item  in pickerView.subviews {
            if item.bounds.size.height < 1{
                item.backgroundColor = UIColor.white
            }
        }
        
        let label  = UILabel.init()
        label.text = selectVideoArray[row]
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = .center
        
        print("\(row) \(pickerView.selectedRow(inComponent: 0))")
        return label
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
