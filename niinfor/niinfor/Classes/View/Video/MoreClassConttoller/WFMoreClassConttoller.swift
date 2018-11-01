//
//  WFMoreClassConttoller.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/25.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFMoreClassConttoller: BaseViewController {
    fileprivate var collectionView : UICollectionView?
    fileprivate let backView = UIView.init()
    fileprivate let reuseView = UIButton.init()
    fileprivate let complictView = UIButton.init()
    fileprivate let no_content_imagV = UIImageView()
    
    var  isFreeClass = true
    
    var classId  = ""
    
    var tagId = ""{
        didSet{
            base_dataList.removeAll()
            
            var indexP = 0
            
            if collectionArray[0].isEmpty || collectionArray[1].isEmpty {
                return
            }

            for (index,model) in collectionArray[1].enumerated() {
                if "\(model.id)" == tagId{
                   indexP = index
                }
            }
            let indexPath  = IndexPath.init(row: indexP, section: 1)
            
            guard let lastCell = collectionView?.cellForItem(at: selectArray[1]) as? WFMoreCollectionViewCell,
                let currentCell = collectionView?.cellForItem(at: indexPath) as? WFMoreCollectionViewCell
                else {
                    return
            }
            
            lastCell.setSelect(false , collectionArray[selectArray[indexPath.section].section][selectArray[indexPath.section].row].name)
            currentCell.setSelect(true , collectionArray[indexPath.section][indexPath.row].name)
            selectArray[indexPath.section] = indexPath
            loadData()
        }
    }
    
    fileprivate var collectionArray = [[TagModel](),
                                       [TagModel](),
                                       [        {()->TagModel in
                                        let model = TagModel()
                                        model.id = 0
                                        model.name = "默认"
                                        return model
                                        }(),
                                               {()->TagModel in
                                            let model = TagModel()
                                            model.id = 1
                                            model.name = "最新发布"
                                            return model
                                        }(),
                                               {()->TagModel in
                                                let model = TagModel()
                                                model.id = 2
                                                model.name = "最多播放"
                                                return model
                                        }()]]
    fileprivate var selectArray  = [IndexPath.init(item: 0, section: 0),
                                    IndexPath.init(item: 0, section: 1),
                                    IndexPath.init(item: 0, section: 2)]
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

//selector
extension WFMoreClassConttoller{
    @objc func rightItemClick() {
        hiddenViewWithAnamation(!backView.isHidden)
    }
    
    @objc func reumeClick() {
        selectArray = [IndexPath.init(item: 0, section: 0),
                       IndexPath.init(item: 0, section: 1),
                       IndexPath.init(item: 0, section: 2)]
        collectionView?.reloadData()
    }
    @objc func complictClick() {
        //刷新数据
        page = 1
        base_dataList.removeAll()
        loadData()
        hiddenViewWithAnamation(!backView.isHidden)
    }
    @objc func tapGesture() {
        hiddenViewWithAnamation(!backView.isHidden)
    }
    
    fileprivate func hiddenViewWithAnamation(_ isHidden : Bool){
        
        if isHidden == true{
            
            collectionView?.snp.remakeConstraints({ (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalToSuperview().offset(-(collectionView?.contentSize.height)! - 75)
                maker.height.equalTo((collectionView?.contentSize.height)! + 15)
            })
            
            UIView.animate(withDuration: 0.5, animations: {
                self.view?.layoutIfNeeded()
                self.backView.subviews[0].alpha = 0.01
            }) { (isTrue) in
                self.backView.isHidden = true
            }
            
        }else{
            collectionView?.snp.remakeConstraints({ (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalToSuperview().offset(navigation_height)
                maker.height.equalTo((collectionView?.contentSize.height)! + 15)
            })
            self.backView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.view?.layoutIfNeeded()
                self.backView.subviews[0].alpha = 0.6
            }) { (isTrue) in
               
            }
        }
    }
}

extension WFMoreClassConttoller{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  vc  = WFNewVideoViewController()
        if let model  = base_dataList[indexPath.row] as? WFFreeClassModel {
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
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WFRecommandTableViewCell().identfy, for: indexPath) as? WFRecommandTableViewCell
        if let model = base_dataList[indexPath.row] as? WFFreeClassModel {
            cell?.configModel(model)
        }
        return cell!
    }
}

extension WFMoreClassConttoller : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:WFMoreCollectionViewCell().identfy  , for: indexPath) as? WFMoreCollectionViewCell
        
        cell?.setTitle(collectionArray[indexPath.section][indexPath.row].name)
        
        if indexPath.row == selectArray[indexPath.section].row{
            cell?.setSelect(true, collectionArray[indexPath.section][indexPath.row].name)
        }else{
            cell?.setSelect(false, collectionArray[indexPath.section][indexPath.row].name)
        }

        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader{
            let v =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WFHeaderCollectionReusableView", for: indexPath) as? WFHeaderCollectionReusableView
            
            switch indexPath.section {
            case 0 : v?.setTitle("亚专业")
            case 1 : v?.setTitle("热门标签")
            case 2 : v?.setTitle("排列方式")
            default : break
            }
            return v!
        }else{
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == selectArray[indexPath.section].row {
            return
        }
        
        guard let lastCell = collectionView.cellForItem(at: selectArray[indexPath.section]) as? WFMoreCollectionViewCell,
              let currentCell = collectionView.cellForItem(at: indexPath) as? WFMoreCollectionViewCell
            else {
            return
        }
        
        lastCell.setSelect(false , collectionArray[selectArray[indexPath.section].section][selectArray[indexPath.section].row].name)
        currentCell.setSelect(true , collectionArray[indexPath.section][indexPath.row].name)
        selectArray[indexPath.section] = indexPath
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionArray[section].count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
}

extension WFMoreClassConttoller{
    
    override func loadData() {
        
        if collectionArray[0].isEmpty || collectionArray[1].isEmpty {
            return
        }
        let specialityId = collectionArray[0][selectArray[0].row].id == -1 ? "" : "\(collectionArray[0][selectArray[0].row].id)"
        let tagId =  collectionArray[1][selectArray[1].row].id == -1 ? "" : "\(collectionArray[1][selectArray[1].row].id)"
        let orderId = "\(collectionArray[2][selectArray[2].row].id)"
        let pageNo  = "\(self.page)"
        
        if title == "相关课程"  {
            loadCurrentClassList(specialityId,tagId,orderId,classId, pageNo)
        }else if title == "推荐课程"{
            loadRecommandList(specialityId,tagId,orderId,pageNo)
        }else if title == "最新课程"{
            loadFreeClassList(specialityId,tagId,orderId,pageNo)
        }else{
            loadTagClassList(tagId, pageNo)
        }
    }
    
    func loadRecommandList(_ specialityId : String ,_ tagId : String ,_ order : String ,_ pageNo : String) {
        NetworkerManager.shared.getRecommendCoursePage(specialityId, tagId, order, pageNo) { (isSuccess, jsonArray) in
            if isSuccess == true{
                self.base_dataList = self.base_dataList + jsonArray
                self.no_content_imagV.isHidden = !self.base_dataList.isEmpty
            }
        }
    }
    
    func loadFreeClassList(_ specialityId : String ,_ tagId : String ,_ order : String ,_ pageNo : String) {
        NetworkerManager.shared.getFreeCoursePage(specialityId, tagId, order, pageNo) { (isSuccess, jsonArray) in
            if isSuccess == true{
                self.base_dataList = self.base_dataList + jsonArray
                self.no_content_imagV.isHidden = !self.base_dataList.isEmpty
            }
        }
    }
    
    func loadCurrentClassList(_ specialityId  : String ,_ tagId : String,_ order : String ,_ courseId : String ,_ pageNo : String ) {
        NetworkerManager.shared.getCurrentCoursePage(specialityId, tagId, order, classId, pageNo) { (isSuccess, jsonArray) in
            if isSuccess == true{
                self.base_dataList = self.base_dataList + jsonArray
                self.no_content_imagV.isHidden = !self.base_dataList.isEmpty
            }
        }
    }
    
    func loadTagClassList(_ tagId  : String ,_ pageNo : String) {
        NetworkerManager.shared.getCourseListByTag(tagId, pageNo) { (isSuccess, jsonArray) in
            if isSuccess == true{
                self.base_dataList = self.base_dataList + jsonArray
                self.no_content_imagV.isHidden = !self.base_dataList.isEmpty
            }
        }
    }

    
    func loadCollectionViewData() {
        NetworkerManager.shared.getHotTags { (isSuccess, jsonArray) in
            if isSuccess == true{
                let model = TagModel.init()
                model.name = "全部"
                model.id = -1
                self.collectionArray[1] = jsonArray
                self.collectionArray[1].insert(model, at: 0)
                
                var indexP = 0
                for (index,model) in self.collectionArray[1].enumerated() {
                    if "\(model.id)" == self.tagId{
                        indexP = index
                    }
                }
                self.selectArray[1] = IndexPath.init(row: indexP, section: 1)
                self.collectionView?.reloadData()
                if self.collectionArray[0].isEmpty == false{
                     self.loadData()
                }
            }
        }
        
     NetworkerManager.shared.getSpeclities { (isSuccess, jsonArray) in
            if isSuccess == true{
                let model = TagModel.init()
                model.name = "全部"
                model.id = -1
                self.collectionArray[0] = jsonArray
                self.collectionArray[0].insert(model, at: 0)
                self.collectionView?.reloadData()
                if self.collectionArray[1].isEmpty == false{
                    self.loadData()
                }
            }
        }
    }

}

extension WFMoreClassConttoller{
    override func setUpUI() {
        super.setUpUI()
        
        baseTableView.register(WFRecommandTableViewCell.self, forCellReuseIdentifier: WFRecommandTableViewCell().identfy)
        
        setNavigationBar()
        setCollectionView()
        setBackAndBtnView()
        
        view.insertSubview(baseTableView, belowSubview: backView)
        
        no_content_imagV.image = #imageLiteral(resourceName: "no_content")
        no_content_imagV.contentMode = .scaleAspectFit
        baseTableView.addSubview(no_content_imagV)
        
        no_content_imagV.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }

        
        ///加载数据
        loadCollectionViewData()
        
        
    }
    
    func setNavigationBar() {
        
        let btn = UIButton.cz_textButton("筛选", fontSize: 15, normalColor: UIColor.black, highlightedColor: UIColor.black)
        
        btn?.addTarget(self, action: #selector(rightItemClick), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: btn!)
        navItem.rightBarButtonItem = rightItem
    }
    
    func setBackAndBtnView() {
        
        
        view.insertSubview(reuseView, belowSubview: navBar)
        view.insertSubview(complictView, belowSubview: navBar)
        
        
        backView.backgroundColor = UIColor.clear
        let bacimage  = UIImageView.init()
        backView.addSubview(bacimage)
        bacimage.backgroundColor = UIColor.black
        bacimage.alpha = 0.5
        backView.isHidden = true
        
        backView.snp.makeConstraints { (maker ) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(navigation_height)
        }
        bacimage.snp.makeConstraints { (maker ) in
            maker.top.left.right.bottom.equalToSuperview()
        }
        
        backView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGesture)))
        
        reuseView.setAttributedTitle(NSAttributedString.init(string: "重置", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]), for: .normal)
        complictView.setAttributedTitle(NSAttributedString.init(string: "完成", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16), NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]), for: .normal)
        reuseView.backgroundColor = UIColor.white
        complictView.backgroundColor = UIColor.white
        
        reuseView.layer.borderWidth = 0.5
        reuseView.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        complictView.layer.borderWidth = 0.5
        complictView.layer.borderColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

        reuseView.addTarget(self, action: #selector(reumeClick), for: .touchUpInside)
        complictView.addTarget(self, action: #selector(complictClick), for: .touchUpInside)
        
        reuseView.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().multipliedBy(0.5).offset(1)
            maker.left.equalToSuperview().offset(-1)
            maker.top.equalTo(collectionView!.snp.bottom)
            maker.height.equalTo(45)
        }
        complictView.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().multipliedBy(0.5).offset(1)
            maker.right.equalToSuperview().offset(1)
            maker.top.equalTo(collectionView!.snp.bottom)
            maker.height.equalTo(45)
        }

    }
    
    func setCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        if #available(iOS 10.0, *) {
            layout.itemSize = UICollectionViewFlowLayoutAutomaticSize
            layout.estimatedItemSize = CGSize.init(width: 68, height: 25)
        } else {
            // Fallback on earlier versions
        }
        
        layout.headerReferenceSize = CGSize.init(width: Screen_width - 30, height: 30)
        layout.footerReferenceSize = CGSize.init(width:0, height: 0)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        
        
        collectionView = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.contentInset = UIEdgeInsetsMake(0, 15, 0, 15)
        
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.register(WFMoreCollectionViewCell.self, forCellWithReuseIdentifier: WFMoreCollectionViewCell().identfy)
        collectionView?.register(WFHeaderCollectionReusableView.self , forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "WFHeaderCollectionReusableView")

        view.insertSubview(collectionView!, belowSubview: navBar)
        view.insertSubview(backView, belowSubview: collectionView!)
        
        collectionView?.snp.makeConstraints({ (maker) in
            maker.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(-1000)
            maker.height.equalTo(300)
        })
    }
}













