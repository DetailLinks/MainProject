//
//  WFWkWebView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/12.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WFWkWebView: WKWebView , WKNavigationDelegate {
    ///获取分享信息的block
    var shareInfoBlock : (([String])->())?

    var shareUrl  = ""
    
    var isShouldLogin = true
    
    var isShouldFirstLoad = true
    
    
    ///改变返回值url
    var isChangeBackUrl  = false
    
    
    var loadNumber = 0
    
    var mainController  : BaseViewController?
    
    ///返回加载的url
    var backUrl  = ""
    
    
    lazy var meetingHandle = MeetingClass()
    
    //, _ controller : WKNavigationDelegate
    convenience init(_ frame : CGRect ) {
        
        let config = WKWebViewConfiguration()
        
        config.preferences.minimumFontSize = 10
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        self.init(frame: frame , configuration: config)
        
        meetingHandle.webView = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHtml), name: NSNotification.Name(rawValue: notifi_approve_html_success), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resendMessageToHtml(_:)), name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDueToLogin), name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        
        
        navigationDelegate = self
        
        let  jsController = config.userContentController
        
        jsController.add(self , name: "meetingLogin")
        jsController.add(self , name: "meetingSearch")
        jsController.add(self , name: "monthmeeting")
        jsController.add(self , name: "hotMeeting")
        jsController.add(self , name: "meetingRegister")
        jsController.add(self , name: "homepage")
        jsController.add(self , name: "certification")
        jsController.add(self , name: "backUrl")
        //新增
        jsController.add(self , name: "meetinglive")
        jsController.add(self , name: "meetingfields")
        ///新增分享
        jsController.add(self , name: "informationShare")
        jsController.add(self , name: "createArticle")
    }
    
    convenience init(_ frame : CGRect ,_ config : WKWebViewConfiguration ) {
        
        config.preferences.minimumFontSize = 10
        
        config.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        self.init(frame: frame , configuration: config)
        
        meetingHandle.webView = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadHtml), name: NSNotification.Name(rawValue: notifi_approve_html_success), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(resendMessageToHtml(_:)), name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDueToLogin), name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        navigationDelegate = self
        
        let  jsController = config.userContentController
        
        jsController.add(self , name: "meetingLogin")
        jsController.add(self , name: "meetingSearch")
        jsController.add(self , name: "monthmeeting")
        jsController.add(self , name: "hotMeeting")
        jsController.add(self , name: "meetingRegister")
        jsController.add(self , name: "homepage")
        jsController.add(self , name: "certification")
        jsController.add(self , name: "backUrl")
        //新增
        jsController.add(self , name: "meetinglive")
        jsController.add(self , name: "meetingfields")
        ///新增分享
        jsController.add(self , name: "informationShare")
        jsController.add(self , name: "createArticle")

    }
    
    ///认证成功的登录
    func reloadHtml() {
        
        let id  = UserDefaults.standard.value(forKey: "certificationID") as? String
        
        guard let url  = URL(string:Photo_Path + "/meeting/homepage.jspx?id=\(id ?? "")") else{
            return
        }
        
        if canGoBack == true {
            go(to: backForwardList.backItem!)
        }
        
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        
        _ = load(request)
        
    }
    
    
    override func load(_ request: URLRequest) -> WKNavigation? {
        
        //        NetworkerManager.shared.addUrl(url: request.url!)
        
        let requestString = (request.url?.absoluteString)! + "&t=\(Date().timeStapmpString)"
        
        let request = URLRequest.init(url: URL.init(string: requestString)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)

        
        if NetworkerManager.shared.userCount.isLogon {
            self.configuration.userContentController.addUserScript(loadNewCookieScript())
        }
        
        var murequest  =  URLRequest(url: request.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        murequest.addValue(loadCookieString(), forHTTPHeaderField: "Cookie")
        
        return super.load(request)
        
    }
    
    ///加载Cookie
    private func loadCookieString() -> String {
        
        var string  = NetworkerManager.shared.userCount.avatarAddress?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? ""
        string = string.replacingOccurrences(of: "/", with: "%2f")
        string = string.replacingOccurrences(of: ":", with: "%3a")
        
        let cookie = "medtion_member_username=\(NetworkerManager.shared.userCount.username ?? "");medtion_member_realName=\( NetworkerManager.shared.userCount.realName?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? "");medtion_member_id=\(NetworkerManager.shared.userCount.id ?? "");medtion_member_empcard=\(string);medtion_member_isAuth=\(NetworkerManager.shared.userCount.isAuth);"
        
        return cookie
    }
    
    ///登录成功回调
    func resendMessageToHtml(_ notifi : Notification ) {
        
//        let username  = UserDefaults.standard.value(forKey: user_username) as? String ?? ""
//        let password  = UserDefaults.standard.value(forKey: user_password) as? String ?? ""
        let userid  = UserDefaults.standard.value(forKey: user_userid) as? String ?? ""
       
        evaluateJavaScript("userInfov1('\(userid)')") { (json, error ) in
            print("错误 ", json ,"这个是啥",error )
        }
        
    }
    ///分享获取的数据
    func requireShareDetail(block:@escaping ([String])->()) {
        
        shareInfoBlock = block
        
        evaluateJavaScript("getDescriptionAndImageUrl('app_ios')") { (json, error ) in
            print("错误 ", json ?? "" ,"这个是啥",error ?? "")
            if (error != nil) {
                
            }else{
                
            }
        }
    }

    private func loadNewCookieScript() -> WKUserScript{
        
        let cookieScript = WKUserScript.init(source: loadCookieString(), injectionTime: .atDocumentStart, forMainFrameOnly: false)
        return cookieScript
    }
    
    
    @objc private func reloadDueToLogin() {
        
//        if backForwardList.backList.count > 0{
//            let item = backForwardList.backList[0]
//            go(to: item)
//        }
//        isShouldLogin = true
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_html_success), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_approve_html_success), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        
    }
    
}

extension WFWkWebView:WKScriptMessageHandler {
    
    
    @available(iOS 8.0, *)
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        switch message.name {
        case "meetingLogin": meetingHandle.meetingLogin()
        case "meetingSearch": meetingHandle.meetingSearch()
        case "monthmeeting": meetingHandle.monthmeeting()
        case "hotMeeting": meetingHandle.hotMeeting()
        case "meetingRegister": meetingHandle.meetingRegister()
        case "homepage": meetingHandle.homepage(message.body as? String ?? "")
        case "certification": meetingHandle.certification(message.body as? String ?? "")
        case "backUrl": meetingHandle.backUrl(message.body as? String ?? "")
        case "meetinglive": meetingHandle.meetinglive(message.body as? String ?? "")
        case "meetingfields": meetingHandle.meetingfields(message.body as? String ?? "")
        case "informationShare": meetingHandle.informationShare(message.body as? [String] ?? [])
        case "createArticle": meetingHandle.createArticle()
        default: break
        }
    }
    
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
         reload()
    }
    
    // 页面开始加载时调用
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //        SVProgressHUD.show()
        isChangeBackUrl = false
        print("开始加载")
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        if NetworkerManager.shared.userCount.isLogon {
            
            var string  = NetworkerManager.shared.userCount.avatarAddress?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? ""
            string = string.replacingOccurrences(of: "/", with: "%2f")
            string = string.replacingOccurrences(of: ":", with: "%3a")
            
            webView.evaluateJavaScript("document.cookie ='medtion_member_username=\(NetworkerManager.shared.userCount.username ?? "")';document.cookie ='medtion_member_realName=\( NetworkerManager.shared.userCount.realName?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? "")';document.cookie ='medtion_member_id=\(NetworkerManager.shared.userCount.id ?? "")';document.cookie ='medtion_member_empcard=\(string)';document.cookie ='medtion_member_isAuth=\(NetworkerManager.shared.userCount.isAuth)'") { (result , error ) in
                
            }
        }
        
    }

    
    /// 页面加载完成之后调用
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        
        
        if NetworkerManager.shared.userCount.isLogon {
            
            var string  = NetworkerManager.shared.userCount.avatarAddress?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? ""
            string = string.replacingOccurrences(of: "/", with: "%2f")
            string = string.replacingOccurrences(of: ":", with: "%3a")
            
            webView.evaluateJavaScript("document.cookie ='medtion_member_username=\(NetworkerManager.shared.userCount.username ?? "")';document.cookie ='medtion_member_realName=\( NetworkerManager.shared.userCount.realName?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? "")';document.cookie ='medtion_member_id=\(NetworkerManager.shared.userCount.id ?? "")';document.cookie ='medtion_member_empcard=\(string)';document.cookie ='medtion_member_isAuth=\(NetworkerManager.shared.userCount.isAuth)'") { (result , error ) in
                
            }
            print("cookie")
            print("document.cookie ='medtion_member_username=\(NetworkerManager.shared.userCount.username ?? "")';document.cookie ='medtion_member_realName=\( NetworkerManager.shared.userCount.realName?.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )! ?? "")';document.cookie ='medtion_member_id=\(NetworkerManager.shared.userCount.id ?? "")';document.cookie ='medtion_member_empcard=\(string)';document.cookie ='medtion_member_isAuth=\(NetworkerManager.shared.userCount.isAuth)'")
            
        }
        
//        if  webView.scrollView.mj_header != nil &&  webView.scrollView.mj_header.isRefreshing == true  {
//
//            webView.scrollView.mj_header.endRefreshing()
//        }
        
        if isNotification == true  {
            self.mainController?.navItem.title = title ?? ""
            isNotification = false
        }
        
        DispatchQueue.main.asyncAfter(deadline:DispatchTime.now() + 1) {
            
            if self.title ?? "" != ""{
                if self.canGoBack == true{
                    self.mainController?.navItem.title = self.title ?? ""
                }else{
                    
                    self.mainController?.navItem.title = self.title ?? ""
                    
                    if let _ = self.mainController as? WFMeetingViewController {
                        self.mainController?.navItem.title = "会议系统"
                    }
                    if  let _ = self.mainController as? WFVideoViewController {
                        self.mainController?.navItem.title = "直录播"
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
        
        //        if  webView.scrollView.mj_header != nil && webView.scrollView.mj_header.isRefreshing == true  {
        //            webView.scrollView.mj_header.endRefreshing()
        //        }
        
        //            SVProgressHUD.dismiss()
        print("页面加载失败")
    }
    
    
    ///决定跳转
    // 接收到服务器跳转请求之后调用
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print("接收到服务器跳转请求之后调用")
    }
    
    // 在收到响应后，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        decisionHandler(.allow)
        print("在收到响应后，决定是否跳转")
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("在发送请求之前，决定是否跳转")
        
        
        if navigationAction.targetFrame == nil   {
            webView.load(navigationAction.request)
            
        }

        if navigationAction.request.url?.host == "video.qq.com" ||
            navigationAction.request.url?.host == "v.qq.com" {
            decisionHandler(.allow)
            return
        }
        
        let payString : NSString  = navigationAction.request.url?.absoluteString.removingPercentEncoding as! NSString
        
        print(navigationAction.request.url?.absoluteString)
        print("------------------------")
        print(payString)
        
        var  requestString = navigationAction.request.url?.absoluteString
        
        
        if  ((requestString?.contains(".jspx?") == true || requestString?.contains(".html?") == true) &&  requestString?.contains("from=app_ios") == false) && (requestString?.contains("alipay") == false  && requestString?.contains("tenpay") == false){
            
            guard let url  = URL(string: (requestString ?? "") + "&from=app_ios") else{
                return
            }
            webView.load(URLRequest(url: url))
            decisionHandler(.cancel)
        }else if (requestString?.contains(".jspx")  == true  || requestString?.contains(".html") == true) &&  (requestString?.contains("from=app_ios") == false && requestString?.contains("alipay") == false &&  requestString?.contains("tenpay") == false) {
            
            guard let url  = URL(string: (requestString ?? "") + "?from=app_ios") else{
                return
            }
            
            webView.load(URLRequest(url: url))
            
            decisionHandler(.cancel)
        }else{
            print("urlString - ", requestString)
            
            if  requestString?.contains(".jspx")  == true || requestString?.contains(".html") == true  {
                
                shareUrl = requestString ?? ""
                shareUrl = shareUrl.replacingOccurrences(of: "from=app_ios&", with: "")
                shareUrl = shareUrl.replacingOccurrences(of: "&from=app_ios", with: "")
                shareUrl = shareUrl.replacingOccurrences(of: "?from=app_ios", with: "")
                print("shareUrl ... \(shareUrl)")
            }
            //http://ni.medtion.com/order/alipay.jspx?id=472&orderNumber=HY20180601193952249
            
            if ((navigationAction.request.allHTTPHeaderFields!["Referer"] ?? "" != "www.medtion.com://" && navigationAction.request.allHTTPHeaderFields!["Referer"] ?? "" == "") && requestString?.contains("tenpay") == true)  || (requestString?.contains("tenpay") == true && isChangeBackUrl == false) {
                
                let urlString : NSString = payString
                let range = urlString.range(of: "redirect_url=")
                let string  = urlString.substring(to: range.location + range.length)
                let comUrl = string + "www.medtion.com://"
                
                backUrl = urlString.substring(from: range.location + range.length )
                guard let url  = URL(string:comUrl )  else{
                    return
                }
                isChangeBackUrl = true
                let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
                request.httpMethod = "GET"
                
                request.setValue("www.medtion.com://", forHTTPHeaderField: "Referer")
                
                webView.load(request as URLRequest)
                
                
                decisionHandler(.cancel)
                
            }
            else if payString == "www.medtion.com://" {
                
                guard let url  = URL(string: (backUrl ) + "&from=app_ios") else{
                    return
                }
                webView.load(URLRequest(url: url))
                
                decisionHandler(.cancel)
                
            }
            else{
                
                if requestString?.hasPrefix("weixin://") == true || requestString?.hasPrefix("alipays://") == true ||  requestString?.hasPrefix("alipay://") == true{
                    
                    var openUrl = navigationAction.request.url!.absoluteString
                    
                    
                    if requestString?.hasPrefix("alipay://") == true || requestString?.hasPrefix("alipays://") == true{
                        
                        //alipay://alipayclient/?{"dataString":"h5_route_token=\"RZ12aTXDWqz8ZPka1vLYkuChUAxDVzmobilecashierRZ12\"&is_h5_route=\"true\"","requestType":"SafePay","fromAppUrlScheme":"alipays"}
                        
                        let urlString : NSString = payString
                        let range = urlString.range(of: "fromAppUrlScheme")
                        let string  = urlString.substring(to: range.location + range.length + 1)
                        openUrl = (string + ":\"www.medtion.com://\"}").addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed )!
                        
                    }
                    
                    guard let loadurl =  URL(string: openUrl) else{
                        return
                    }
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(loadurl, options: [UIApplicationOpenURLOptionUniversalLinksOnly:false], completionHandler: { (_ ) in
                            
                        })
                    } else {
                        
                        UIApplication.shared.openURL(navigationAction.request.url!)
                        
                    }
                    
                }
                decisionHandler(.allow)
                
            }
            
            //            shareUrl = backForwardList.currentItem?.url.absoluteString ?? ""
            
        }
    }
    
}


