//
//  FANavigationController.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/7/18.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import WebKit

protocol NavigationClipToPopViewProtocol {
    
    func viewWillPopViewController()->Bool
    //func viewDidPopViewController()
}


class WFNavigationController: UINavigationController {

    
    var contro : BaseViewController?
    
    var clipDelegate : NavigationClipToPopViewProtocol?
    
    var isCanPush = true
    
    var isFirstPush : Bool = true
    
    var isShowBack = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true
    
    }

    ///重写push方法 所有的push都走这一个方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        //viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        let vv = viewController as? BaseViewController
        if  vv?.isShowBack == true || childViewControllers.count > 0{
            //隐藏底部控制栏
            viewController.hidesBottomBarWhenPushed  = true
            
            if let vc = viewController as? BaseViewController {
                
            
            var spaceSize : CGFloat = isFirstPush ? 0 : -20
             
                if #available(iOS 11, *){
                    spaceSize = -20
                }else{
                    spaceSize = 0
                }
                
                
            let item  = UIBarButtonItem(imageString: "nav_icon_back", target: self, action: #selector(popToParent(_:)), isBack: true , fixSpace : spaceSize )
            
            let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
                 spaceItem.width = -10
        
            
                
             contro = vc
             vc.isFirstPush = isFirstPush
             vc.navItem.leftBarButtonItems = [spaceItem,item]
            
             isFirstPush = false
                
            }
        }
        
        isCanPush ? super.pushViewController(viewController, animated: animated) : ()
        isCanPush = false
        DispatchQueue.global().asyncAfter(deadline: DispatchTime.now() + 0.75) {
            self.isCanPush = true
        }
        
    }
    
    func popToParent(_ controlelr : BaseViewController)  {
        if viewControllers.count == 1 {
            self.dismiss(animated: false , completion: nil )
            return
        }
        
        if  let vc = viewControllers[0] as? WFMeetingViewController  {
                 vc.popToParent()
        }
        
        if contro?.wkWebView.backForwardList.currentItem?.url.absoluteString.contains("tumour") == true   {
            popViewController(animated: true) ;  return
        }
    
        if let _ = contro as? WFLoginViewController  {
            
         let viewC = self.viewControllers[self.viewControllers.count - 2] as? BaseViewController
         
            if  viewC?.wkWebView.canGoBack == true {
                
                let item = viewC?.wkWebView.backForwardList.backItem
                viewC?.wkWebView.go(to: item!)
            }
        }
        
        if contro?.wkWebView.backForwardList.currentItem?.url.absoluteString.contains("/cases/index.html") == true || contro?.wkWebView.backForwardList.currentItem?.url.absoluteString.contains("/member/registers.jspx") == true {
            popViewController(animated: false)
            
            return
        }
        
        if  contro?.wkWebView.canGoBack == true {
            
            let item = self.contro?.wkWebView.backForwardList.backItem
            self.contro?.wkWebView.go(to: item!)
           return
        }
        
        if contro?.baseWebview.canGoBack == true {
            
            contro?.baseWebview.goBack()
            return
        }
        
        
        if clipDelegate != nil && (viewControllers.last?.isMember(of: WFNewCaseViewController.self))! {
            let isPop = clipDelegate?.viewWillPopViewController()
            if  isPop! == true {
                popViewController(animated: true)
            }else{
                
            }
            return
        }
           popViewController(animated: true)
        
    }
    
    func popToRoot()  {
        
        popToRootViewController(animated: true)
        
    }

}
///控制横竖屏
extension WFNavigationController {
    override open var shouldAutorotate: Bool {
        
        return  (self.viewControllers.last?.shouldAutorotate)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        

        return  (appdelegate?.isRotation)! ? .all : .portrait //  (self.viewControllers.last?.supportedInterfaceOrientations)!
    }
    
}
//返回跟视图
// let  isDetail  = viewController.isKind(of: UIViewController.self)

//  let item  = isDetail ? UIBarButtonItem(title: "返回", target: self, action: #selector(popToRoot), isBack: true): UIBarButtonItem(title: "返回", target: self, action: #selector(popToParent), isBack: true)
