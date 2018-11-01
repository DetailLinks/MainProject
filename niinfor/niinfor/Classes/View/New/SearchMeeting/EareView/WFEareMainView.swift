//
//  WFEareMainView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFEareMainView : UIView {

    @IBOutlet weak var backView: UIView!
    
    var dataList = [WFEducationModel](){
        didSet{
            eareView.array = dataList
            eareView.reloadData()
        }
    }
    
   var  eareView : WFEareView =  WFEareView(CGRect(x: 0, y: 0, width: 0, height: 0))
    
   class  func eareMainView(_ frame : CGRect ) -> WFEareMainView {
        
        let nib = UINib.init(nibName: "WFEareMainView", bundle: nil)
        
         let v = nib.instantiate(withOwner: nil, options: nil)[0] as! WFEareMainView
        
         v.frame = frame
    
        v.createEareView()
    
        return v
    }
    
    func createEareView() {
        
        eareView =  WFEareView(backView.frame)
        
        addSubview(eareView)
        
    }
    
}
