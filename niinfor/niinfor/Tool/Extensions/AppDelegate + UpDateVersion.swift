//
//  AppDelegate + UpDateVersion.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/8/10.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import AFNetworking

extension AppDelegate{
    
    /**/
    
     func updateVersion() {
        
        let dict  = Bundle.main.infoDictionary
        
        let currentVersion  = dict?["CFBundleShortVersionString"] as? String
        
        NetworkerManager.shared.post("http://itunes.apple.com/lookup?id=1049283424", parameters: [:], progress: nil, success: { (dataTask, json) in
            
            guard let json = json as? [String : AnyObject] else{return}
            
            let array = json["results"]
            
            let dictionary = array?.lastObject as? [String : AnyObject]
            
            let pastString = dictionary?["version"]
            
            if pastString?.compare(currentVersion ?? "") == ComparisonResult.orderedDescending {
                
                let vc = UIAlertController(title: "新版本升级", message: "你当前版本是V\(String(describing: currentVersion ?? "") )，发现新版本为V\(String(describing: pastString ?? "" as AnyObject))，是否下载新版本？", preferredStyle: .alert)
                
                let actionCancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let actionEnsure = UIAlertAction(title: "更新", style: .default, handler:{ (alert) in
                    
                UIApplication.shared.openURL(URL(string: "http://itunes.apple.com/cn/app/shen-wai-zi-xun/id1049283424?mt=8")!)
                    
                })
                
                vc.addAction(actionCancel)
                vc.addAction(actionEnsure)
                
                self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                
            }
            
            
        }) { (dataTask, error ) in
            
        }
        
        
    }
    
}
