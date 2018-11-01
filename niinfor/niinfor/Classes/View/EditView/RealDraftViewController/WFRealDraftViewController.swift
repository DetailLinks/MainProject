//
//  WFRealDraftViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/9.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RealmSwift
class WFRealDraftViewController: BaseViewController {

    let realm = try! Realm()
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
  let placeHoderImageV = UIImageView.init(image: #imageLiteral(resourceName: "no_contentImage"))
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        base_dataList.removeAll()
        getMaindata()
    }
}

//data
extension WFRealDraftViewController{
 
    func getMaindata() {
        
        let result =  realm.objects(MainCaseStoreModel.self)
        print(result)
        
        for item  in result {
            let model  = WFMPArticle()
            model.title = item.title
            model.isDraft = true
            model.type = item.articleType
            model.imageData = item.fileData
            model.keyId = "\(item.id)"
            model.creationTime = item.creatTime
            if  item.title == "" &&
                item.models.count == 0 &&
                item.fileData == nil {
            }else{
                base_dataList.insert(model, at: 0)
            }
        }
        placeHoderImageV.isHidden = !base_dataList.isEmpty
        baseTableView.reloadData()
        
    }
}

//UI
extension WFRealDraftViewController{
    override func setUpUI() {
        super.setUpUI()
        title = "草稿"
        
        //regestCellString(Bundle.main.namespace + "." + "WFPublishCell")
        baseTableView.register(WFPublishCell.self, forCellReuseIdentifier: WFPublishCell().identfy)
        NotificationCenter.default.addObserver(self, selector: #selector(notificationMessage(_:)), name: NSNotification.Name.init(notifi_draft_delete_infomaton), object: nil)

        
        baseTableView.estimatedRowHeight = 80
        baseTableView.rowHeight = UITableViewAutomaticDimension
        baseTableView.bounces = false
        
        self.baseTableView.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(navigation_height)
        }
        getMaindata()
        
        placeHoderImageV.contentMode = .scaleAspectFit
        placeHoderImageV.clipsToBounds  = true
        view.addSubview(placeHoderImageV)
        placeHoderImageV.snp.makeConstraints { (maker) in
            maker.top.bottom.left.right.equalToSuperview()
//            maker.top.equalToSuperview().offset(transHeight(250))
        }
//        let linkValid = baseda.rx.text.orEmpty.map {$0.count > 0}.share(replay: 1, scope: .forever)
//        let linkDesValid = linkDesTF.rx.text.orEmpty.map {$0.count > 0}.share(replay: 1, scope: .forever)
//
//        let bothLinkValid = Observable.combineLatest(linkValid,linkDesValid) { $0 && $1}.share(replay: 1, scope: .forever)
//
//        bothLinkValid.bind(to:btnright.rx.isEnabled).disposed(by: disposeBag)
//

    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        mainDataSouce = []
        let vc  = WFNewCaseViewController()
        guard let model  = base_dataList[indexPath.row] as? WFMPArticle else { return  }
        vc.caseType = .old("\(model.keyId)")
        vc.articleType = model.type ?? "0"
        print(model.keyId)
        print("model.keyId")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFPublishCell().identfy, for: indexPath) as? WFPublishCell
        
        cell?.setValue(base_dataList[indexPath.row], forKey: "model")
        cell?.deletBtn.addTarget(self, action: #selector(notificationMessage(_:)), for: .touchUpInside)
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if base_dataList.count > 0 {
            guard let  model  = base_dataList[indexPath.row] as? WFMPArticle else{
                return 0
            }
            let height =  model.imageData != nil ? 260 : 110
            return CGFloat(height)
        }
        
        return 0
    }
}
extension WFRealDraftViewController{
    
    @objc func notificationMessage(_ notifi : UIButton)  {
        let cell  = notifi.superview?.superview as! WFPublishCell
        
        guard let index =  baseTableView.indexPath(for: cell),
              let dataModel = base_dataList[index.row] as? WFMPArticle else {
            return
        }
        
        let alertController  = UIAlertController(title: "提示信息", message: "确定要删除这篇文章吗？", preferredStyle: .alert)
        
        let action1  = UIAlertAction(title:"确定", style: .default) { (_) in
            
            self.realm.beginWrite()
            self.base_dataList.remove(at: index.row)
            
            guard  let model  = self.realm.object(ofType: MainCaseStoreModel.self, forPrimaryKey:Int(dataModel.keyId)) else{
                return
            }
            self.realm.delete(model)
            try? self.realm.commitWrite()
            self.placeHoderImageV.isHidden = !self.base_dataList.isEmpty
            self.baseTableView.reloadData()

        }
        
        alertController.addAction(action1)
        
        let action2  = UIAlertAction(title:"取消", style: .cancel) { (_) in
            
        }
        alertController.addAction(action2)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
