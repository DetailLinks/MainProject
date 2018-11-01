//
//  WFNavigationBar.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/11/6.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFNavigationBar: UINavigationBar {


    override func layoutSubviews() {
        super.layoutSubviews()



        if #available(iOS 11, *) {

            for view   in subviews{

                if (NSStringFromClass(type(of: view)) as NSString).components(separatedBy: ".").last!.contains("Background"){

                    view.frame = bounds
                }else if
                    (NSStringFromClass(type(of: view)) as NSString).components(separatedBy: ".").last!.contains("ContentView"){

                    var frameBouns = view.frame

                    frameBouns.origin.y = isIphoneX ? 44 : 20

                    frameBouns.size.height = 44

                    view.frame = frameBouns

                }
            }

        } else {


        }
    }
}
