//
//  WFVideoDownloadViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/10/9.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit
import RealmSwift


class WFVideoDownloadViewController: BaseViewController {

    let realm  = try! Realm()
    
    
    fileprivate let downLoadView = WFDownloadView.init(frame: CGRect.zero)
    var videoClassListModel  : WFVideoClassModel = WFVideoClassModel(){
        didSet{
//            downLoadView.videoClassListModel = videoClassListModel
            
            let videoArr = realm.objects(MainClassVideoStoreModel.self)
            if videoArr.isEmpty {
                downLoadView.videoClassListModel = videoClassListModel
                return
            }
            for item  in videoArr {
                if item.classId == cacheDataModel.classId {
                    downLoadView.classid = item.classId
                    downLoadView.saveModel = item
                    downLoadView.isSaveClass = true
                    downLoadView.videoClassListModel = videoClassListModel
                    return
                }
            }
            downLoadView.videoClassListModel = videoClassListModel
        }
        }
    
    var cacheDataModel : MainClassVideoStoreModel = MainClassVideoStoreModel(){
        didSet{
            title = cacheDataModel.title
            loadVideoClassListData(cacheDataModel.classId)
        }
    }
    
    fileprivate func loadVideoClassListData (_ id : String) {
        NetworkerManager.shared.getCourseVideos(id) { (isSuccess, code) in
            if isSuccess{
                if let model = code {
                    self.videoClassListModel = model
                }
            }
        }
    }

}

extension WFVideoDownloadViewController{
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        
        //setNavgationBar()
        
        view.addSubview(downLoadView)
        
        downLoadView.topView.snp.updateConstraints { (maker) in
            maker.left.top.right.equalToSuperview()
            maker.height.equalTo(0)
        }
        downLoadView.topView.clipsToBounds = true
        downLoadView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(navigation_height)
        }
        
        downLoadView.cacheManagerBtnView.addTarget(self, action: #selector(cacheManagerBtnClick), for: .touchUpInside)
    }
    
    @objc func cacheManagerBtnClick(){
        var arr  = navigationController?.viewControllers
        arr?.remove(at: (arr?.count)!-2)
        navigationController?.viewControllers = arr!
        navigationController?.popViewController(animated: true)
    }
    
    fileprivate func setNavgationBar(){
        
        let item  = UIBarButtonItem(imageString: "nav_icon_back", target: self, action: #selector(popViewController), isBack: true , fixSpace : 12 )
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        navItem.leftBarButtonItems = [spaceItem,item]
    }
    
    @objc func popViewController() {
        
        dismiss(animated: true, completion: nil)
    }
    
}
