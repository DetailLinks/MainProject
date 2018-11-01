//
//  ScroView+MJRefresh.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/7/20.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import Foundation
import MJRefresh

extension UIScrollView {
    
    func addMjrefrest(refreshHeaderClosure:@escaping()->(), refreshFooterClosure:@escaping()->()){
        
        self.mj_header = MJRefreshNormalHeader(refreshingBlock:refreshHeaderClosure)
        
        
        print("mj_header mj_footer ")
        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock:refreshFooterClosure)

//        self.mj_header = MJRefreshNormalHeader(refreshingBlock: {
//
//        })
//
//
//        print("mj_header mj_footer ")
//        self.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//
//        })
    }
    
    func endFresh() {
        
        if mj_header.isRefreshing { mj_header.endRefreshing()}
        if mj_footer.isRefreshing { mj_footer.endRefreshing()}
    }
}
