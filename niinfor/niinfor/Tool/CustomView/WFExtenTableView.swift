//
//  WFExtenTableView.swift
//  QiangShengPSI
//
//  Created by 王孝飞 on 2017/8/22.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFExtenTableView: UITableView,UITableViewDelegate,UITableViewDataSource {


    var viewCount : Int?  //= 0
    var  itemSize : CGSize? //= CGSize(width: 0, height: 0)
    
    convenience init(_ count  : Int = 0, origin point : CGPoint ,itemSize size : CGSize) {
        
         var s = size
        s.height *= CGFloat(count)
        
        self.init(count,frame: CGRect(origin: point, size: s), style: .plain)
        
        itemSize = size
        tableFooterView = UIView()
        delegate = self
        dataSource = self
        
        bounces = false
        register(UINib.init(nibName: "WFExtensionTableViewCell", bundle: nil), forCellReuseIdentifier: "WFExtensionTableViewCell")
        
    }
    
    
     init(_ count : Int = 0, frame: CGRect, style: UITableViewStyle) {
        
        viewCount = count
        itemSize = frame.size
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    override var isHidden: Bool{
        
        didSet{
            
            if isHidden == true {
                
                var height = self.frame
                
                height.size.height = CGFloat(44 * self.viewCount!)
                
                self.frame = height

                
            UIView.animate(withDuration: 0.5, delay: 0, options: .transitionFlipFromBottom, animations: {
                
                var height = self.frame
                
                height.size.height = 0
                
                self.frame = height
                
            }) { (_) in
//                var height = self.frame
//                
//                height.size.height = CGFloat(44 * self.viewCount!)
//                
//                self.frame = height
            }
                
            }
            else{
                var height = self.frame
                
                height.size.height = 0
                
                self.frame = height

                UIView.animate(withDuration: 0.2, delay: 0, options: .transitionFlipFromTop, animations: {
                    
                    var height = self.frame
                    
                    height.size.height = CGFloat(44 * self.viewCount!)
                    
                    self.frame = height
                    
                }) { (_) in
      
                }}
                
                if isHidden == true {
                
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                        
                        super.isHidden = self.isHidden
                        
                    })
                
                }else{
                
                    super.isHidden = isHidden
                }
            }
            
        }
        
    
    
}

extension WFExtenTableView {
    
    @available(iOS 2.0, *)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewCount!
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let  cell  = dequeueReusableCell(withIdentifier: "WFExtensionTableViewCell") as? WFExtensionTableViewCell

        cell?.label.text = "你是谁"
        
        return cell!

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return itemSize!.height
    }
    
}
