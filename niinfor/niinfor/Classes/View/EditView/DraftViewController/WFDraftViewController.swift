//
//  WFDraftViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/8.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFDraftViewController: BaseViewController {

    let placeHoderImageV = UIImageView.init(image: #imageLiteral(resourceName: "no_contentImage"))
    
}

//UI
extension WFDraftViewController{
    override func setUpUI() {
        super.setUpUI()
        title = "已发布"
        
        
        regestCellString(Bundle.main.namespace + "." + "WFPublishCell")
        
        baseTableView.estimatedRowHeight = 80
        baseTableView.rowHeight = UITableViewAutomaticDimension
        
        if #available(iOS 11.0, *) {
            baseTableView.contentInsetAdjustmentBehavior = .never
            baseTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)//导航栏如果使用系统原生半透明的，top设置为64
            baseTableView.scrollIndicatorInsets = baseTableView.contentInset
        }
        
        self.baseTableView.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(navigation_height)
        }
        placeHoderImageV.contentMode = .scaleAspectFit
        placeHoderImageV.clipsToBounds  = true
        view.addSubview(placeHoderImageV)
        placeHoderImageV.snp.makeConstraints { (maker) in
            maker.centerY.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(transHeight(250))
        }
    }
    
    
    
    override func loadData() {
        NetworkerManager.shared.getMpUserArticles(self.page) { (isSuccess, array) in
            if isSuccess == true {
                print(array)
                self.base_dataList = self.base_dataList + array
                self.placeHoderImageV.isHidden = !self.base_dataList.isEmpty
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc  = WFMPArticleDetailController()
        guard let model  = base_dataList[indexPath.row] as? WFMPArticle else { return  }
        
        vc.htmlString = Photo_Path + (model.articleUrl ?? "")
        vc.article  = model
        vc.title = model.title ?? ""
        vc.deleteComplict = {
            self.page = 1
            self.base_dataList.removeAll()
            self.loadData()
            self.baseTableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        viewWillDisappear(animated)
//        self.placeHoderImageV.isHidden = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        baseTableView.reloadData()
    }
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell  = tableView.dequeueReusableCell(withIdentifier: WFPublishCell().identfy, for: indexPath) as? WFPublishCell
//
//        cell?.setValue(base_dataList[indexPath.row], forKey: "model")
//        cell?.deletBtn.addTarget(self, action: #selector(notificationMessage(_:)), for: .touchUpInside)
//        return cell!
//    }

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if base_dataList.count > 0 {
            guard let  model  = base_dataList[indexPath.row] as? WFMPArticle else{
                return 0
            }
            let height =  model.cover != "" ? 260 : 110
            return CGFloat(height)
        }
        
        return 0
    }
    
}

extension WFDraftViewController{
    
    @objc func notificationMessage(_ notifi : UIButton)  {
        let cell  = notifi.superview?.superview as! WFPublishCell
        
        guard let index =  baseTableView.indexPath(for: cell),
            let dataModel = base_dataList[index.row] as? WFMPArticle else {
                return
        }
        
        baseTableView.reloadData()
    }
    
}

