//
//  WFMeetingViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDCycleScrollView
import JavaScriptCore
import WebKit
import ObjectiveC
import MJRefresh

class WFMeetingViewController: BaseViewController,UIWebViewDelegate {


//    var wkWebView = WFWkWebView()
    
    var jsContext : JSContext?
    
    var curUrl = ""
    
    
    
    @IBOutlet weak var webView: UIWebView!
    
    @IBOutlet weak var cyleScrollView: SDCycleScrollView!
    /// 底部视图
    @IBOutlet weak var scroView: UIScrollView!
    /// 滚动视图
    @IBOutlet weak var collectionView: UICollectionView!
    
    /// pageControl
    @IBOutlet weak var pageControl: WFPageControl!
    
    /// 按钮上方的约束
    @IBOutlet weak var threeBtnTopCons: NSLayoutConstraint!
    @IBOutlet weak var btnViewTopCons: NSLayoutConstraint!
    /// 按钮的contentView
    @IBOutlet weak var btnView: UIView!
    /// 会议预告按钮
    @IBOutlet weak var foreshowMeetingBtn: UIButton!
    
    /// 历史会议按钮
    @IBOutlet weak var historyMeetingBtn: UIButton!
    
    /// 滑动线视图
    @IBOutlet weak var lineView: UIImageView!
    
    /// 列表视图
    @IBOutlet weak var listTableView: UITableView!
    
    /// 列表视图的高度
    @IBOutlet weak var listViewHeightConstant: NSLayoutConstraint!
    
    /// 热门会议点击
    @IBAction func hotMeetingClick(_ sender: Any) {
        navigationController?.pushViewController(WFHotMeetingViewController(), animated: true)
    }
    
    /// 本月会议点击
    @IBAction func currentMonthMeetingClick(_ sender: Any) {
        navigationController?.pushViewController(WFCurrentMothMTingController(), animated: true)
    }
    
    /// 会议查询点击
    @IBAction func searchMeetingClick(_ sender: Any) {
        navigationController?.pushViewController(WFSearchMeetingController(), animated: true)
    }
    
    /// 会议预告点击
    @IBAction func foreshowMeetingClick(_ sender: Any) {
        
        if foreshowMeetingBtn.isSelected == true {
            return
        }
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected
        
        //动画
        UIView.animate(withDuration: 0.5) {
            
            var viewFrame = self.lineView.frame
            viewFrame.origin.x = self.foreshowMeetingBtn.xf_X
            self.lineView.frame = viewFrame
        }
       
    }
    
    /// 历史会议点击
    @IBAction func historyMeetingClick(_ sender: Any) {
        
        ///如果是当下选择的按钮的话返回
        if historyMeetingBtn.isSelected == true {
           return
        }

        ///切换按钮状态
        foreshowMeetingBtn.isSelected = !foreshowMeetingBtn.isSelected
        historyMeetingBtn.isSelected = !historyMeetingBtn.isSelected
        
        UIView.animate(withDuration: 0.5) {
            
            var viewFrame = self.lineView.frame
            viewFrame.origin.x = self.historyMeetingBtn.xf_X
            self.lineView.frame = viewFrame
        }
        
    }
    
    deinit {
        //NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        NotificationCenter.default.removeObserver(self)
        wkWebView.removeObserver(self, forKeyPath: "canGoBack")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = wkWebView.canGoBack
    }
}

// MARK: - 加载网络数据
extension WFMeetingViewController{
    override func loadData() {
        listViewHeightConstant.constant = 10 * 90
        view.layoutIfNeeded()
        scroView.delegate = self
        
        loadAdNet()
    }
    
    private  func loadAdNet() {
        
        NetworkerManager.shared.getAppAdSolts { (isSuccess, json) in
            
            if isSuccess == true {
                print(json)
                
                var titleArray = [String]()
                var imageArray = [String]()
                
                for  item in json {
                    
                    titleArray.append(item.name ?? "")
                    imageArray.append(item.imageString )
                    
                }
                self.cyleScrollView.titlesGroup = titleArray
                self.cyleScrollView.imageURLStringsGroup = imageArray
                
                self.pageControl.numberOfPages = json.count
                self.pageControl.currentPage = 0
            }
            
        }
    }

}

// MARK: -  TableView数据源代理方法
extension WFMeetingViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFMeetingTableViewCell().identfy) as? WFMeetingTableViewCell
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}

// MARK: - UIScrowView代理方法
//extension WFMeetingViewController{
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let lastNumber = Screen_height / 5
//        let number =  lastNumber + 48 + 10
//
//        //189
//        if scrollView.contentOffset.y >= lastNumber &&
//            scrollView.contentOffset.y < lastNumber + 10 {
//
//            threeBtnTopCons.constant = scrollView.contentOffset.y - lastNumber
//            print("lastNuber \(threeBtnTopCons.constant)")
//
//        } else if scrollView.contentOffset.y < lastNumber{
//            threeBtnTopCons.constant = 0
//
//        }else{
//
//            threeBtnTopCons.constant = 10
//        }
//
//        if scrollView.contentOffset.y >= number  {
//
//            let scrowY = scrollView.contentOffset.y
//            btnViewTopCons.constant  = scrowY - number + 58
//            btnView.layoutIfNeeded()
//
//        }else{
//            btnViewTopCons.constant  = 58
//        }
//
//        var viewFrame = self.lineView.frame
//        viewFrame.origin.x = self.historyMeetingBtn.isSelected ? self.historyMeetingBtn.xf_X : self.foreshowMeetingBtn.xf_X
//        self.lineView.frame = viewFrame
//        btnView.layoutIfNeeded()
//
//    }
//
//}
//

// MARK: - 监听的方法
extension WFMeetingViewController{
    
    
       // MARK: - 手势监听方法
    @objc func gesterClick(gesture : UISwipeGestureRecognizer){
        
        if gesture.direction == .right && historyMeetingBtn.isSelected == true {
            
            foreshowMeetingClick(self)
            print("往左滑")
        
        }
        if gesture.direction == .left && foreshowMeetingBtn.isSelected == true {
        
            historyMeetingClick(self)

            print("往又滑")
        }
        
    }
    
}


///设置界面
extension WFMeetingViewController:SDCycleScrollViewDelegate{
    
    func begainFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = true

    }
    
    func endFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = false
        
        UIScreen.rotationScreen()

/*    //强制归正：
         
         if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
         SEL selector = NSSelectorFromString(@"setOrientation:");
         NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
         [invocation setSelector:selector];
         [invocation setTarget:[UIDevice currentDevice]];
         int val =UIInterfaceOrientationPortrait;
         [invocation setArgument:&val atIndex:2];
         [invocation invoke];
         }
         
*/
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == "canGoBack" {
            
            let change = change?[NSKeyValueChangeKey.newKey] as? Bool
            self.tabBarController?.tabBar.isHidden = change!
            
            change! ? (self.leftItem()) : (setTitleCon())
        }
    }
    
    private func setTitleCon() {
        self.navItem.leftBarButtonItems = []
        navItem.title = "会议系统"

    }
    
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        navItem.title = "会议系统"
        
        if #available(iOS 11, *) {
           self.scroView.contentInsetAdjustmentBehavior = .never
        }
        
        //NotificationCenter.default.addObserver(self, selector: #selector(resendMessageToHtml(_:)), name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(begainFullScreen), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
        
        setUpTableView()
        setUpForeshowBtn()
    
        setUpCycleView()
    
        setupWebView()
        
        loadWebview()
    
        setUpWkView()//加载wk
        
        wkWebView.addObserver(self, forKeyPath: "canGoBack", options: .new, context: nil)
        
        setRightItem()
    }
    
    ///完成按钮
    private func setRightItem(){
        
        let btn  = UIButton.cz_textButton("分享", fontSize: 15, normalColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), highlightedColor: UIColor.white)
        btn?.addTarget(self, action: #selector(shareViewClick), for: .touchUpInside)
        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn!)
        
    }
    
    @objc  private func shareViewClick() {
        
        let block : ([String])->()  = {[weak self] (array) in
            
//            self?.shareView.isHidden = true
            
            AppDelegate.shareUrl((self?.wkWebView.shareUrl)!,
                                 imageString: array[1],
                                 title: self?.wkWebView.title ?? "",
                                 descriptionString: array[0],
                                 viewController: self!, .wechatSession)
            
        }
        
        wkWebView.requireShareDetail(block: block)
        
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
        
        var item = wkWebView.backForwardList.backItem
        
        var count  = 2
        
        while true {
            
        if item?.url.absoluteString.contains("checkpayresult.jspx") == true ||
           item?.url.absoluteString.contains("tenpay") == true              ||
           item?.url.absoluteString.contains("weixin") == true              ||
            item?.url.absoluteString.contains("wxpay") == true              ||
           item?.url.absoluteString.contains("alipay") == true{
            
           item = wkWebView.backForwardList.backList[wkWebView.backForwardList.backList.count - count]
           count = count + 1
        }else{
            break
            }
        }
           wkWebView.go(to: item!)
        
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
//        self.wkWebView.reload()
//            
//        })

        guard let url  = URL(string:Photo_Path + "/meeting/meetingList.jspx") else{
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
//        if let rponse = URLCache.shared.cachedResponse(for: request) {
//            if #available(iOS 9.0, *) {
//                wkWebView.load(rponse.data, mimeType: "text.html", characterEncodingName: "UTF-8", baseURL: request.url!)
//            } else {
//               _ = wkWebView.load(request)
//            }
//        }else{
        _ = wkWebView.load(request)
//        }
//        UIViewPropertyAnimator
        view.addSubview(wkWebView)
        
//        guard let data = try? Data.init(contentsOf: url) else {
//            return
//        }
//        let respones = URLResponse.init(url: url, mimeType: "text/html", expectedContentLength: 0, textEncodingName: "UTF-8")
//        //42363 8009938
//
//        let cacheRespones = CachedURLResponse.init(response: respones, data: data)
//        URLCache.shared.storeCachedResponse(cacheRespones, for: request)
        
    }
    
    
    func loadWebViewHid() {
            wkWebView.reload()
    }
    
    func backForword() {
        
        if wkWebView.canGoBack == true  {
            wkWebView.go(to: wkWebView.backForwardList.backItem!)
        }
        
    }
    
   private func setupWebView() {
    
//      webView.delegate = self入65555555555555555555555555555555555555555555
    
    }
    
   private  func loadWebview() {
    
    guard let url  = URL(string:Photo_Path + "/meeting/meetingList.jspx") else{
        return
    }
    
    webView.loadRequest(URLRequest(url: url))
    
    }

///设置轮播图
private func setUpCycleView() {
    
    cyleScrollView.delegate = self
    cyleScrollView.autoScrollTimeInterval = 4
    cyleScrollView.showPageControl = false
    cyleScrollView.itemDidScrollOperationBlock = {(offset) in
        
        self.pageControl.currentPage = offset
    }
}


    /// 设置预告和历史按钮
    private  func setUpForeshowBtn() {
    
        foreshowMeetingBtn.isSelected = true
        foreshowMeetingBtn.setAttributedTitle(NSMutableAttributedString(
                                                                          string: "会议预告",
                                                                          attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                                          for: .selected)

        
        historyMeetingBtn.setAttributedTitle(NSMutableAttributedString(
                                                                         string: "历史会议",
                                                                         attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)]),
                                                                         for: .selected)
        
    }
    
    
    /// 设置列表视图
   private func setUpTableView() {

        listTableView.delegate = self
        listTableView.dataSource = self
        listTableView.tableFooterView = UIView()
    
        listTableView.touchesShouldCancel(in: listTableView)
        listTableView.register(UINib.init(
                                            nibName: WFMeetingTableViewCell().identfy,
                                            bundle: nil),
                                            forCellReuseIdentifier: WFMeetingTableViewCell().identfy)
    
    
    /// 添加右滑收拾
    let gesture  = UISwipeGestureRecognizer(target: self,
                                                                         action: #selector(gesterClick(gesture:)))
    listTableView.addGestureRecognizer(gesture)
    
    /// 添加左滑收拾
    let gestureLeft  = UISwipeGestureRecognizer(target: self,
                                                                             action: #selector(gesterClick(gesture:)))
    
    gestureLeft.direction = .left
    listTableView.addGestureRecognizer(gestureLeft)
    
    }
    
}

extension WFMeetingViewController {
    
//    func webViewDidStartLoad(_ webView: UIWebView) {
//
//    }
//
//    func webViewDidFinishLoad(_ webView: UIWebView) {
//
//        let meeting  = MeetingClass()
//        //meeting.webView = webView
//
//         self.jsContext  = webView.value(forKeyPath: "documentView.webView.mainFrame.javaScriptContext") as? JSContext
//
//        self.jsContext?.setObject(meeting, forKeyedSubscript: "meeting" as NSCopying & NSObjectProtocol)
//
//        meeting.jsContext = self.jsContext
//          //WebView当前访问页面的链接 可动态注册
//        //let  curUrl = webView.request?.url?.absoluteString ,
//
//        guard let url = URL(string: curUrl) else {
//
//            return
//        }
//
//        //self.jsContext?.evaluateScript(try? String(contentsOf:url , encoding: String.Encoding.utf8), throw {return})
//        do{
//
//            let jsSourceContents = try? String(contentsOf:url , encoding: String.Encoding.utf8)
//            if jsSourceContents != nil {
//               _ =  self.jsContext?.evaluateScript(jsSourceContents)
//            }
//
//        } catch let ex {
//
//            print("没有成功")
//            print(ex.localizedDescription)
//        }
//
//        self.jsContext?.exceptionHandler = { (context, exception) in
//            print("exception：", exception ?? "没找到")
//        }
//
//    }
//
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//
//        curUrl  =  request.url?.absoluteString ?? ""
//        print(request.url?.absoluteString ?? "")
//
//        print(curUrl + "-----")
//
//        let  requestString = request.url?.absoluteString
//
//        if requestString?.contains(".jspx?") == true &&  requestString?.contains("from=app") == false  {
//
//            guard let url  = URL(string: (requestString ?? "") + "&from=app") else{
//                return false
//            }
//            webView.loadRequest(URLRequest(url: url))
//            return false
//        }else if requestString?.contains(".jspx") == true &&  requestString?.contains("from=app") == false{
//
//            guard let url  = URL(string: (requestString ?? "") + "?from=app") else{
//                return false
//            }
//            webView.loadRequest(URLRequest(url: url))
//            return false
//
//        }else{
//
//            return curUrl != ""
//        }
//
//
//    }
//
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//
//    }
    
//    func resendMessageToHtml(_ jsx : JSContext) {
//    
//        let username  = UserDefaults.standard.value(forKey: user_username) as? String
//        let password  = UserDefaults.standard.value(forKey: user_password) as? String
//        
//        wkWebView.evaluateJavaScript("userInfo('\(username)','\(password )')") { (json, error ) in
//            print("错误 ", json ,"这个是啥",error )
//        }
//
//    }
}


