//
//  WFVideoSlideView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/19.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

protocol WFSlideViewClickProtocol {
    func clickChangeVideo(_ vid : String, _ classID : String)
    func currentBtnClick(_ vid : String, _ classID : String)
}

class WFVideoSlideView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }
    
    var className = ""
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var delegate : WFSlideViewClickProtocol?
    
    var lineViewWidth : CGFloat {
        return ("精品课堂" as NSString).boundingRect(with: CGSize.init(width: 1000, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)], context: nil).size.width
    }
    
    fileprivate var lastSelectNumber = 0//上次选择的按钮
    fileprivate var lineView         = UIView.init()
    var classSegmentView = UISegmentedControl.init(items: ["课程资料","课程选集","课程评价"])
    var mainScrollView   = UIScrollView.init()
    fileprivate let no_coment_imageV = UIImageView.init()
    
    fileprivate var firsetTableView  = UITableView.init(frame: CGRect.zero, style: .plain)
    fileprivate var secondTableView  = UITableView.init(frame: CGRect.zero, style: .grouped)
    var thirdTableView   = UITableView.init(frame: CGRect.zero, style: .grouped)
    fileprivate var commentBtnView   = UIButton.init()
    var detailModel = WFDetailVideoModel(){
        didSet{
            firsetTableView.reloadData()
        }
    }
    
    var videoClassListModel  : WFVideoClassModel = WFVideoClassModel(){
        didSet{
            secondTableView.reloadData()
        }
    }
    
    var commantModel : [WFCommentListModel]  = []{
        didSet{
            no_coment_imageV.isHidden = !commantModel.isEmpty
            thirdTableView.reloadData()
        }
    }
    var currentClass : [WFFreeClassModel] = []{
        didSet{
            secondTableView.reloadRows(at: [IndexPath.init(row: 0, section: 1)], with: .none)
        }
    }
    
    var classId : String = ""{
        didSet{
            loadIsCoomentClass()
        }
    }
}

//private Func
extension WFVideoSlideView{

    fileprivate func loadIsCoomentClass() {
        NetworkerManager.shared.isUserComment(classId) { (isSuccess, isComment) in
            if isSuccess {
                self.thirdTableView.snp.updateConstraints { (maker) in
                    maker.top.width.equalToSuperview()
                    maker.bottom.height.equalToSuperview().offset(isComment ? 0 : -44)
                    maker.left.equalTo(self.secondTableView.snp.right)
                    maker.right.equalToSuperview()
                }
                self.mainScrollView.layoutIfNeeded()
            }
        }
    }
}

//private Func
extension WFVideoSlideView{
    
    @objc fileprivate func slideBtnCLick(_ btn : UISegmentedControl) {
          print(btn.selectedSegmentIndex)
        
        if lastSelectNumber == btn.selectedSegmentIndex {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
             self.mainScrollView.contentOffset = CGPoint.init(x: Screen_width * CGFloat(btn.selectedSegmentIndex), y: 0)
        }
        
        lineViewAnimation(btn.selectedSegmentIndex)
        
        lastSelectNumber = btn.selectedSegmentIndex
    }
    
    fileprivate func setBtn(_ btn : UIButton,_ title : String)-> UIButton{
        
        btn.setAttributedTitle(NSMutableAttributedString(string: title,
                                                         attributes: [NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size:    13) ??
                                                                     UIFont.systemFont(ofSize: 16)
                                                         ,NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]),
                                                          for: .normal)
        
        btn.setAttributedTitle(NSMutableAttributedString(string: title,
                                                         attributes: [NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size:    13) ??
                                                            UIFont.systemFont(ofSize: 16)
                                                            ,NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]),
                                                          for: .selected)
        btn.addTarget(self, action: #selector(slideBtnCLick(_:)), for: .valueChanged)
        
        return btn
    }
    
    
    fileprivate  func lineViewAnimation(_ number : Int){
        
        lineView.snp.updateConstraints { (maker) in
            maker.centerX.equalTo(Screen_width / 6.0 + (CGFloat(number) * Screen_width / 3.0 ))
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }

    }
    
    @objc fileprivate func commentBtnPushClick(_ btn : UIButton){
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
        var nextView = self.superview
        while nextView != nil  {
            let nextResponder = nextView?.next
            if (nextResponder?.isKind(of: UIViewController.self))!{
                let vc = WFClassCommentViewController()
                vc.isShowBack = true
                let nav  = WFNavigationController.init(rootViewController: vc)
                vc.classID = "\(detailModel.course.id)"
                vc.parentId = ""
                (nextResponder as! UIViewController).present(nav , animated: true, completion: nil)
                return
            }else {
                nextView = nextView?.superview
            }
        }
    }
}
//UI
extension WFVideoSlideView{
   fileprivate func setUpUI() {
        addSubView()
        setConstraint()
        setMainScrollerView()
    }
   fileprivate func addSubView() {
        backgroundColor = UIColor.white
    
        addSubview(classSegmentView)
        setClassView()
    
        lineView.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        addSubview(lineView)

        addSubview(mainScrollView)
    
    }
    
   fileprivate func setConstraint() {
    classSegmentView.snp.makeConstraints { (maker) in
        maker.left.right.top.equalToSuperview()
        maker.height.equalTo(40)
    }
    lineView.snp.makeConstraints { (maker) in
        maker.width.equalTo(lineViewWidth)
        maker.top.equalTo(classSegmentView.snp.bottom)
        maker.height.equalTo(2)
        maker.centerX.equalTo(Screen_width / 6.0)
    }
    
    mainScrollView.snp.makeConstraints { (maker) in
        maker.left.right.bottom.equalToSuperview()
        maker.top.equalTo(lineView.snp.bottom).offset(10)
    }
    }
    
    fileprivate func setClassView() {
        classSegmentView.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size:    13) ??
            UIFont.systemFont(ofSize: 16)
            ,NSForegroundColorAttributeName : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)], for: .normal)
        classSegmentView.setTitleTextAttributes([NSFontAttributeName : UIFont(name: "MicrosoftYaHei", size:    13) ??
            UIFont.systemFont(ofSize: 16)
            ,NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)], for: .selected)
        classSegmentView.isHighlighted = false
        classSegmentView.tintColor = UIColor.white
        classSegmentView.backgroundColor = UIColor.white
        classSegmentView.selectedSegmentIndex = 0
        classSegmentView.addTarget(self, action: #selector(slideBtnCLick(_:)), for: .valueChanged)
    }
}

////mainScrollView
extension WFVideoSlideView{
    fileprivate func setMainScrollerView() {
        mainScrollView.backgroundColor = UIColor.red
        mainScrollView.isPagingEnabled = true
        mainScrollView.bounces = false
        mainScrollView.showsHorizontalScrollIndicator = false
        mainScrollView.delegate = self
        
        setTableView()
    }
    fileprivate func setTableView(){
        mainScrollView.addSubview(firsetTableView)
        mainScrollView.addSubview(secondTableView)
        mainScrollView.addSubview(thirdTableView)
        mainScrollView.addSubview(commentBtnView)
        
        
        firsetTableView.snp.makeConstraints { (maker) in
            maker.left.width.height.top.bottom.equalToSuperview()
        }
        secondTableView.snp.makeConstraints { (maker) in
            maker.top.width.height.bottom.equalToSuperview()
            maker.left.equalTo(firsetTableView.snp.right)
        }
        thirdTableView.snp.makeConstraints { (maker) in
            maker.top.width.equalToSuperview()
            maker.bottom.height.equalToSuperview().offset(-44)
            maker.left.equalTo(secondTableView.snp.right)
            maker.right.equalToSuperview()
        }
        commentBtnView.snp.makeConstraints { (maker) in
            maker.left.right.equalTo(thirdTableView)
            maker.top.equalTo(thirdTableView.snp.bottom)
            maker.bottom.equalToSuperview()
        }
        
        no_coment_imageV.image = #imageLiteral(resourceName: "no_comment")
        no_coment_imageV.contentMode = .scaleAspectFit
        thirdTableView.addSubview(no_coment_imageV)

        no_coment_imageV.snp.makeConstraints { (maker) in
            maker.center.equalToSuperview()
        }
        
        configTalbeView(firsetTableView)
        configTalbeView(secondTableView)
        configTalbeView(thirdTableView)
        
        commentBtnView.clipsToBounds = true
        thirdTableView.bounces = true
        commentBtnView.backgroundColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        commentBtnView.setTitle("我要评价", for: .normal)
        commentBtnView.addTarget(self, action: #selector(commentBtnPushClick(_:)), for: .touchUpInside)
        
        firsetTableView.register(WFFirstTitleTableCell.self, forCellReuseIdentifier: WFFirstTitleTableCell().identfy)
        firsetTableView.register(WFFirstContntLabelCell.self, forCellReuseIdentifier: WFFirstContntLabelCell().identfy)
        firsetTableView.register(WFFirstAuthorMessageCell.self, forCellReuseIdentifier: WFFirstAuthorMessageCell().identfy)

        secondTableView.register(WFSecondTableViewCell.self, forCellReuseIdentifier: WFSecondTableViewCell().identfy)
        secondTableView.register(WFSecondCollectionTableViewCell.self, forCellReuseIdentifier: WFSecondCollectionTableViewCell().identfy)
        
        thirdTableView.register(WFThirdTableViewCell.self, forCellReuseIdentifier: WFThirdTableViewCell().identfy)
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
///评论代理
extension WFVideoSlideView : CommentCellFoldProtocol{
    func clickPeopleNameReply(_ parentString: String, _ cell: WFThirdTableViewCell) {
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
        
        var nextView = self.superview
        
        while nextView != nil  {
            let nextResponder = nextView?.next
            if (nextResponder?.isKind(of: UIViewController.self))!{
                let vc = WFClassCommentViewController()
                vc.isShowBack = true
                let nav  = WFNavigationController.init(rootViewController: vc)
                vc.classID = "\(detailModel.course.id)"
                vc.parentId = "\(parentString)"
                vc.isShowStar = false
                vc.isShowBack = true
                (nextResponder as! UIViewController).present(nav , animated: true, completion: nil)
                return
            }else {
                nextView = nextView?.superview
            }
        }
    }
    
    func priseBtnClick(_ btn: UIButton, _ cell: WFThirdTableViewCell) {
        if NetworkerManager.shared.userCount.isLogon == false {
            var nextView = self.superview
            while nextView != nil  {
                let nextResponder = nextView?.next
                if (nextResponder?.isKind(of: UIViewController.self))!{
                    let vc = WFLoginViewController()
                    let nav = WFNavigationController.init(rootViewController: vc)
                    vc.isShowBack = true
                    (nextResponder as! UIViewController).present(nav , animated: true, completion: nil)
                    return
                }else {
                    nextView = nextView?.superview
                }
            }
        }

        guard let index = thirdTableView.indexPath(for: cell) else { return }
        NetworkerManager.shared.commentDigg("\(commantModel[index.row].id)") { (isSuccess, json ) in
            if isSuccess == true {
                self.commantModel[index.row].isDigg = self.commantModel[index.row].isDigg == "F" ? "T" : "F"
                self.commantModel[index.row].diggs += self.commantModel[index.row].isDigg == "T" ? 1 : -1
                self.thirdTableView.reloadRows(at: [index], with: .none)
            }
        }
    }
    
    func commentBtnClick(_ btn: UIButton, _ cell: WFThirdTableViewCell) {
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

        guard let index = thirdTableView.indexPath(for: cell) else { return }
        
        var nextView = self.superview
        
        while nextView != nil  {
            let nextResponder = nextView?.next
            if (nextResponder?.isKind(of: UIViewController.self))!{
                let vc = WFClassCommentViewController()
                vc.isShowBack = true
                let nav  = WFNavigationController.init(rootViewController: vc)

                vc.classID = "\(detailModel.course.id)"
                vc.parentId = "\(commantModel[index.row].id)"
                vc.isShowStar = false
                vc.isShowBack = true
                (nextResponder as! UIViewController).present(nav , animated: true, completion: nil)
                return
            }else {
                nextView = nextView?.superview
            }
        }
    }
    
    func foldBtnClick(_ btn: UIButton, _ cell: WFThirdTableViewCell) {
         guard let index = thirdTableView.indexPath(for: cell) else { return }
         commantModel[index.row].isFoldComment = !btn.isSelected
         thirdTableView.reloadRows(at: [index], with: .none)
//         thirdTableView.reloadData()
    }
}

///headerDelegate
extension WFVideoSlideView : MoreBtnClickProtocol {
    
    func headerViewMoreBtnClick(_ video: WFVideoHeaderView) {
        if video.title ?? "" == "相关视频" {
            if delegate != nil {
                delegate?.currentBtnClick("", "")
            }
        }
    }
}


///delegate dataSource
extension WFVideoSlideView : UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource{

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == mainScrollView {
            let index  = scrollView.contentOffset.x / Screen_width
            classSegmentView.selectedSegmentIndex = Int(index)
            lineViewAnimation(Int(index))
            self.lastSelectNumber = Int(index)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch tableView {
        case  firsetTableView: return 2 + detailModel.authors.count
        case  secondTableView: return section == 0 ? videoClassListModel.videoList.count : 1
        case  thirdTableView : return commantModel.count
        default: return 4
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch tableView {
        case  firsetTableView:
            if indexPath.row == 0{
              
              let cell = WFFirstTitleTableCell.dequneceTableView(tableView, WFFirstTitleTableCell().identfy, indexPath, detailModel as AnyObject) as? WFFirstTitleTableCell
              cell?.titleLabel.text = className
              return cell!
            }else if indexPath.row == 1{
              return WFFirstContntLabelCell.dequneceTableView(tableView, WFFirstContntLabelCell().identfy, indexPath, detailModel.course.introduction as AnyObject)
            }else{
                return WFFirstAuthorMessageCell.dequneceTableView(tableView, WFFirstAuthorMessageCell().identfy, indexPath, detailModel as AnyObject)
            }
            
        case  secondTableView:
            if indexPath.section == 0{
                return WFSecondTableViewCell.dequneceTableView(tableView, WFSecondTableViewCell().identfy, indexPath, videoClassListModel as AnyObject)
            }else if indexPath.section == 1{
                let cell = WFSecondCollectionTableViewCell.dequneceTableView(tableView, WFSecondCollectionTableViewCell().identfy, indexPath, currentClass as AnyObject) as? WFSecondCollectionTableViewCell
                cell?.currentClass = currentClass
                return cell!
            }
            
        case  thirdTableView :
            
            let cell = WFThirdTableViewCell.dequneceTableView(tableView, WFThirdTableViewCell().identfy, indexPath, commantModel as AnyObject) as? WFThirdTableViewCell
            cell?.delegate = self
            return cell!
        default: return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch tableView {
            
        case secondTableView:
            let headerView = WFVideoHeaderView.init(section == 0 ? "课程目录" : "相关视频", CGRect.init(x: 0, y: 0, width: Screen_width, height: 40),section == 0 ? "课程总时长： \(videoClassListModel.druationString)" : "")
             headerView.delegate = self
             return headerView
            
        case thirdTableView:
            let headerView = WFVideoHeaderView.init("课程评分 \(detailModel.course.score == "" ? "0" : detailModel.course.score)分", CGRect.init(x: 0, y: 0, width: Screen_width, height: 40),"\(detailModel.course.views)次播放")
            return headerView
        default: return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == secondTableView {
            if indexPath.section == 0 {
                //&& videoClassListModel.videoList[indexPath.row].isSelectDownload != true
                for item in videoClassListModel.videoList{
                    item.isDefaultModel = false
                }
                
                videoClassListModel.videoList[indexPath.row].isDefaultModel = true
                secondTableView.reloadData()
                if delegate != nil {
                    delegate?.clickChangeVideo(videoClassListModel.videoList[indexPath.row].vid,"\(videoClassListModel.videoList[indexPath.row].id)")
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch tableView {
        case firsetTableView: return 0.01
        case secondTableView: return 40
        case thirdTableView: return 40
        default: return 0.01
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        switch tableView {
        case firsetTableView: return 1
        case secondTableView: return 2
        case thirdTableView: return 1
        default: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}













