//
//  WFWebVIew.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/11.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFWebVIew: UIWebView {

    override func loadRequest(_ request: URLRequest) {
        
        let  requestString = request.url?.absoluteString
        
        if requestString?.contains(".jspx?") == true {
         
        guard let url  = URL(string: (requestString ?? "") + "&from=app") else{
                return
        }
            super.loadRequest(URLRequest(url: url))
        }else if requestString?.contains(".jspx") == true{
            
            guard let url  = URL(string: (requestString ?? "") + "?from=app") else{
                return
            }
            super.loadRequest(URLRequest(url: url))
        }else{
            
            super.loadRequest(request)
            
        }
        
    }
}
