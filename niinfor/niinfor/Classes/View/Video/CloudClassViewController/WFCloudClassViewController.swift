//
//  WFCloudClassViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFCloudClassViewController: BaseViewController {

    let mainTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
    fileprivate let viewModel     = WFVideoViewModel()
}

///headerDelegate
extension WFCloudClassViewController : MoreBtnClickProtocol {

    func headerViewMoreBtnClick(_ video: WFVideoHeaderView) {
        if video.title ?? "" == "最新课程" {
            let vc  = WFMoreClassConttoller()
            vc.title = "最新课程"
            navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc  = WFMoreClassConttoller()
            vc.title = "推荐课程"
            vc.isFreeClass = false
            navigationController?.pushViewController(vc, animated: true)

        }
    }
}
///tableViewDelegate && dataSource
extension WFCloudClassViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0 :
            if indexPath.row == 0{
                return WFSplitTableViewCell.dequneceTableView(tableView,WFSplitTableViewCell().identfy , indexPath, viewModel as AnyObject)
            }else{
                return WFClickBtnTableViewCell.dequneceTableView(tableView,WFClickBtnTableViewCell().identfy , indexPath, viewModel as AnyObject)
            }
        case 1 :
              return WFFreeClassTableViewCell.dequneceTableView(tableView,WFFreeClassTableViewCell().identfy , indexPath, viewModel as AnyObject)
            
        case 2 :
              return WFRecommandTableViewCell.dequneceTableView(tableView,WFRecommandTableViewCell().identfy , indexPath, viewModel as AnyObject)

        default: break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0 : break
        case 1 :
            let  vc  = WFNewVideoViewController()
            let model  = viewModel.freeClassArray[indexPath.row]
            vc.classId = "\(model.id)"
            vc.classImage = model.image
            vc.className = model.name
            switch model.condition {
            case "N" :
                self.present(vc, animated: true, completion: nil)
                
            case "L" :
                if NetworkerManager.shared.userCount.isLogon {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
                }
            case "V" :
                if NetworkerManager.shared.userCount.isAuth == 1 || NetworkerManager.shared.userCount.isAuth == 2 {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    navigationController?.pushViewController(WFApproveidController(), animated: true)
                }
            case "" : break
            default : break
            }

        case 2 :
            let  vc  = WFNewVideoViewController()
            let model  = viewModel.recommandClassArray[indexPath.row]
            vc.classId = "\(model.id)"
            vc.classImage = model.image
            vc.className = model.name
            switch model.condition {
            case "N" :
                self.present(vc, animated: true, completion: nil)
                
            case "L" :
                if NetworkerManager.shared.userCount.isLogon {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
                }
            case "V" :
                if NetworkerManager.shared.userCount.isAuth == 1 || NetworkerManager.shared.userCount.isAuth == 2 {
                    self.present(vc, animated: true, completion: nil)
                }else{
                    navigationController?.pushViewController(WFApproveidController(), animated: true)
                }
            case "" : break
            default : break
            }

        default: break
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 || section == 2 {
            let headerView = WFVideoHeaderView.init(section == 1 ? "最新课程" : "推荐课程", CGRect.init(x: 0, y: 0, width: Screen_width, height: 40),"")
            headerView.delegate = self
            return headerView
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0 : return  0
        case 1 : return  40
        case 2 : return  40
        default: return  0
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0 : return  1
        case 1 : return  viewModel.freeClassArray.count
        case 2 : return  viewModel.recommandClassArray.count
        default: return  0
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
}

extension WFCloudClassViewController{
    @objc func cacheBtnClick(){
        
        let vc  = NetworkerManager.shared.userCount.isLogon ? WFCacheManagerController.share : WFLoginViewController()//WFViewHistoryViewController()
        navigationController?.pushViewController(vc , animated: true)
        
    }
    
    @objc func searchBtnClick(){
        let vc = WFViewController()
        navigationController?.pushViewController(vc , animated: true)
    }
}

extension WFCloudClassViewController{
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        title = "云课堂"
        
        viewModel.targetController = self
        mainTableView.reloadData()
        addSubViews()
        setConstant()
        setNavigationBar()
    }
    
    fileprivate func addSubViews() {
        configTalbeView(mainTableView)
        view.addSubview(mainTableView)
    }
    
    fileprivate func setConstant() {
        mainTableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(navigation_height)
        }
    }
    
    func setNavigationBar() {
        
        let btn = UIButton.cz_imageButton("icon_dowland", backgroundImageName: "")
        btn?.addTarget(self, action: #selector(cacheBtnClick), for: .touchUpInside)
        let btn1 = UIButton.cz_imageButton("icon_search", backgroundImageName: "")
        btn1?.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)

        let contentView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 80, height: 44))
        btn?.frame = CGRect.init(x: 0, y: 0, width: 40, height: 44)
        btn1?.frame = CGRect.init(x: 40, y: 0, width: 40, height: 44)
        contentView.addSubview(btn!)
        contentView.addSubview(btn1!)
        let rightItem = UIBarButtonItem.init(customView: contentView)
        navItem.rightBarButtonItem = rightItem
    }
    
    fileprivate func configTalbeView(_ tableView : UITableView){
        
        tableView.register(WFSplitTableViewCell.self, forCellReuseIdentifier: WFSplitTableViewCell().identfy)
        tableView.register(WFClickBtnTableViewCell.self, forCellReuseIdentifier: WFClickBtnTableViewCell().identfy)
        tableView.register(WFFreeClassTableViewCell.self, forCellReuseIdentifier: WFFreeClassTableViewCell().identfy)
        tableView.register(WFRecommandTableViewCell.self, forCellReuseIdentifier: WFRecommandTableViewCell().identfy)

        tableView.backgroundColor = UIColor.cz_random()
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
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
            automaticallyAdjustsScrollViewInsets = false
        }
    }
}
