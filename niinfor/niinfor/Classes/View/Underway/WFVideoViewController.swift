//
//  WFVideoViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import MJRefresh

class WFVideoViewController: BaseViewController {
    
    var eareString  = ""
    var specialString  = ""
    var hospitalString  = ""
    var otherString  = ""
    var timeString  = ""
    
    var isSelectedTime  = false
    
    ///是否是精彩录播
    var isRecored = true
    ///预告的page页
    var prePage = 1
    
    
    @IBOutlet weak var eareBtnView: UIButton!
    @IBOutlet weak var timeBtnView: UIButton!
    
    @IBOutlet weak var sectaableViewHeightCons: NSLayoutConstraint!
    
    ///lineView leading
    @IBOutlet weak var lineViewLeadingCons: NSLayoutConstraint!
    
    @IBOutlet weak var backView: UIView!
    
    
    
    
    ///时间选择
    lazy var chooseView  : WFChooseDateView = {
        
        let v = WFChooseDateView.chooseView(UIScreen.main.bounds)
        
        let cleader = Calendar(identifier: .gregorian)
        let current = Date()
        var compas = DateComponents()
        compas.year = -4
        
        let minidate = cleader.date(byAdding: compas, to: current)

        v.datePicker.minimumDate = minidate
        v.datePicker.maximumDate = current
        
        UIApplication.shared.delegate?.window??.addSubview(v)
        
        return v
    }()
    
    lazy var meetingTimeSelected : WFMeetingSelectedView = {
        
        let v = WFMeetingSelectedView.selectedTimeView(UIScreen.main.bounds)
        
        UIApplication.shared.delegate?.window??.addSubview(v)
        
        return v
    }()

    
    var tableViewDataList  = [WFMeetingModel](){
        didSet{
            
            self.recordTableView.reloadData()
            
            var tableViewHeight  : CGFloat = 0
            
            for item  in tableViewDataList {
                
                tableViewHeight = tableViewHeight + item.cellHeight
            }
            
            if tableViewHeight < Screen_height - 100 {
                tableViewHeight = Screen_height - 100
            }
            
            self.sectaableViewHeightCons.constant = tableViewHeight
            
            self.scrollView.layoutIfNeeded()
            
            self.scrollView.addSubview(emptyView)
            //修改 原来是200
            emptyView.frame = CGRect(x: 0, y: self.recordTableView.xf_Y, width: Screen_width, height: Screen_height - 100 )
            
            self.emptyView.isHidden = tableViewDataList.count != 0
        }
    }
    
    ///录播列表
    var recoredList = [WFMeetingModel]()
    
    ///精彩预告列表
    var prePlayingList = [WFMeetingModel]()
    
    ///省份列表
    var provenceList = [WFEducationModel]()
    
    ///综合列表
    var compreHesiveList = [WFEducationModel]()

    ///医院列表
    var hospitalList = [WFEducationModel]()

    ///公司列表
    var companyList = [WFEducationModel]()

    /// 地区视图
    lazy var eareView : WFEareMainView  = WFEareMainView.eareMainView(
        CGRect(x: 0,
               y: 108,
               width: Screen_width,
               height: Screen_height - 108))
    
    /// 选择其他的视图
    lazy var selctTableView : WFSelectTableView = WFSelectTableView.selectView(
        CGRect(x: 0,
               y: 108,
               width: Screen_width,
               height: Screen_height - 108), style: .SelectStyleOnlyText)
    
    /// 地区按钮
    @IBOutlet weak var eareBtn: UIButton!
    /// 地区按钮点击
    @IBAction func eareBtnClick(_ sender: Any) {
        selctTableView.isHidden = true
        
        let sender = sender as! UIButton
        
        eareView.isHidden = !eareView.isHidden
        
        sender.isSelected = true
        
        if eareView.isHidden == true   {
            //sender.isSelected = !sender.isSelected
        }
    }
    
    /// 专科点击
    @IBAction func officialBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
             sender.isSelected =  true //!sender.isSelected
    
        tiemChoose()
        
//        selctTableView.dataList = compreHesiveList
//        if selctTableView.selectStyle != .SelectStyleOnlyText {
//    
//            selctTableView.selectStyle = .SelectStyleOnlyText
//            selctTableView.isHidden = false
//        }else{
//                 selctTableView.isHidden = !selctTableView.isHidden
//        }
//        eareView.isHidden = true

        }
    
    /// 医院点击
    @IBOutlet weak var hospitalBtn: UIButton!
    @IBAction func hospitalBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
        sender.isSelected = true //!sender.isSelected
        
        if selctTableView.selectStyle != .SelectStyleHopital {

            selctTableView.dataList = hospitalList
            selctTableView.selectStyle = .SelectStyleHopital
            selctTableView.isHidden = false
        }else{

            selctTableView.isHidden = !selctTableView.isHidden}
//        selctTableView.isHidden = !sender.isSelected
        eareView.isHidden = true
    }
    
    /// 公司点击
    @IBOutlet weak var companyBtn: UIButton!
    @IBAction func companyBtnClick(_ sender: Any) {
        
        let sender = sender as! UIButton
        sender.isSelected = true //!sender.isSelected
        
        //selctTableView.isHidden = !selctTableView.isHidden//false
        if selctTableView.selectStyle != .SelectStyleCompany {
            selctTableView.selectStyle = .SelectStyleCompany
            selctTableView.dataList = companyList
            selctTableView.isHidden = false
        }else{
            selctTableView.isHidden = !selctTableView.isHidden
        }
        eareView.isHidden = true
    }

    

    @IBOutlet weak var scrollView: UIScrollView!
    
    /// 正在直播的view
    @IBOutlet weak var playingListView: WFPlayingVideoView!
    
    @IBOutlet weak var recordTableView: UITableView!
    
    @IBOutlet weak var btnViewTopCons: NSLayoutConstraint!
    /// 按钮的contentView
    @IBOutlet weak var btnView: UIView!

    /// 滑动线视图
    @IBOutlet weak var lineView: UIImageView!
    
    /// 会议预告按钮
    @IBOutlet weak var foreshowMeetingBtn: UIButton!
    
    /// 历史会议按钮
    @IBOutlet weak var historyMeetingBtn: UIButton!
    
    /// 精彩录播点击
    @IBAction func foreshowMeetingClick(_ sender: Any) {
        
        if foreshowMeetingBtn.isSelected == true {
            return
        }
        
        isRecored = true
        tableViewDataList = recoredList
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected
        
        //动画
      //  UIView.animate(withDuration: 0.5) {
            lineViewLeadingCons.constant =  (Screen_width - 179.0 / 1000.0 * Screen_width - 128 ) / 2
//            var viewFrame = self.lineView.frame
//            viewFrame.origin.x = self.foreshowMeetingBtn.xf_X
//            self.lineView.frame = viewFrame
// }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = wkWebView.canGoBack
        
    }

    
    /// 直播预告点击
    @IBAction func historyMeetingClick(_ sender: Any) {
        
        ///如果是当下选择的按钮的话返回
        if historyMeetingBtn.isSelected == true {
            return
        }
        
        isRecored = false
        tableViewDataList = prePlayingList
        ///切换按钮状态
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected

        //self.lineViewLeadingCons.constant = (1 - 179.0 * 3 / 1000.0) * Screen_width / 2 + (179.0 * 2 / 1000.0) * Screen_width

        lineViewLeadingCons.constant =  Screen_width / 2  +  (179.0 / 1000.0 * Screen_width ) / 2
        
    }
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_little_meeting_number), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_eraeBtn_click), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_selectTable_click), object: nil)
        
        lineView.removeObserver(self, forKeyPath: "frame")
        
        wkWebView.removeObserver(self, forKeyPath: "canGoBack")
    }
}


// MARK: - 设置界面
extension WFVideoViewController{
    
    func begainFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = true
        
    }
    
    func endFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = false
        
        UIScreen.rotationScreen()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if  (keyPath ?? "") == "frame" {
             let change = change?[NSKeyValueChangeKey.newKey] as? CGRect
            //print("这个是说的什么呢",change ?? 0)
        }
        
        if keyPath == "canGoBack" {
            
            let change = change?[NSKeyValueChangeKey.newKey] as? Bool
            print("*******")
            print(change)
            print(wkWebView.backForwardList.backList.count)
            self.tabBarController?.tabBar.isHidden = change!
            
            change! ? (self.leftItem()) : (setLeftItem())
        }
        if keyPath == "title" {
           self.title = self.wkWebView.title
        }
    }
    
    private func setLeftItem() {
        
        self.navItem.leftBarButtonItems = []
        self.title = "直录播"
    }

    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        
        scrollView.delegate = self
        
        lineView.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        
        ///加载直播预告接口
        loadmeetingLivetrailerData()
        
        setUpTableView()
        setUpForeshowBtn()
        
        ///设置lineView
        lineViewLeadingCons.constant =  (Screen_width - 179.0 / 1000.0 * Screen_width - 128 ) / 2
        //view.addSubview(eareView)
        //view.addSubview(selctTableView)
        
        UIApplication.shared.delegate?.window??.addSubview(eareView)
        UIApplication.shared.delegate?.window??.addSubview(selctTableView)
        
        selctTableView.isHidden = true
        eareView.isHidden = true
        
        ///记录一下btn的frame
        btnSpace = (eareBtn.titleLabel?.xf_X ?? 0) - 20.5
        
        scroviewAddRefresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(tableViewClick), name: NSNotification.Name(rawValue: notifi_selectTable_click), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(eareBtnLoadDate), name: NSNotification.Name(rawValue: notifi_eraeBtn_click), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadLitterMeetinng(_:)), name: NSNotification.Name(rawValue: notifi_little_meeting_number), object: nil)
        
        ///新添加的监听
        NotificationCenter.default.addObserver(self, selector: #selector(begainFullScreen), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
        
        setRightItem()
        
        setUpWkView()
        
        wkWebView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
    }
    
    ///网页视图
    func setUpWkView(){
        
        wkWebView = WFWkWebView(CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height - navigation_height))

        wkWebView.mainController = self
        
        if #available(iOS 11, *) {
            
           self.wkWebView.scrollView.contentInsetAdjustmentBehavior = .never
        }
        
//        wkWebView.scrollView.mj_header  = MJRefreshNormalHeader(refreshingBlock: {
//
//            self.wkWebView.reload()
//            
//        })
        
        
        guard let url  = URL(string:Photo_Path + "/meeting/meetingDirectRecording.jspx") else{
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        _ = wkWebView.load(request)

//        wkWebView.load(URLRequest(url: url))
        view.addSubview(wkWebView)
//        guard let data = try? Data.init(contentsOf: url) else {
//            return
//        }
//        let respones = URLResponse.init(url: url, mimeType: "text/html", expectedContentLength: 0, textEncodingName: "UTF-8")
//        //42363
//
//        let cacheRespones = CachedURLResponse.init(response: respones, data: data)
//        URLCache.shared.storeCachedResponse(cacheRespones, for: request)

    }
    
    ///设置左边的 按钮
    func leftItem () {
        
        let item  = UIBarButtonItem(imageString: "nav_icon_back", target: self, action: #selector(popToParent), isBack: true)
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        
        navItem.leftBarButtonItems = [spaceItem,item]
        
    }
    
    ///
    func popToParent() {
        
        let item = wkWebView.backForwardList.backItem
        wkWebView.go(to: item!)
        
    }
    
    func loadWebViewHid() {
        wkWebView.reload()
    }
    
    func backForword() {
        
        if wkWebView.canGoBack == true  {
            wkWebView.go(to: wkWebView.backForwardList.backItem!)
        }
        
    }
    
    ///完成按钮
    private func setRightItem(){
        
        let btn  = UIButton.cz_textButton("分享", fontSize: 15, normalColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), highlightedColor: UIColor.white)
        btn?.addTarget(self, action: #selector(shareViewClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn!)
        
    }
    
    @objc  private func shareViewClick() {
        
        let block : ([String])->()  = {[weak self] (array) in
            
            AppDelegate.shareUrl((self?.wkWebView.shareUrl)!,
                                 imageString: array[1],
                                 title: self?.wkWebView.title ?? "",
                                 descriptionString: array[0],
                                 viewController: self!, .wechatSession)
            
        }
        
        wkWebView.requireShareDetail(block: block)
        
    }

    
//  @objc  private func shareViewClick() {//Photo_Path + "/meeting/meetingDirectRecording.jspx",
//
//    AppDelegate.shareUrl(wkWebView.shareUrl,
//                                        imageString: "24321528943095_.pic",
//                                        title: navItem.title ?? "",
//                                        descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范",
//                                        viewController: self, .wechatSession)
//
//    }
    
    
    func tiemChoose () {
      
          rightItmClick()
    }
    
    @objc private func rightItmClick() {
        
        
//        chooseView.isHidden = false
        isSelectedTime = false
//        chooseView.currentTimer = {(title)->() in
//            self.timeString = title
//            self.isSelectedTime = true
//            self.selectedSearchBtnLoadData()
//        }

        meetingTimeSelected.isHidden = false
        meetingTimeSelected.ensureSelectTime = {(title)->() in
        
            
            self.timeString = title
            self.isSelectedTime = true
            self.selectedSearchBtnLoadData()
            
            var message : NSString  = title as NSString
            
            
            if title == "" {
                message = "时间"
                self.timeBtnView.setAttributedTitle(NSMutableAttributedString(string: "\(message) ",
                    attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                        UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                    for: .selected)
                
                self.timeBtnView.setAttributedTitle(NSMutableAttributedString(string: "\(message) ",
                    attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                        UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                                    for: .normal)
            }else {
              
                if message.length > 4 {
                    message = "\(message.substring(to: 4)).\(message.substring(from: 5))" as NSString
                }
              
                self.timeBtnView.setAttributedTitle(NSMutableAttributedString(string: "\(message) ",
                    attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                        UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                    for: .selected)
                
                self.timeBtnView.setAttributedTitle(NSMutableAttributedString(string: "\(message) ",
                    attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                        UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                                    for: .normal)
            }
        }
    }
    
    func tableViewClick(_ notifi : Notification) {
        
        if  let dict  = notifi.object as? [String:String] {
           
            switch dict["style"] ?? "" {
            case "1": self.specialString = dict["message"] ?? ""
                           self.selectedSearchBtnLoadData()
            case "2": self.hospitalString = dict["message"] ?? ""
                           self.selectedSearchBtnLoadData()
            case "3": self.otherString = dict["message"] ?? ""
                           self.selectedSearchBtnLoadData()
            default: break
            }
        }
    }
    
    func loadLitterMeetinng(_ notifi : Notification) {
        
        let htString = notifi.object as? String
        
        let vc  = WFVideoDetailController()
        
        vc.htmlString = Photo_Path + (htString ?? "")

        self.navigationController?.pushViewController(vc , animated: true)
    }
    
    ///加载上拉刷新数据
    func loadheadRefreshData() {
        
        isRecored ? self.recoredList.removeAll() : self.prePlayingList.removeAll()
        self.tableViewDataList.removeAll()
        self.loadData()

    }
    
    ///加载上拉刷新下拉加载
    private func scroviewAddRefresh() {
        
//        scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//
//            self.isRecored ? (self.page = 1) : (self.prePage = 1)
//
//            self.loadheadRefreshData()
//        })
//
//        scrollView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//            self.isRecored ? (self.page += 1) : (self.prePage += 1)
//            self.loadFooterData()
//        })
    }

    func eareBtnLoadDate(_ notification : Notification) {
        
        var  message  = notification.object as? NSString
        
        if (message ?? "")  == "全部"{
            message = "地区"
        }
        
        eareBtn.setAttributedTitle(NSMutableAttributedString(string: "\((message?.substring(to: 2) ?? "" ) + " "  )",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                     for: .selected)
       
        eareBtn.setAttributedTitle(NSMutableAttributedString(string: "\((message?.substring(to: 2) ?? "") + " " )",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                   for: .normal)
        
        eareBtnView.setAttributedTitle(NSMutableAttributedString(string: "\((message?.substring(to: 2) ?? "" ) + " "  )",
        attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                   for: .selected)
        
        eareBtnView.setAttributedTitle(NSMutableAttributedString(string: "\((message?.substring(to: 2) ?? "") + " " )",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 17) ??
                UIFont.systemFont(ofSize: 17), NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                   for: .normal)

        
        eareBtn.isSelected = true
        eareView.isHidden = true
        
        eareString = (message ?? "") as String
        
        if eareString == "地区" {
            eareString = ""
        }
        
       selectedSearchBtnLoadData()
    }
    
    ///点击搜索按钮来加载数据
    func selectedSearchBtnLoadData() {
        
        self.isRecored  = true
        self.page = 1
        self.prePage = 1
        
        self.loadheadRefreshData()
    }
    
    /// 设置预告和历史按钮
    private  func setUpForeshowBtn() {
        
        foreshowMeetingBtn.isSelected = true
        foreshowMeetingBtn.setAttributedTitle(NSMutableAttributedString(
            string: "精彩录播",
            attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                              for: .selected)
        
        
        historyMeetingBtn.setAttributedTitle(NSMutableAttributedString(
            string: "直播预告",
            attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                             for: .selected)
        
    }
    
    /// 设置列表视图
    private func setUpTableView() {
        
        recordTableView.tableFooterView = UIView()
        recordTableView.register(UINib.init(nibName: WFRecordVideoCell().identfy,
                                                                     bundle: nil),
                                                                     forCellReuseIdentifier: WFRecordVideoCell().identfy)
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        
        recordTableView.touchesShouldCancel(in: recordTableView)
        
        /// 添加右滑收拾
        let gesture  = UISwipeGestureRecognizer(target: self,
                                                action: #selector(gesterClick(gesture:)))
        recordTableView.addGestureRecognizer(gesture)
        
        /// 添加左滑收拾
        let gestureLeft  = UISwipeGestureRecognizer(target: self,
                                                    action: #selector(gesterClick(gesture:)))
        
        gestureLeft.direction = .left
        recordTableView.addGestureRecognizer(gestureLeft)
        
    }

}


// MARK: - 数据源代理方法
extension WFVideoViewController{
    
    ///加载数据
    override func loadData() {
        
        if isSelectedTime == false  {
            timeString = ""
        }
        
        loadProvenceData()
        loadMeetingSpecialData()
//        loadMeetingSpecialData()
        loadMeetingPlayingData()
        loadHostpitalData()
        loadOther()
        isRecored ? loadRecoredPlayingData() : loadmeetingLivetrailerData()
        
    }
    
    ///加载省份列表
    private func loadProvenceData() {
        
        NetworkerManager.shared.meetingProvinceList { (isSuccess, json) in
            
            if isSuccess == true {
                
                self.provenceList.removeAll()
                self.eareView.dataList.removeAll()
                let model = WFEducationModel()
                model.name = "全部"
                
                self.provenceList.append(model)
                self.provenceList = self.provenceList + json
                
                self.eareView.dataList.append(model)
                self.eareView.dataList = self.eareView.dataList + json
                
//                self.provenceList = json
//                self.eareView.dataList = json
            }
        }
    }
    
    ///加载会议专科列表
    private func loadMeetingSpecialData() {
        
        NetworkerManager.shared.getMeetingSpecialites{ (isSuccess, json) in
            
            if isSuccess == true {
              
                self.compreHesiveList.removeAll()
                let model = WFEducationModel()
                     model.name = "全部"
                
                self.compreHesiveList.append(model)
                self.compreHesiveList = self.compreHesiveList + json
            }
        }
    }
    
    ///加载医院
   private func loadHostpitalData() {
    
    NetworkerManager.shared.hospital { (isSuccess, json) in
        if isSuccess == true {
            
            self.hospitalList.removeAll()
            let model = WFEducationModel()
            model.name = "全部"
            self.hospitalList.append(model)
            self.hospitalList = self.hospitalList + json

        }
    }
    
    }
    ///加载其他
   private func loadOther() {
    
     NetworkerManager.shared.other { (isSuccess, json) in
        if isSuccess == true {
            
            self.companyList.removeAll()
            let model = WFEducationModel()
                 model.name = "全部"
            self.companyList.append(model)
            self.companyList = self.companyList + json

        }
    }
    }
    
    ///加载直播列表
    private func loadMeetingPlayingData() {
    
        let params  = ["otherId" : otherString ,
                                "province" : eareString ,
                                 "speciality" : specialString,
                                 "dateStr" : timeString,
                                 "hospitalId" : hospitalString]
        
        
        NetworkerManager.shared.getMeetingLive(params){ (isSuccess, json) in
            
            if  isSuccess == true {
                self.playingListView.dataList = json
                ///刷新界面
                self.scrollView.layoutIfNeeded()
            }
        }
    }
    
    ///加载精彩录播列表 meetingLivetrailer
    private func loadRecoredPlayingData() {
        
        let params  = ["otherId" : otherString ,
                       "pageNo" : "\(page)" ,
            "pageSize" : "5",
            "province" : eareString ,
            "speciality" : specialString,
            "dateStr" : timeString,
            "hospitalId" : hospitalString]

        
        NetworkerManager.shared.meetingRecording(params) { (isSuccess, json) in
            
            if  isSuccess == true {
                
                self.recoredList =  self.recoredList + json
                
                self.tableViewDataList = self.recoredList
                
                if self.page == 1 && json.count == 0{
                    self.tableViewDataList = []
                }
            }
            //self.scrollView.endFresh()
        }
    }
    
    ///加载直播预告列表
     func loadmeetingLivetrailerData(){
        
        let params  = ["otherId" : otherString ,
            "pageNo" : "\(page)" ,
            "pageSize" : "5",
            "province" : eareString ,
            "speciality" : specialString,
            "dateStr" : timeString,
            "hospitalId" : hospitalString]
        
        NetworkerManager.shared.meetingLivetrailer(params) { (isSuccess, json) in
            
            if  isSuccess == true {
                self.prePlayingList =  self.prePlayingList + json
                self.tableViewDataList = self.prePlayingList
                
                if self.prePage == 1 && json.count == 0{
                    self.tableViewDataList = []
                }
            }
            //self.scrollView.endFresh()
        }
    }
    
    ///下拉加载数据
    func loadFooterData() {
        isRecored ? loadRecoredPlayingData() : loadmeetingLivetrailerData()
    }
}


// MARK: - 数据源代理方法
extension WFVideoViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFRecordVideoCell().identfy, for: indexPath) as? WFRecordVideoCell
        
        cell?.model = tableViewDataList[indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableViewDataList[indexPath.row].cellHeight
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = WFVideoDetailController()
        vc.title = "直录播"
        vc.htmlString = Photo_Path + (tableViewDataList[indexPath.row].meetingUrl ?? "")
        navigationController?.pushViewController(vc, animated: true )
        
    }
    
}

// MARK: - 监听的方法
extension WFVideoViewController{
    
    
    // MARK: - 手势监听方法
    @objc func gesterClick(gesture : UISwipeGestureRecognizer){
        
        if gesture.direction == .right && historyMeetingBtn.isSelected == true {
            
            foreshowMeetingClick(self)
            print("往左滑")
            
        }
        
        if gesture.direction == .left  {
            
            historyMeetingClick(self)
            
            print("往又滑")
        }
        
    }
    
}

// MARK: - UIScrowView代理方法
extension WFVideoViewController{
    
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
      
            
        let lastNumber : CGFloat =  playingListView.playingViewHeightCons.constant
        let number : CGFloat =  lastNumber  + 10 + 44
        //189
        
        if scrollView.contentOffset.y >= number  {

            let scrowY = scrollView.contentOffset.y
            btnViewTopCons.constant  =  scrowY -  number + 10
            btnView.layoutIfNeeded()

        }else{
            btnViewTopCons.constant  = 10
        }
     }
}
/**/

