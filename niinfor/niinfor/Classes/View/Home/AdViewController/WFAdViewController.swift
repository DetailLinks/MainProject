//
//  WFAdViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//




import UIKit
import JavaScriptCore
import WebKit

class WFAdViewController: BaseViewController {
    @IBOutlet weak var webView: UIWebView!

    var htmlString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpWebView()
    }

}

///设置界面
extension WFAdViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        //navItem.title = "广告"
        
        
    }
}

///加载广告视图
extension WFAdViewController:UIWebViewDelegate{
    
    func setUpWebView() {
       
        guard let url  = URL(string: htmlString) else{
            return
        }
        webView.delegate = self
        let request = NSMutableURLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
        request.httpMethod = "GET"
        request.setValue("http://www.medtion.com", forHTTPHeaderField: "Referer")
        
        webView.loadRequest(request as URLRequest)
        webView.scalesPageToFit = true
        webView.scrollView.bounces = false
        
    }
    
//    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
//
//        let header  = request.allHTTPHeaderFields
//        print(request.url?.absoluteString)
//        print(request.url?.absoluteString.removingPercentEncoding)
//
//        let hasRefer = header!["Referer"] != nil
//
//        if hasRefer {
//
//            print(header)
//            print("--------------------1")
//            if #available(iOS 10.0, *) {//// "weixin://sflsflsjflsfls"//"alipays://sddfsdfs"
//                UIApplication.shared.open(request.url! , options: [UIApplicationOpenURLOptionUniversalLinksOnly:false], completionHandler: { (_ ) in
//
//                })
//            } else {
//
//                UIApplication.shared.openURL(request.url!)
//
//            }
//
//            return true
//        }else{
//            print("--------------------2")
//            DispatchQueue.global().async {
//                DispatchQueue.main.async {
//
//
//                    let request = NSMutableURLRequest(url: request.url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)
//                    request.httpMethod = "GET"
//                    request.setValue("http://www.medtion.com", forHTTPHeaderField: "Referer")
//
//                    webView.loadRequest(request as URLRequest)
//
//
//                }
//            }
//            return false
//
//        }
//    }
}









