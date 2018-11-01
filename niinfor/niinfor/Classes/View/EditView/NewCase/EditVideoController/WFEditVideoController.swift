//
//  WFEditVideoController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/5.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFEditVideoController: UIViewController {

    var videoPath = ""
    var complict : ((String)->())?
    
    var isOnlylook = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        VideoClipTool.showTool(isOnlylook,self,videoPath: videoPath , baseView: self.view) {[weak self] (path) in
            
            if let complict = self?.complict {
                   complict(path)
            }
            print("视频地址:\(path)")
            self?.dismiss(animated: true, completion: nil)
        }
    }

}
