//
//  WFDetailViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/7.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFDetailViewController: BaseViewController {

    var htmlString = ""
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(begainFullScreen), name: NSNotification.Name.UIWindowDidBecomeVisible, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(endFullScreen), name: NSNotification.Name.UIWindowDidBecomeHidden, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func begainFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = true
        
    }
    
    func endFullScreen() {
        
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = false
        
        UIScreen.rotationScreen()
        
    }
    
}

///设置界面
extension WFDetailViewController:UIWebViewDelegate{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
//        navItem.title = "资讯详情"
            setUpWebView()
        
        baseWebview = webView
    }
    
    func setUpWebView() {
        
        guard let url  = URL(string: htmlString) else{
            return
        }
        
        webView.loadRequest(URLRequest(url: url))
        webView.scrollView.bounces = false
        webView.delegate = self
    }
    
    
}
