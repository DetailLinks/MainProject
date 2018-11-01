//
//  WFVideoDetailController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/11.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import JavaScriptCore
import WebKit
import SVProgressHUD
import MJRefresh

class WFVideoDetailController: BaseViewController,UIWebViewDelegate {

    var fixSapce = 0
    
    var isInfo  = false
    
    
    let meetingHandle = MeetingClass()
    
    var htmlString  = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    
    lazy var shareView : WFShareChooseView = {
        
        let v = WFShareChooseView.shareChooseView(UIScreen.main.bounds)
        
        UIApplication.shared.delegate?.window??.addSubview(v)
        
        v.isHidden = true
        
        return v
    }()

    override var isFirstPush: Bool{
        didSet{
            if isFirstPush == true {
                fixSapce = -5
            }else{
                fixSapce = -15
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NotificationCenter.default.addObserver(self, selector: #selector(resendMessageToHtml(_:)), name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        
        //NotificationCenter.default.addObserver(self, selector: #selector(reloadHtml), name: NSNotification.Name(rawValue: notifi_notLogin_return_last), object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector( popToLastController), name: NSNotification.Name(rawValue: notifi_notLogin_return_last), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(begainFullScreen), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen(_:)), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
        
    }

    
    deinit {
        
       // NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_notLogin_return_last), object: nil)

        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func popToLastController () {
        navigationController?.popViewController(animated: true)
    }
    
    func reloadHtml() {
        
        let id  = UserDefaults.standard.value(forKey: "certificationID") as? String
        
        guard let url  = URL(string:Photo_Path + "/meeting/homepage.jspx?id=\(id ?? "")") else{
            return
        }
        webView.loadRequest(URLRequest(url: url))
        
    }
    
    func begainFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = true
        
    }
    
    func endFullScreen(_ noti : NSNotification) {
        
//        let window = noti.object as? UIWindow
//
//        let vc  = window?.rootViewController
//        if (vc?.childViewControllers.first?.isKind(of: NSClassFromString("AVPlayerViewController")!))! {
//            UIApplication.shared.setStatusBarHidden(false, with: .fade)
//        }
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = false
        
        UIScreen.rotationScreen()
        
        let window = noti.object as? UIWindow
        guard let vc  = window?.rootViewController,
            let vd  = vc.childViewControllers.first,
            let cls = NSClassFromString("AVPlayerViewController")
            else { return  }
        if true == vd.isKind(of: cls) {
            UIApplication.shared.setStatusBarHidden(false, with: .fade)
        }
        
        }
}

///设置界面
extension WFVideoDetailController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        
        setWkWebView()
        
        if title == "病例讨论jhjkjbjbjkbjb" {
            
        setRightItem()
        
        shareView.shareBtn.addTarget(self, action: #selector(shareViewClick), for: .touchUpInside)
        shareView.newCaseBtn.addTarget(self, action: #selector(rightItmClick), for: .touchUpInside)
            
        }else{
            
            setRightItemShare()
        }
    }
    
        ///完成按钮
        private func setRightItemShare(){
            
            let btn  = UIButton.cz_textButton("分享", fontSize: 15, normalColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), highlightedColor: UIColor.white)
            btn?.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
            btn?.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, CGFloat(fixSapce))
            btn?.addTarget(self, action: #selector(shareViewClick), for: .touchUpInside)
            let shareitem  = UIBarButtonItem(customView: btn!)
            let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
            spaceItem.width = 10
            
            navItem.rightBarButtonItems = [spaceItem,shareitem]

            
        }
      @objc  private func shareViewClick() {
        
        let block : ([String])->()  = {[weak self] (array) in
            
            self?.shareView.isHidden = true
            
            AppDelegate.shareUrl((self?.wkWebView.shareUrl)!,
                                 imageString: array[1],
                                 title: self?.wkWebView.title ?? "",
                                 descriptionString: array[0],
                                 viewController: self!, .wechatSession)
            
        }
        
        wkWebView.requireShareDetail(block: block)
        
    }

        
//        @objc  private func shareViewClick() {
//
//            self.shareView.isHidden = true
//
//            AppDelegate.shareUrl(wkWebView.shareUrl,
//                                 imageString: "24321528943095_.pic",
//                                 title: wkWebView.title ?? "",
//                                 descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范",
//                                 viewController: self, .wechatSession)
//
//        }

    
    private func setRightItem() {
            
//            let btn  = UIButton.cz_textButton("新建病例", fontSize: 15, normalColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), highlightedColor: UIColor.white)
//            btn?.addTarget(self, action: #selector(rightItmClick), for: .touchUpInside)
        
        let rightBtn =  UIBarButtonItem(imageString: "casediscuss_icon_more", target: self, action: #selector(shareViewHidden),rightSpace : CGFloat(fixSapce) )
        
            let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                 spaceItem.width = 5

                 navItem.rightBarButtonItems = [spaceItem,rightBtn]
        
                //UIBarButtonItem(customView: UIImageView(image: #imageLiteral(resourceName: "casediscuss_icon_more")))
                //UIBarButtonItem(customView: btn!)
        }
    
          @objc private func shareViewHidden() {
        
            self.shareView.isHidden = false
        
       }
    
        
        @objc private func rightItmClick() {

            self.shareView.isHidden = true
            
            let vc  = WFVideoDetailController()
            vc.htmlString = Photo_Path + "/static/createCase.html"// //"/static/casesing.html"//
            vc.title = "新建病例"
            navigationController?.pushViewController(vc, animated: true)
    
        }
}

///wkwebview  : WKScriptMessageHandler , WKNavigationDelegate
extension WFVideoDetailController {
    
    func setWkWebView() {
        
        wkWebView = WFWkWebView(CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height - navigation_height ))
        
        wkWebView.mainController = self
        
        if isInfo {
         
             wkWebView.navigationDelegate = self
        }
        
//        wkWebView.scrollView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//            
//            self.wkWebView.reload()
//        })
        
        if htmlString.contains("?")  == false {
           htmlString = htmlString + "?t=\(Date().timeStapmpString)"
        }else{
           htmlString = htmlString + "&t=\(Date().timeStapmpString)"
        }
        
        guard let url  = URL(string:htmlString) else{
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        _ = wkWebView.load(request)

//        wkWebView.load(URLRequest(url: url))
        view.addSubview(wkWebView)
        
    }
}

extension WFVideoDetailController : WKNavigationDelegate{
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
         webView.reload()

    }

    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        SVProgressHUD.show()
        wkWebView.isChangeBackUrl = false
        print("开始加载")
    }
    /// 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {


        wkWebView.shareUrl = webView.url?.absoluteString ?? ""
        self.title  = webView.title
        if NetworkerManager.shared.userCount.isLogon {

            var string  = NetworkerManager.shared.userCount.avatarAddress?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? ""
            string = string.replacingOccurrences(of: "/", with: "%2f")
            string = string.replacingOccurrences(of: ":", with: "%3a")

            webView.evaluateJavaScript("document.cookie ='medtion_member_username=\(NetworkerManager.shared.userCount.username ?? "")';document.cookie ='medtion_member_realName=\( NetworkerManager.shared.userCount.realName?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? "")';document.cookie ='medtion_member_id=\(NetworkerManager.shared.userCount.id ?? "")';document.cookie ='medtion_member_empcard=\(string)';document.cookie ='medtion_member_isAuth=\(NetworkerManager.shared.userCount.isAuth)'") { (result , error ) in

            }

            //            if isShouldLogin == true {
            //               resendMessageToHtml(Notification(name: Notification.Name(rawValue: "ss")))
            //               isShouldLogin = false
            //            }else{
            //
            //                if backForwardList.backList.count == 1 && isShouldFirstLoad == true{
            //                   resendMessageToHtml(Notification(name: Notification.Name(rawValue: "ss")))
            //                   isShouldFirstLoad = false
            //                }
            //
            //            }



        }

        if  webView.scrollView.mj_header != nil &&  webView.scrollView.mj_header.isRefreshing == true  {

            webView.scrollView.mj_header.endRefreshing()
        }

        if isNotification == true  {
            wkWebView.mainController?.title = title ?? ""
            isNotification = false
        }

        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 1) {

            if self.title ?? "" != ""{
                if self.wkWebView.canGoBack == true{
                    self.wkWebView.mainController?.title = self.title ?? ""
                }else{

                    self.wkWebView.mainController?.title = self.title ?? ""

                    if let _ = self.wkWebView.mainController as? WFMeetingViewController {
                        self.wkWebView.mainController?.title = "会议系统"
                    }
                    if  let _ = self.wkWebView.mainController as? WFVideoViewController {
                        self.wkWebView.mainController?.title = "直录播"
                    }
                }
            }
        }

        //        if self.title ?? "" != "" {
        //            self.mainController?.title = title ?? ""
        //            print("页面加载完成\(title)")
        //        }

        print("页面加载完成")
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {

        print("页面加载失败")
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("页面加载提交")
    }

    //决定跳转接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到服务器跳转请求之后调用")
    }

     //在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {



        decisionHandler(.allow)
        print("在收到响应后，决定是否跳转")
    }

//    // 在发送请求之前，决定是否跳转
//    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
//        print("在发送请求之前，决定是否跳转")
//
//
//
//
//        let payString : NSString  = navigationAction.request.url?.absoluteString.removingPercentEncoding as! NSString
//
//        print(navigationAction.request.url?.absoluteString)
//        print("------------------------")
//        print(payString)
//
//        var  requestString = navigationAction.request.url?.absoluteString
//
//
//        if  ((requestString?.contains(".jspx?") == true || requestString?.contains(".html?") == true) &&  requestString?.contains("from=app_ios") == false) && (requestString?.contains("alipay") == false  && requestString?.contains("tenpay") == false){
//
//            guard let url  = URL(string: (requestString ?? "") + "&from=app_ios") else{
//                return
//            }
//            webView.load(URLRequest(url: url))
//            decisionHandler(.cancel)
//        }else if (requestString?.contains(".jspx")  == true  || requestString?.contains(".html") == true) &&  (requestString?.contains("from=app_ios") == false && requestString?.contains("alipay") == false &&  requestString?.contains("tenpay") == false) {
//
//            guard let url  = URL(string: (requestString ?? "") + "?from=app_ios") else{
//                return
//            }
//
//            webView.load(URLRequest(url: url))
//
//            decisionHandler(.cancel)
//        }else{
//            print("urlString - ", requestString)
//
//            if  requestString?.contains(".jspx")  == true || requestString?.contains(".html") == true  {
//
//                wkWebView.shareUrl = requestString ?? ""
//                wkWebView.shareUrl = wkWebView.shareUrl.replacingOccurrences(of: "from=app_ios&", with: "")
//                wkWebView.shareUrl = wkWebView.shareUrl.replacingOccurrences(of: "&from=app_ios", with: "")
//                wkWebView.shareUrl = wkWebView.shareUrl.replacingOccurrences(of: "?from=app_ios", with: "")
//                print("shareUrl ... \(wkWebView.shareUrl)")
//            }
//            //http://ni.medtion.com/order/alipay.jspx?id=472&orderNumber=HY20180601193952249
//
//            if ((navigationAction.request.allHTTPHeaderFields!["Referer"] ?? "" != "www.medtion.com://" && navigationAction.request.allHTTPHeaderFields!["Referer"] ?? "" == "") && requestString?.contains("tenpay") == true)  || (requestString?.contains("tenpay") == true && wkWebView.isChangeBackUrl == false) {
//
//                let urlString : NSString = payString
//                let range = urlString.range(of: "redirect_url=")
//                let string  = urlString.substring(to: range.location + range.length)
//                let comUrl = string + "www.medtion.com://"
//
//                wkWebView.backUrl = urlString.substring(from: range.location + range.length )
//                guard let url  = URL(string:comUrl )  else{
//                    return
//                }
//                wkWebView.isChangeBackUrl = true
//                let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
//                request.httpMethod = "GET"
//
//                request.setValue("www.medtion.com://", forHTTPHeaderField: "Referer")
//
//                webView.load(request as URLRequest)
//
//
//                decisionHandler(.cancel)
//
//            }
//            else if payString == "www.medtion.com://" {
//
//                guard let url  = URL(string: (wkWebView.backUrl ) + "&from=app_ios") else{
//                    return
//                }
//                webView.load(URLRequest(url: url))
//
//                decisionHandler(.cancel)
//
//            }
//            else{
//
//                if requestString?.hasPrefix("weixin://") == true || requestString?.hasPrefix("alipays://") == true ||  requestString?.hasPrefix("alipay://") == true{
//
//                    var openUrl = navigationAction.request.url!.absoluteString
//
//
//                    if requestString?.hasPrefix("alipay://") == true || requestString?.hasPrefix("alipays://") == true{
//
//                        //alipay://alipayclient/?{"dataString":"h5_route_token=\"RZ12aTXDWqz8ZPka1vLYkuChUAxDVzmobilecashierRZ12\"&is_h5_route=\"true\"","requestType":"SafePay","fromAppUrlScheme":"alipays"}
//
//                        let urlString : NSString = payString
//                        let range = urlString.range(of: "fromAppUrlScheme")
//                        let string  = urlString.substring(to: range.location + range.length + 1)
//                        openUrl = (string + ":\"www.medtion.com://\"}").addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )!
//
//                    }
//
//                    guard let loadurl =  URL(string: openUrl) else{
//                        return
//                    }
//
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(loadurl, options: [UIApplicationOpenURLOptionUniversalLinksOnly:false], completionHandler: { (_ ) in
//
//                        })
//                    } else {
//
//                        UIApplication.shared.openURL(navigationAction.request.url!)
//
//                    }
//
//                }
//                decisionHandler(.allow)
//
//            }
//
//        }
//    }

}
