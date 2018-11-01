//
//  WFArticleDetailViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/10.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFArticleDetailViewController: BaseViewController {
      var htmlString  = ""
}

extension WFArticleDetailViewController {
    override func setUpUI() {
        super.setUpUI()
        
        setWkWebView()
      }
    
     func setWkWebView() {
            
            wkWebView = WFWkWebView(CGRect(x: 0, y: 64, width: Screen_width, height: Screen_height - 64 ))
            
            wkWebView.mainController = self
            
            guard let url  = URL(string:htmlString) else{
                return
            }
            let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
            _ = wkWebView.load(request)
            
            view.addSubview(wkWebView)
        }
    
}
