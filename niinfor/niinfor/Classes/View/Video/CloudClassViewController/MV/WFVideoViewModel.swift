//
//  WFVideoViewModel.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import Foundation
import UIKit
import SDCycleScrollView

class WFVideoViewModel : NSObject{
    var adArray = [WFAdModel]()
    var freeClassArray = [WFFreeClassModel]()
    var recommandClassArray = [WFFreeClassModel]()
    weak var targetController  : WFCloudClassViewController?
    
    override init() {
        super.init()
        loadAdData()
        loadFreeClassData ()
        loadRecommandClassData()
    }
}

extension WFVideoViewModel{
   func loadAdData() {
        NetworkerManager.shared.getVideoAdSolts { (isSuccess, adArray) in
            if isSuccess {
                self.adArray.removeAll()
                self.adArray.append(contentsOf: adArray)
                self.targetController?.mainTableView.reloadData()
            }
        }
    }
    
    func loadFreeClassData () {
        NetworkerManager.shared.getFreeCourse { (isSuccess, adArray) in
            if isSuccess {
                self.freeClassArray.removeAll()
                self.freeClassArray.append(contentsOf: adArray)
                self.targetController?.mainTableView.reloadData()
            }
        }
    }
    
    func loadRecommandClassData() {
        NetworkerManager.shared.getRecommendCoursePage("", "", "", "1") { (isSuccess, adArray) in
            if isSuccess {
                self.recommandClassArray.removeAll()
                self.recommandClassArray.append(contentsOf: adArray)
                self.targetController?.mainTableView.reloadData()
            }
        }
    }
    
}

extension WFVideoViewModel : SDCycleScrollViewDelegate{
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
        let vc  = WFVideoDetailController()
        
        if adArray[index].url ?? "" == "" {
            return
        }
        vc.htmlString = adArray[index].url ?? ""
        
        targetController?.navigationController?.pushViewController(vc , animated: true )
    }

}
