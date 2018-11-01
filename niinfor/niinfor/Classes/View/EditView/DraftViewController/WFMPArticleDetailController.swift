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

class WFMPArticleDetailController: BaseViewController,UIWebViewDelegate {
    
    var fixSapce = 0
    
    var isInfo  = false
    
    var isShouldLogin = true
    
    var isShouldFirstLoad = true
    
    
    ///改变返回值url
    var isChangeBackUrl  = false
    
    ///返回加载的url
    var backUrl  = ""

    
    var htmlString  = ""
    var article:WFMPArticle? = nil
    
    var deleteComplict :(()->())?
    
    @IBOutlet weak var webView: UIWebView!
    
    var backView = UIView()
    
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
        UIScreen.forceScreen()
        NotificationCenter.default.addObserver(self, selector: #selector( popToLastController), name: NSNotification.Name(rawValue: notifi_notLogin_return_last), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(begainFullScreen), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen(_:)), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)

    }
    
    
    deinit {
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
    
    func endFullScreen(_ noti:Notification) {
        
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        let videoPauseJSStr = "document.documentElement.getElementsByTagName(\"video\")[0].pause();audioPause()"
//        self.wkWebView.evaluateJavaScript(videoPauseJSStr, completionHandler: nil)
        self.wkWebView.reload()
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: .fade)
    }
}

///设置界面
extension WFMPArticleDetailController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        
        setWkWebView()
        
        if title == "病例讨论" {
            
            setRightItem()
            
            shareView.shareBtn.addTarget(self, action: #selector(shareViewClick), for: .touchUpInside)
            shareView.newCaseBtn.addTarget(self, action: #selector(rightItmClick), for: .touchUpInside)
            
        }else{
            
            setRightItem()//setRightItemShare()
        }
    }
    
    ///完成按钮
    private func setRightItemShare(){
        
        let btn  = UIButton.cz_textButton("编辑", fontSize: 15, normalColor: #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1), highlightedColor: UIColor.white)
        btn?.frame = CGRect(x: 0, y: 0, width: 50, height: 44)
        btn?.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, CGFloat(fixSapce))
        btn?.addTarget(self, action: #selector(editArticle), for: .touchUpInside)
        let shareitem  = UIBarButtonItem(customView: btn!)
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = 10
        
        navItem.rightBarButtonItems = [spaceItem,shareitem]
        
        
    }
    
    @objc private func editArticle() {
        backView.isHidden = true
        mainDataSouce = []
        let vc  = WFNewCaseViewController()
        vc.article = article
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc  private func shareViewClick() {
           backView.isHidden = true
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
    
    
    private func setRightItem() {
        
        let rightBtn =  UIBarButtonItem(imageString: "Group 23", target: self, action: #selector(editeBtnClick))
        
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        
        let shareBtn  = UIBarButtonItem(imageString: "分享sh", target: self, action: #selector(rightItmClick),rightSpace : CGFloat(fixSapce) )

        navItem.rightBarButtonItems = [spaceItem,rightBtn,shareBtn]
        
        backView.isHidden = true
        view.insertSubview(backView, aboveSubview: wkWebView)
        backView.snp.makeConstraints { (maekr) in
            maekr.right.equalToSuperview().offset(-12)
            maekr.top.equalTo(navBar.snp.bottom).offset(-15)
            maekr.width.equalTo(90)
            maekr.width.equalTo(84)
        }
        
        let imageView = UIImageView.init(image: #imageLiteral(resourceName: "Rectangle 43 Copy"))
        backView.addSubview(imageView)
        imageView.snp.makeConstraints { (maekr) in
            maekr.right.width.top.height.equalToSuperview()
        }

        let editBtn  = UIButton.cz_textButton(" 编辑", fontSize: 14, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), backgroundImageName: "")
        editBtn?.addTarget(self, action: #selector(editArticle), for: .touchUpInside)
        backView.addSubview(editBtn!)
        editBtn?.setImage(#imageLiteral(resourceName: "release_edit"), for: .normal)
        editBtn?.snp.makeConstraints { (maekr) in
            maekr.right.width.top.equalToSuperview()
            maekr.height.equalToSuperview().multipliedBy(0.5)
        }
        
        let deleteBtn  = UIButton.cz_textButton(" 删除", fontSize: 14, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), backgroundImageName: "")
            deleteBtn?.setImage(#imageLiteral(resourceName: "release_del"), for: .normal)
        deleteBtn?.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        backView.addSubview(deleteBtn!)
        deleteBtn?.snp.makeConstraints { (maekr) in
            maekr.right.width.bottom.equalToSuperview()
            maekr.height.equalToSuperview().multipliedBy(0.5)
        }


        
    }
    
     @objc private func editeBtnClick() {
           backView.isHidden = !backView.isHidden
        
       }
    
    @objc private func deleteBtnClick() {
          backView.isHidden = !backView.isHidden
        
        NetworkerManager.shared.deleteArticle(article?.id ?? "") { (isSuccess , code ) in
            if isSuccess {
                if self.deleteComplict != nil {
                    self.deleteComplict!()
                }
               self.navigationController?.popViewController(animated: true)
            }else{
                
            }
        }
        
    }
    
    @objc private func shareViewHidden() {
        
        self.shareView.isHidden = false
        
    }
    
    
    @objc private func rightItmClick() {
        
        backView.isHidden = true
        AppDelegate.shareUrl(Photo_Path + (article?.articleUrl ?? ""), imageString: article?.cover ?? "", title: article?.title ?? "", descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范", viewController: self, .wechatSession)
    }
}

///wkwebview  : WKScriptMessageHandler , WKNavigationDelegate
extension WFMPArticleDetailController : WKNavigationDelegate{
    
    func setWkWebView() {
        
        wkWebView = WFWkWebView(CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height - navigation_height ))
        
        wkWebView.mainController = self
        wkWebView.navigationDelegate = self

        guard let url  = URL(string:htmlString) else{
            return
        }
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        _ = wkWebView.load(request)
        
        //        wkWebView.load(URLRequest(url: url))
        view.addSubview(wkWebView)
        
    }
    
    // 在发送请求之前，决定是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print("在发送请求之前，决定是否跳转")
        
        if navigationAction.targetFrame == nil{
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }
        if navigationAction.request.url?.host == "video.qq.com" ||
            navigationAction.request.url?.host == "v.qq.com" {
            decisionHandler(.allow)
        }

        if navigationAction.request.url?.host ?? "" != "www.medtion.com" &&
            navigationAction.request.url?.host ?? "" != "dev.medtion.com" {
            UIApplication.shared.openURL(navigationAction.request.url!)
            decisionHandler(.cancel)
            return
        }

//        decisionHandler(.allow)
        
        
        let payString : NSString  = navigationAction.request.url?.absoluteString.removingPercentEncoding as! NSString
        
        print(navigationAction.request.url?.absoluteString)
        print("------------------------")
        print(payString)
        
        var  requestString = navigationAction.request.url?.absoluteString
        
        
        if  ((requestString?.contains(".jspx?") == true || requestString?.contains(".html?") == true) &&  requestString?.contains("from=app_ios") == false) && (requestString?.contains("alipay") == false  && requestString?.contains("tenpay") == false){
            
            guard let url  = URL(string: (requestString ?? "") + "&from=app_ios&way=1") else{
                return
            }
            webView.load(URLRequest(url: url))
            decisionHandler(.cancel)
        }else if (requestString?.contains(".jspx")  == true  || requestString?.contains(".html") == true) &&  (requestString?.contains("from=app_ios") == false && requestString?.contains("alipay") == false &&  requestString?.contains("tenpay") == false) {
            
            guard let url  = URL(string: (requestString ?? "") + "?from=app_ios&way=1") else{
                return
            }
            
            webView.load(URLRequest(url: url))
            
            decisionHandler(.cancel)
        }else{
            print("urlString - ", requestString)
            //http://ni.medtion.com/order/alipay.jspx?id=472&orderNumber=HY20180601193952249
          decisionHandler(.allow)
       }
        
                
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

}

