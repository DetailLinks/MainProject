
//
//  WFCacheManagerController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/25.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RealmSwift

class WFCacheManagerController: BaseViewController {
 
    
    let realm  = try! Realm()
    
    fileprivate var deleteBtn = UIButton.init()
    
    var dataList : [AliyunDataSource] = []
    var cacheingDataList : [DownloadCellModel] = []
        //AliyunVodDownLoadManager.share().downloadingdMedias(){
//        didSet{
//            baseTableView.reloadData()
//        }
//    }
    
    fileprivate var btnlineView      = UIImageView.init()
    fileprivate var allSelectBtnVie = UIButton.init()
    fileprivate var deleteBtnView   = UIButton.init()
    
    fileprivate var bottomView       = UIView.init()
    fileprivate var sapceView        = UILabel.init()
    fileprivate var sapceSizeView    = UILabel.init()
    fileprivate let no_download_imageV = UIImageView()
    
    
    var classDataList : [MainClassVideoStoreModel] = []{
        didSet{
            baseTableView.reloadData()
        }
    }
    func classListValidNum() -> Int {
        return classDataList.filter({ cl -> Bool in
            return cl.downloadedNum() > 0
        }).count
    }
    func cellClassValid(_ row:Int) -> MainClassVideoStoreModel {
        var index = 0;
        for cl in classDataList {
            if cl.downloadedNum() > 0 {
                if (index == row) {
                    return cl
                }
                index = index+1;
            }
        }
        return MainClassVideoStoreModel()
    }
    fileprivate var isDeleteMode     = false
    
    var deleteCompilct : (()->())?
    
    static let share : WFCacheManagerController = {
       let manager = WFCacheManagerController()
       return manager
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isDeleteMode {
            allSelectBtnVie.snp.updateConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.bottom.equalTo(bottomView.snp.top)
                maker.height.equalTo(0)
                maker.width.equalToSuperview().multipliedBy(0.5)
            }
        }
        
        isDeleteMode = false
        
        //cacheingDataList  = AliyunVodDownLoadManager.share().downloadingdMedias()
        
        try! realm.write {
            for item  in classDataList {
                if item.models.isEmpty {
                   realm.delete(item)
                }
            }
        }
        classDataList.removeAll()
        loadClassDataList()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        for model  in classDataList {
            try! self.realm.write {
                model.isSelected = false
            }
        }
        
        if classDataList.isEmpty && cacheingDataList.isEmpty {
            no_download_imageV.isHidden = false
            navItem.rightBarButtonItem = nil
        }else{
            no_download_imageV.isHidden = true
            navItem.rightBarButtonItem = UIBarButtonItem.init(customView: deleteBtn)
        }
        
        baseTableView.reloadData()
    }
}

extension WFCacheManagerController{
    @objc fileprivate func deleteBtnClick() {
        isDeleteMode = !isDeleteMode
        if isDeleteMode {
            
            showDeleteBtn()
        }else{
     
            hiddenDeleteBtn()
        }
        baseTableView.reloadData()
    }
    
    fileprivate func showDeleteBtn(){
        allSelectBtnVie.snp.updateConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(bottomView.snp.top)
            maker.height.equalTo(50)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func hiddenDeleteBtn(){
    
        allSelectBtnVie.snp.updateConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(bottomView.snp.top)
            maker.height.equalTo(0)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    
    }
    
    @objc func popViewController() {
        dismiss(animated: true, completion: nil)
        if (navigationController?.viewControllers.count)! > 1 {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func selectAllBtnClick() {
        
        allSelectBtnVie.isSelected =  !allSelectBtnVie.isSelected
        for model  in cacheingDataList {
            try! self.realm.write {
                model.isSelected = allSelectBtnVie.isSelected
            }
        }
        
        for model  in classDataList {
            try! self.realm.write {
                model.isSelected = allSelectBtnVie.isSelected
            }
        }

        
        baseTableView.reloadData()
    }
    
    @objc fileprivate func deleteContentBtnClick() {
        
        let alertController  = UIAlertController.init(title: "提示", message: "确定删除选中的视频吗？", preferredStyle: .alert)
        
        let alertActionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let alertADelete = UIAlertAction.init(title: "删除", style: .default) { (_) in
            self.ensureDeleteContent()
        }
     
        alertController.addAction(alertActionCancel)
        alertController.addAction(alertADelete)
        
        present(alertController, animated: true, completion: nil)
    }
    
        func ensureDeleteContent(){
            
        isDeleteMode = false
        try! self.realm.write {
            
            let array  = classDataList.filter({ (model) -> Bool in
                return model.isSelected == false
            })
            
            for model  in classDataList {
                if model.isSelected == true {
                    if let mod = realm.object(ofType: MainClassVideoStoreModel.self, forPrimaryKey: model.id){
                        
                        let downLoad  = AliyunVodDownLoadManager.share().allMedias() ?? []
                        
                        for item in mod.models{
                            for downItem in downLoad{
                                if item.vid == downItem.vid && item.downloadStatus == 2{
                                    AliyunVodDownLoadManager.share().clearMedia(downItem)
                                    break
                                }
                            }
                        }
                        let deleteArray = mod.models.filter({ (mode) -> Bool in
                            return mode.downloadStatus == 2
                        })
                        for item in deleteArray{
                            realm.delete(item)
                        }
                        
                        if mod.models.isEmpty{
                            realm.delete(mod)
                        }
                    }
                }
            }

            classDataList = array
            
            for item in cacheingDataList{
                if item.isSelected == true {
                   AliyunVodDownLoadManager.share().stopDownloadMedia(item.mInfo)
                   AliyunVodDownLoadManager.share().clearMedia(item.mInfo)
                }
              
                let classM = realm.objects(MainClassVideoStoreModel.self)
                for items in  classM{
                    for ite in items.models{
                        if ite.vid == item.mInfo.vid{
//                            try! realm.write {
                                let index = items.models.index(of: ite)
                                if let index = index{
                                    items.models.remove(at: index)
                                }
//                            }
                        }
                    }
                }
            }

            let array1  = cacheingDataList.filter({ (model) -> Bool in
                return model.isSelected == false
            })
            
            cacheingDataList = array1
            baseTableView.reloadData()
            
            hiddenDeleteBtn()
            if classDataList.isEmpty && cacheingDataList.isEmpty {
                no_download_imageV.isHidden = false
                navItem.rightBarButtonItem = nil
            }else{
                
                var isShouldhidden = false
                
                let classM = realm.objects(MainClassVideoStoreModel.self)
                for items in  classM{
                    for ite in items.models{
                        if ite.downloadStatus == 2{
                           isShouldhidden = true
                            break
                        }
                    }
                }
                no_download_imageV.isHidden = isShouldhidden || !cacheingDataList.isEmpty
                navItem.rightBarButtonItem = (isShouldhidden || !cacheingDataList.isEmpty) ? UIBarButtonItem.init(customView: deleteBtn) : nil

            }

            //        for (index,model)  in cacheDataModel.models.enumerated() {
            //            if model.isSelected == true {
            //               cacheDataModel.models.remove(at: index)
            //            }
            //            }
            
            
            
        }
//        if deleteCompilct != nil  {
//            deleteCompilct!()
//        }
        baseTableView.reloadData()
    }
    


}

extension WFCacheManagerController{
    override func setUpUI() {
        super.setUpUI()
        title = "缓存管理"
        configTalbeView(baseTableView)
        
//        setNavgationBar()
        loadClassDataList()
//        setAliplayerDownloadConfig()
        addSubView()
        setConstant()

        deleteBtn  = UIButton.cz_textButton("", fontSize: 14, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), backgroundImageName: "")
        deleteBtn.setImage(#imageLiteral(resourceName: "release_del"), for: .normal)
        deleteBtn.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem.init(customView: deleteBtn)
    }
    
    fileprivate func addSubView(){
        
//        configTalbeView(baseTableView)
        view.backgroundColor = UIColor.white
        
        btnlineView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        allSelectBtnVie.setAttributedTitle(NSAttributedString.init(string: "全选", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)]), for: .normal)
        deleteBtnView.setAttributedTitle(NSAttributedString.init(string: "删除", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15) , NSForegroundColorAttributeName : UIColor.red]), for: .normal)
        
        allSelectBtnVie.addTarget(self, action: #selector(selectAllBtnClick), for: .touchUpInside)
        deleteBtnView.addTarget(self, action: #selector(deleteContentBtnClick), for: .touchUpInside)
        allSelectBtnVie.clipsToBounds = true
        deleteBtnView.clipsToBounds = true
        
        sapceView.text = "可用空间"
        sapceView.font = UIFont.systemFont(ofSize: 10)
        sapceView.textColor = #colorLiteral(red: 0.3921568627, green: 0.3921568627, blue: 0.3921568627, alpha: 1)
        sapceView.textAlignment = .right
        
        sapceSizeView.textColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        sapceSizeView.text = NSString().freeDiskSpaceInBytes()
        sapceSizeView.font = UIFont.systemFont(ofSize: 10)
        sapceSizeView.textAlignment = .left
        
        bottomView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
        view.addSubview(btnlineView)
        view.addSubview(allSelectBtnVie)
        view.addSubview(deleteBtnView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(sapceView)
        bottomView.addSubview(sapceSizeView)
        
        baseTableView.addSubview(no_download_imageV)
        no_download_imageV.image = #imageLiteral(resourceName: "no_video")
        no_download_imageV.contentMode = .scaleAspectFit
        
    }
    fileprivate func setConstant(){
        
        bottomView.snp.makeConstraints { (maker) in
            maker.left.bottom.right.equalToSuperview()
            maker.height.equalTo(22)
        }
        allSelectBtnVie.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(bottomView.snp.top)
            maker.height.equalTo(0)
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        deleteBtnView.snp.makeConstraints { (maker) in
            maker.bottom.top.width.height.equalTo(allSelectBtnVie)
            maker.right.equalToSuperview()
        }
        btnlineView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.bottom.equalTo(allSelectBtnVie.snp.top)
        }
        sapceView.snp.makeConstraints { (maker) in
            maker.left.bottom.top.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        sapceSizeView.snp.makeConstraints { (maker) in
            maker.right.bottom.top.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(0.5)
        }
        baseTableView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(navigation_height)
            maker.bottom.equalTo(allSelectBtnVie.snp.top).offset(-0.5)
        }
        no_download_imageV.snp.makeConstraints { (maker ) in
            maker.center.equalToSuperview()
        }
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }

    func loadDownLoadData() {
        
        guard let download = AliyunVodDownLoadManager.share().allMedias() else{
            return
        }
        
        let dataList  = realm.objects(MainClassVideoStoreModel.self)
        
        var array : [String] = []
        
        for classModel  in dataList {

            for model in classModel.models{
                if model.downloadStatus != 2{
                    array.append(model.vid)
                }
            }
        }
        
        for model in download {
            if array.contains(model.vid){
                let dcm = DownloadCellModel()
                dcm.mCanStop = false
                dcm.mCanPlay = false
                dcm.mCanStart = true
                dcm.mInfo = model
                cacheingDataList.append(dcm)
            }
        }
    }
    
    func loadClassDataList() {
        let dataList  = realm.objects(MainClassVideoStoreModel.self)
        classDataList.removeAll()
        for item  in dataList {
            classDataList.append(item)
        }
        baseTableView.reloadData()
    }
    
    fileprivate func configTalbeView(_ tableView : UITableView){
        tableView.register(WFCachingTableViewCell.self, forCellReuseIdentifier: WFCachingTableViewCell().identfy)
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
    
    fileprivate func setNavgationBar(){
        
        let item  = UIBarButtonItem(imageString: "nav_icon_back", target: self, action: #selector(popViewController), isBack: true , fixSpace : 12 )
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        navItem.leftBarButtonItems = [spaceItem,item]
        

    }
    
    
     func setAliplayerDownloadConfig() {
        ///下载必须要设置的三个内容：1.下载代理 2.下载路径3.下载加密的秘钥（如果要加密的话）
        //设置下载代理
        let downloadManager = AliyunVodDownLoadManager.share()
        downloadManager?.downloadDelegate = self
        downloadManager?.downLoadInfoListenerDelegate(self)
        //设置下载路径
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        downloadManager?.setDownLoadPath(path)
        
        //设置加密下载
        let bundlePath = Bundle.main.bundlePath
        let appInfo = bundlePath.appending("/encryptedApp.dat")
        downloadManager?.setEncrptyFile(appInfo)
        
        //设置同时下载的个数
        downloadManager?.setMaxDownloadOperationCount(2)
    }
}

///AliDownloadManager
extension WFCacheManagerController : AliyunVodDownLoadDelegate{
    func onPrepare(_ mediaInfos: [AliyunDownloadMediaInfo]!) {
        print("onPrepare ")
        
        for item  in mediaInfos {
            var  isExit = false
            
            for dcm in cacheingDataList{
                let info = (dcm.mInfo)!
                if info.vid == item.vid {
                   isExit = true
                   dcm.downloadStatus = 0
                   break
                }
            }
            if isExit == false {
                let dcm = DownloadCellModel()
                dcm.mCanStop = false
                dcm.mCanPlay = false
                dcm.mCanStart = true
                dcm.mInfo = item
                dcm.downloadStatus = 0
                cacheingDataList.append(dcm)
            }
        }
        baseTableView.reloadData()
    }
    
    func onStart(_ mediaInfo: AliyunDownloadMediaInfo!) {
        print("onStart ")
        for dcm in cacheingDataList{
            let info = (dcm.mInfo)!
            if info.vid == mediaInfo.vid {
                info.title = mediaInfo.title
                info.coverURL = mediaInfo.coverURL
                info.size = mediaInfo.size
                info.duration = mediaInfo.duration
                info.downloadFilePath = mediaInfo.downloadFilePath
                
                dcm.mCanStop = true
                dcm.mCanPlay = false
                dcm.mCanStart = false
                dcm.downloadStatus = 1
                
                baseTableView.reloadData()
                return
            }
        }
        //cacheingDataList.append(dataSource)
//        let dcm = DownloadCellModel()
//        dcm.mCanStop = true
//        dcm.mCanPlay = false
//        dcm.mCanStart = true
//        dcm.mInfo = mediaInfo
////        dcm.mSource = dataSource
//        cacheingDataList.append(dcm)
//
//        baseTableView.reloadData()

//        for item  in cacheingDataList {
//            if item.mInfo.vid == mediaInfo.vid{
//                item.mCanStart = true
//                return
//            }
//            let cacheModel = DownloadCellModel()
//            cacheModel.mInfo = mediaInfo
//            cacheModel.mCanStart = true
//
//            cacheingDataList.append(cacheModel)
//            baseTableView.reloadData()
//        }
    }
    
    func onStop(_ mediaInfo: AliyunDownloadMediaInfo!) {
        print("onStop ")
        for dcm in cacheingDataList{
            if dcm.mInfo.vid == mediaInfo.vid {
                dcm.mCanStop = false
                dcm.mCanPlay = false
                dcm.mCanStart = true
                baseTableView.reloadData()
                break
            }
        }
    }
    
    func onCompletion(_ mediaInfo: AliyunDownloadMediaInfo!) {
        print("onCompletion ")
        try! realm.write {
            let dataList  = realm.objects(MainClassVideoStoreModel.self)
            for classModel  in dataList {
                for model in classModel.models{
                    if model.vid ==  mediaInfo.vid{
                        model.videoPath = mediaInfo.downloadFilePath
                        model.totalSize = Int(mediaInfo.size)
                        model.downloadStatus = 2
                        break
                    }
                }
            }
        }
        
        for (index,dcm) in cacheingDataList.enumerated(){
            if dcm.mInfo.vid == mediaInfo.vid{
                dcm.mCanStop = true
                dcm.mCanPlay = true
                dcm.mCanStart = true
                dcm.downloadStatus = 2
                cacheingDataList.remove(at: index)
                baseTableView.reloadData()
                break
            }
        }
    }
    
    func onProgress(_ mediaInfo: AliyunDownloadMediaInfo!) {
         print("mediaInfo.downloadProgress")
         print(mediaInfo.downloadProgress)
        
        
//        for item  in baseTableView.subviews {
//
//            guard let cell = item as? WFCachingTableViewCell else{
//                return
//            }
//            if cell.model != nil && cell.model.mInfo.vid == mediaInfo.vid{
//                cell.setProgress(CGFloat(mediaInfo.downloadProgress),CGFloat(Int64(mediaInfo.downloadProgress) * mediaInfo.size / 1024 / 102400))
//            }
//
//        }
        
        for (index,model)  in cacheingDataList.enumerated() {
            if model.mInfo.vid == mediaInfo.vid{
             guard let cell  = baseTableView.cellForRow(at: IndexPath.init(row: index, section: 0)) as? WFCachingTableViewCell else { return }
            cell.setProgress(CGFloat(mediaInfo.downloadProgress),CGFloat(Int64(mediaInfo.downloadProgress) * mediaInfo.size / 1024 / 102400))
            }
        }
    }
    
    func onError(_ mediaInfo: AliyunDownloadMediaInfo!, code: Int32, msg: String!) {
         print("downloaderror \(mediaInfo)\n\(code)\n\(msg)")
//        for (index,item)  in cacheingDataList.enumerated() {
//            if item.mInfo.vid == mediaInfo.vid{
//                item.downloadStatus = -1
//                cacheingDataList.remove(at: index)
//                let array  = realm.objects(MainClassVideoStoreModel.self)
//                for items in array{
//                    for(index,ite)  in items.models.enumerated(){
//                        if ite.vid == mediaInfo.vid{
//                            self.realm.beginWrite()
//                            items.models.remove(at: index)
//                            try? self.realm.commitWrite()
//                         self.baseTableView.reloadData()
//                         return
//                        }
//                    }
//                }
        
//                try! realm.write {
//                    let dataList  = realm.objects(MainClassVideoStoreModel.self)
//                    for classModel  in dataList {
//                        for model in classModel.models{
//                            if model.vid ==  mediaInfo.vid{
//                                model.downloadStatus = -1
//                            }
//                        }
//                    }
//                }
//
//                self.baseTableView.reloadData()
//            }
//        }
    }

    func onUnFinished(_ mediaInfos: [AliyunDataSource]!) {
        if mediaInfos.count > 0{
            for source in mediaInfos{
                if source.playAuth == nil {
                    return
//                    source.playAuth = PLAYAUTH
                }
                
                let dcm = DownloadCellModel()
                let info = AliyunDownloadMediaInfo()
                info.vid = source.vid
                info.quality = source.quality
                info.format = source.format
                dcm.mInfo = info
                dcm.mCanPlay = false
                dcm.mCanStop = true
                dcm.mCanStart = false
                dcm.mSource = source
                cacheingDataList.append(dcm)
                dataList.append(dcm.mSource)
            }
            baseTableView.reloadData()
            AliyunVodDownLoadManager.share().startDownloadMedias(mediaInfos)
        }
    }
    
//    func onGetPlayAuth(_ vid: String!, format: String!, quality: AliyunVodPlayerVideoQuality) -> String! {
//        var playAuth = ""
//        NetworkerManager.shared.getPlayAuth(vid) { (isSuccess, json) in
//            if isSuccess == true {
//               playAuth = json
//            }
//        }
//        return playAuth
//    }
}

///delegate dataSource
extension WFCacheManagerController{

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? cacheingDataList.count  : classListValidNum()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFCachingTableViewCell().identfy, for: indexPath) as? WFCachingTableViewCell
        
        cell?.setIsdeleteMode(isDeleteMode)
        cell?.btnClickComplict = {(btn , cell) in
            guard let index  = tableView.indexPath(for: cell) else { return }
            try! self.realm.write {
                if index.section == 0{
                    let model  = self.cacheingDataList[index.row]
                    model.isSelected = !model.isSelected
                }else{
                    let model  = self.cellClassValid(index.row)
                    model.isSelected = !model.isSelected
                }
            }
            tableView.reloadRows(at: [index], with: .none)
        }
        
        if indexPath.section == 0 {
            cell?.configCell(cacheingDataList[indexPath.row])
            cell?.setClassTitleViewHidden()
        }else{
            cell?.configCell(cellClassValid(indexPath.row))
            cell?.setProgressViewTitleViewHidden()
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0{
            
            let model  = cacheingDataList[indexPath.row]
            if model.mCanStart == true{
                
                let dataSource  = AliyunDataSource.init()
                dataSource.vid = model.mInfo.vid
                dataSource.quality =  model.mInfo.quality
                dataSource.format = "m3u8"
                
                NetworkerManager.shared.getPlayAuth(model.mInfo.vid) { (isSuccess, json) in
                                if isSuccess == true {
                                   dataSource.playAuth = json
                                   AliyunVodDownLoadManager.share().startDownloadMedia(dataSource)
                                   model.mCanStart = false
                                }
                            }
            }else{
                model.mCanStart = true
            AliyunVodDownLoadManager.share().stopDownloadMedia(cacheingDataList[indexPath.row].mInfo)
            }
        }else{
            
            let vc  = WFDownloadClassDetailViewController()
            vc.cacheDataModel = cellClassValid(indexPath.row)
            vc.deleteCompilct = {[weak self](deleteArr) in

                self?.cacheingDataList = (self?.cacheingDataList.filter({ (model) -> Bool in
                    return !deleteArr.contains(model.mInfo.vid)
                })) ?? []
                
                self?.baseTableView.reloadData()
                if (self?.classDataList.isEmpty)! && (self?.cacheingDataList.isEmpty)! {
                    self?.no_download_imageV.isHidden = false
                    self?.navItem.rightBarButtonItem = nil
                }else{
                    self?.no_download_imageV.isHidden = true
                    self?.navItem.rightBarButtonItem = UIBarButtonItem.init(customView: (self?.deleteBtn)!)
                }
            }
            navigationController?.pushViewController(vc , animated: true)
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = WFVideoHeaderView.init(section == 0 ? "缓存中" : "已缓存", CGRect.init(x: 0, y: 0, width: Screen_width, height: 40)," ")
            return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return cacheingDataList.isEmpty ? 0 : 40
        }else{
            
            if classDataList.isEmpty {
                return 0
            }else{
                for item in classDataList{
                    for model in item.models{
                        if model.downloadStatus == 2{
                            return 40
                        }
                    }
                }
                return 0
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
         return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}

