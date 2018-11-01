//
//  WFDownloadClassDetailViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/10/16.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit
import RealmSwift
//
//protocol WFDeleteVideoProtocol {
//    func deleteVideoWithVid(_: [String])
//}

class WFDownloadClassDetailViewController: BaseViewController {
  
    let realm  = try! Realm()
//    let deletegate : WFDeleteVideoProtocol?
    
    fileprivate let contentView     = UIView()
    fileprivate let headerImageView = UIImageView.init()
    fileprivate let titleView       = UILabel.init()
    fileprivate let subTitleView    = UILabel.init()
    fileprivate let classTitleView  = UILabel.init()
    fileprivate let moreBtn         = UIButton.init(type: .custom)
    fileprivate let bottomImageView = UIImageView.init()
    
    fileprivate var btnlineView      = UIImageView.init()
    fileprivate var allSelectBtnVie = UIButton.init()
    fileprivate var deleteBtnView   = UIButton.init()
    
    fileprivate var bottomView       = UIView.init()
    fileprivate var sapceView        = UILabel.init()
    fileprivate var sapceSizeView    = UILabel.init()
    fileprivate var isDeleteMode     = false
    
    var deleteCompilct : (([String])->())?
    
    
    var cacheDataModel : MainClassVideoStoreModel = MainClassVideoStoreModel(){
        didSet{
            titleView.text             = cacheDataModel.title
            subTitleView.text          = ""
            
            classTitleView.text        = "共\(cacheDataModel.totalClass)课程  已缓存\(cacheDataModel.downloadedNum())课程"
            
            for model  in cacheDataModel.models {
                try! self.realm.write {
                    model.isSelected = false
                }
            }
            
            if cacheDataModel.imagePath == ""{
                headerImageView.image      = #imageLiteral(resourceName: "paper_img_neuro")
            }else{
                if let url  = URL.init(string: cacheDataModel.imagePath) {
                    headerImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "paper_img_neuro"), options: [], completed: nil)
                }
            }
        }
    }
}

///delegate dataSource
extension WFDownloadClassDetailViewController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cacheDataModel.downloadedNum()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WFDownloadCell().identfy, for: indexPath) as? WFDownloadCell
        cell?.configCel(cacheDataModel.cellModel(indexPath.row))
        cell?.setIsdeleteMode(isDeleteMode)
        cell?.btnClickComplict = {(btn ,cell ) in
             guard let index  = tableView.indexPath(for: cell) else { return }
             try! self.realm.write {
             let model  = self.cacheDataModel.cellModel(index.row)
                 model.isSelected = !model.isSelected
             }
             tableView.reloadRows(at: [index], with: .none)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  vc  = WFNewVideoViewController()
        let model  = cacheDataModel.cellModel(indexPath.row)
        
        if NetworkerManager.shared.reachabilityManager.isReachable == false{
            vc.playVid = model.vid
            vc.playPath = model.videoPath
            vc.isOfflinePlay = true
        }else{
            vc.classId = "\(cacheDataModel.classId)"
            vc.classImage = cacheDataModel.imagePath
            vc.className = cacheDataModel.title
        }
        self.present(vc, animated: true, completion: nil)
    }
            

//            switch model.condition {
//            case "N" :
//                self.present(vc, animated: true, completion: nil)
//    }
//            case "L" :
//                if NetworkerManager.shared.userCount.isLogon {
//                    self.present(vc, animated: true, completion: nil)
//                }else{
//                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
//                }
//            case "V" :
//                if NetworkerManager.shared.userCount.isAuth == 1 || NetworkerManager.shared.userCount.isAuth == 2 {
//                    self.present(vc, animated: true, completion: nil)
//                }else{
//                    navigationController?.pushViewController(WFApproveidController(), animated: true)
//                }
//            case "" : break
//            default : break
//            }
//        }
}

extension WFDownloadClassDetailViewController {
    
    @objc fileprivate func deleteBtnClick() {
          isDeleteMode = !isDeleteMode
        if isDeleteMode {
            allSelectBtnVie.snp.updateConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.bottom.equalTo(bottomView.snp.top)
                maker.height.equalTo(50)
                maker.width.equalToSuperview().multipliedBy(0.5)
            }
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }else{
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
        baseTableView.reloadData()
    }

    @objc fileprivate func moreBtnClick() {
        let vc  = WFVideoDownloadViewController()
        vc.cacheDataModel = cacheDataModel
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc fileprivate func selectAllBtnClick() {

        allSelectBtnVie.isSelected =  !allSelectBtnVie.isSelected
        for model  in cacheDataModel.models {
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
        
        let array1  = cacheDataModel.models.filter({ (model) -> Bool in
            return model.isSelected == false
        })
        
        var deleteArr = [String]()
        
        try! self.realm.write {
            for item in cacheDataModel.models{
                if item.isSelected == true && item.downloadStatus == 2 {
                    deleteArr.append(item.vid)
                    if let downLoad  = AliyunVodDownLoadManager.share().allMedias(){
                        for model in downLoad {
                            if model.vid == item.vid {
                                AliyunVodDownLoadManager.share().stopDownloadMedia(model)
                                AliyunVodDownLoadManager.share().clearMedia(model)
                            }
                        }
                    }
                }
            }

            var placeArray = [VideoDetailModel]()
            
            for model in cacheDataModel.models{
                if model.downloadStatus != 2 || model.isSelected == false{
                    placeArray.append(model)
                }
            }
            
            cacheDataModel.models.removeAll()
            
            for item in placeArray{
                cacheDataModel.models.append(item)
            }
            navigationController?.popViewController(animated: true)
        }

//        baseTableView.reloadData()
        
        
//        try! self.realm.write {
//            for model  in cacheDataModel.models.reversed() {
//                if model.isSelected == true {
//                    let index = cacheDataModel.models.index(of: model)
//                    cacheDataModel.models.remove(at: index!)
//                }
//            }

//        for (index,model)  in cacheDataModel.models.enumerated() {
//            if model.isSelected == true {
//               cacheDataModel.models.remove(at: index)
//            }
//            }
        
            
            
//        }
        if deleteCompilct != nil  {
            deleteCompilct!(deleteArr)
        }
        baseTableView.reloadData()
    }


}

extension WFDownloadClassDetailViewController{
    override func setUpUI() {
        super.setUpUI()
        title = "缓存详情"
        addSubView()
        setConstant()
        setNavBar()
    }
    
    fileprivate func setNavBar() {
        let deleteBtn  = UIButton.cz_textButton("", fontSize: 14, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), backgroundImageName: "")
        deleteBtn?.setImage(#imageLiteral(resourceName: "release_del"), for: .normal)
        deleteBtn?.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem.init(customView: deleteBtn!)

    }
    
    fileprivate func configTalbeView(_ tableView : UITableView){
        tableView.register(WFDownloadCell.self, forCellReuseIdentifier: WFDownloadCell().identfy)
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

    fileprivate func addSubView(){
        
        configTalbeView(baseTableView)
        view.backgroundColor = UIColor.white
        moreBtn.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        moreBtn.layer.cornerRadius = 10
        moreBtn.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        moreBtn.setAttributedTitle(NSAttributedString.init(string: "缓存更多", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 11),NSForegroundColorAttributeName : UIColor.white]), for: .normal)
        
        setLabelConfige(titleView, 16, #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
        setLabelConfige(subTitleView, 10, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        headerImageView.layer.cornerRadius = 4
        headerImageView.layer.masksToBounds = true
        
        setLabelConfige(classTitleView, 10, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        bottomImageView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        
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
        
        view.addSubview(contentView)
        contentView.addSubview(headerImageView)
        contentView.addSubview(titleView)
        contentView.addSubview(subTitleView)
        contentView.addSubview(classTitleView)
        contentView.addSubview(moreBtn)
        contentView.addSubview(bottomImageView)
        
        view.addSubview(btnlineView)
        view.addSubview(allSelectBtnVie)
        view.addSubview(deleteBtnView)
        
        view.addSubview(bottomView)
        bottomView.addSubview(sapceView)
        bottomView.addSubview(sapceSizeView)


    }
    fileprivate func setConstant(){
        
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalTo(navigation_height)
            maker.height.equalTo(115)
        }
        headerImageView.snp.makeConstraints { (maker) in
            maker.right.bottom.equalToSuperview().offset(-15)
            maker.top.equalToSuperview().offset(15)
            maker.width.equalTo(120)
            maker.height.equalTo(90)
        }
        titleView.snp.makeConstraints { (maker) in
            maker.top.left.equalToSuperview().offset(12)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.height.equalTo(30)
        }
        subTitleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(titleView.snp.bottom).offset(0)
        }
        classTitleView.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(15)
            maker.right.equalTo(headerImageView.snp.left).offset(-15)
            maker.top.equalTo(subTitleView.snp.bottom).offset(10)
        }
        moreBtn.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleView)
            maker.width.equalTo(70)
            maker.height.equalTo(20)
            maker.bottom.equalToSuperview().offset(-10)
        }
        bottomImageView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalToSuperview()
            maker.height.equalTo(0.5)
            maker.bottom.equalToSuperview().offset(-0.5)
        }
        
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
            maker.top.equalTo(contentView.snp.bottom)
            maker.bottom.equalTo(allSelectBtnVie.snp.top).offset(-0.5)
        }

    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)
    }
}










