//
//  MainViewController.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/7/12.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
class MainViewController: UITabBarController {

//   lazy var timer  = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timerScholer), userInfo: nil, repeats: true)
    
    //Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timerScholer), userInfo: nil , repeats: true)
        //Timer(timeInterval: 15, target: self, selector: #selector(timerScholer), userInfo: nil, repeats: true)

    let tabbarHeight : CGFloat = isIphoneX ? 95 : 60
    
    // MARK: - 私有控件
    lazy var composeButton: UIButton = {
         let but = UIButton.init()
         but.setImage(#imageLiteral(resourceName: "homead"), for: .normal)
         return but
    }()
    
    var timer : Timer?
    ///倒计时timer
    var  imageTimer : Timer?
    var  screenImage : UIImageView?
    var  jumpBtn : UIButton = UIButton()
    var  screenSecond = 2

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(self.tabBar.frame)
        
        //SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
        
        //设置主界面
//        setUpUI()
        setupTimer()
        
        setLunchScreenImage()
//        timer.fireDate = Date.distantPast
      }
    
   @objc private func timerScholer() {
        
        let item  = tabBar.items?[3]
        
        item?.badgeValue = userList.count == 0 ? nil : "\(userList.count)"
    }
    
    deinit {
        timer!.invalidate()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func  loadUserData(){
        
        ///MARK: 修改-----------
       if  NetworkerManager.shared.userCount.isLogon != true   {
        
        //let username  = UserDefaults.standard.value(forKey: user_username) as? String,
        //let password  = UserDefaults.standard.value(forKey: user_password) as? String
        
          guard let userid  = UserDefaults.standard.value(forKey: user_userid) as? String else {
                return
        }

           NetworkerManager.shared.getUserByLogin(userid) { (isSuccess ) in
            
            if isSuccess == true {
                
                
                if NetworkerManager.shared.userCount.isPerfectInformation == "F" {
                    
                    let vc = WFPersonalInforViewController()
                    vc.isNextStep = true
                    
                    let controler = self.viewControllers?[0] as? WFNavigationController

                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                        
                        controler?.pushViewController(vc, animated: true)
                        
                    })
                    
                    return
                }
                
                AppDelegate.jpush_regest(set: [NetworkerManager.shared.userCount.id ?? ""], alias:NetworkerManager.shared.userCount.mobile ?? "")
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
            }else{
                NetworkerManager.shared.userCount = WFUserAccount()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
                UserDefaults.standard.removeObject(forKey: "selectList")
                
                AppDelegate.jpush_logout()
                
//                UserDefaults.standard.removeObject(forKey: user_username)
//                UserDefaults.standard.removeObject(forKey: user_password)
                UserDefaults.standard.removeObject(forKey: user_userid)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_notLogout_clean_cookie), object: nil)
                
                //navigationController?.popToRootViewController(animated: true)
                
            }
        }
        }
    }
    
    /// 设置横竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
            return .portrait
    }
    }

// MARK: - 设置界面
extension MainViewController{
    
    func setUpUI(){
        
        if  UserDefaults.standard.value(forKey: user_data_mainKey) == nil {
            
            UserDefaults.standard.set(100000, forKey: user_data_mainKey)
        }
        
        if  UserDefaults.standard.value(forKey: user_class_video_mainKey) == nil {
            
            UserDefaults.standard.set(1000000, forKey: user_class_video_mainKey)
        }

        
        let bacV  = WFCustomTabbarBacView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: tabbarHeight))
        bacV.backgroundColor = UIColor.white
        tabBar.addSubview(bacV)
        
        self.tabBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        self.tabBar.backgroundImage = UIImage.createImage(with: UIColor.clear)
        self.tabBar.shadowImage = UIImage.createImage(with: UIColor.clear)
        
        var array = [UIViewController]()
        
        let dict = [
            ["classname":"WFHomeViewController","title":"首页","imageName":"home"],
            ["classname":"WFMeetingViewController","title":"会议","imageName":"meeting"],
            ["classname":"slsls","title":"会议","imageName":"meeting"],
            ["classname":"WFVideoViewController","title":"直录播","imageName":"video"],
            ["classname":"WFProfileViewController","title":"我的","imageName":"profile"]
        ]
        
        for dictnary in dict {
            
            array.append(setUpChildViewContoller(dictionaru: dictnary))
        }
        
        viewControllers = array
        
    }
    
    ///添加子视图
   private func setUpChildViewContoller( dictionaru : [String:String]) -> UIViewController{
        
        guard let clasNmae = dictionaru["classname"] ,
            let title = dictionaru["title"] ,
            let imagename = dictionaru["imageName"]
            
            else {
                return  UIViewController()
        }
        
        guard  let viewContollerClass = NSClassFromString(Bundle.main.namespace + "." + clasNmae) as? UIViewController.Type
            else{
            return  UIViewController()
        }
        
        //创建子视图
        let clas  = viewContollerClass.init()
        
        clas.title = title
        clas.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), NSFontAttributeName : UIFont.systemFont(ofSize: 11) ], for: .selected)

        clas.tabBarItem.image = UIImage(named:"home_tabbar_" + imagename + "_normal")?.withRenderingMode(.alwaysOriginal)
        clas.tabBarItem.selectedImage = UIImage(named:"home_tabbar_" + imagename + "_selected")?.withRenderingMode(.alwaysOriginal)
        let offset : CGFloat = isIphoneX ? 34 : 0
        clas.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: isIphoneX ? 0 : -3)
        clas.tabBarItem.imageInsets = UIEdgeInsetsMake(tabbarHeight - 44 - 10 - offset, 0 , -(tabbarHeight - 44 - 10 - offset),0)
        let nav  = WFNavigationController(rootViewController: clas)
    
        return nav
    }
    
}


extension MainViewController{
    
    /// 定义时钟
     func setupTimer() {
        
        // 时间间隔建议长一些
        timer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        timer?.fireDate = Date.distantFuture
    }
    
    /// 时钟触发方法
    @objc private func updateTimer() {
        
        if !NetworkerManager.shared.userCount.isLogon {
            return
        }
        
            // 设置 首页 tabBarItem 的 badgeNumber
            self.tabBar.items?[3].badgeValue = userList.count > 0 ? "\(userList.count)" : nil
        }
}
///设置启动图
extension MainViewController{
    
    func setLunchScreenImage() {
        screenImage = UIImageView.init(frame: CGRect(x: 0, y: 0, width: Screen_width, height: Screen_height))
        
        screenImage?.isUserInteractionEnabled = true
        ///26121530515848_.pic_hd.jpg 375
        ///651528887901_.pic_hd.pic_hd.jpg X
        ///661528887901_.pic_hd.pic_hd.jpg plus
        
        if Screen_width * 2  == 1125 {
            screenImage?.image = #imageLiteral(resourceName: "651528887901_.pic_hd")
        }else if Screen_width * 2  == 1242 {
            screenImage?.image = #imageLiteral(resourceName: "661528887901_.pic_hd")
        }else{
            screenImage?.image = #imageLiteral(resourceName: "641528887900_.pic_hd")
        }
        
        self.view.addSubview(screenImage!)
        
        let btnWidth = 70
        
        let bacView  = UIView.init(frame: CGRect(x: Screen_width - CGFloat(btnWidth + 15 ) , y: CGFloat(navigation_height - 39 ) , width: CGFloat(btnWidth), height: CGFloat(btnWidth - 40 )))
        
        bacView.backgroundColor = .black
        bacView.layer.cornerRadius = 2
        bacView.alpha = 0.6
        screenImage?.addSubview(bacView)
        
        
        jumpBtn  = UIButton.init(frame: bacView.frame)
        
        jumpBtn.setTitle("跳过(\(screenSecond))", for: .normal)
        jumpBtn.tintColor = .black
        jumpBtn.layer.cornerRadius = 2
        jumpBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        jumpBtn.addTarget(self, action: #selector(btnClick(btn:)), for: .touchUpInside)
        
        screenImage?.addSubview(jumpBtn)
        
        imageTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecreace), userInfo: nil, repeats: true)
        
    }
    
    @objc func btnClick(btn : UIButton) {
        removeView()
    }
    
    func timerDecreace() {
        
        if screenSecond != 0 {
            screenSecond = screenSecond - 1
            jumpBtn.setTitle("跳过(\(screenSecond))", for: .normal)
        }else{
            removeView()
        }
    }
    
   ///启动完成
   private func removeView() {
        screenImage?.removeFromSuperview()
        imageTimer?.invalidate()
        timer?.fireDate = Date.distantPast
        loadUserData()
        setUpUI()
        setupComposeButton()
    }
    
}

extension MainViewController{
    
    /// 设置撰写按钮
     func setupComposeButton() {
        tabBar.addSubview(composeButton)
        
        // 计算按钮的宽度
        let count = CGFloat(childViewControllers.count)
        // 将向内缩进的宽度
        let w = tabBar.bounds.width / count
        
        // CGRectInset 正数向内缩进，负数向外扩展
        composeButton.frame = tabBar.bounds.insetBy(dx: 2 * w, dy: isIphoneX ? -30 : -50)
        composeButton.imageEdgeInsets = UIEdgeInsets.init(top: isIphoneX ? -20 : 0, left: 0, bottom: 0, right: 0)
        print("撰写按钮宽度 \(composeButton.bounds.width)")
        
        // 按钮监听方法
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
        
        
    }
    
    @objc private func composeStatus() {
        print("撰写病例")
        
        let vc = WFEditViewController()
        
        vc.view.backgroundColor = UIColor.white
        
        let nav  = WFNavigationController.init(rootViewController: vc)
        
            
        present(nav, animated: true, completion: nil)
    }
    
    override func viewWillLayoutSubviews() {
        
        var frame  = tabBar.frame
        frame.size.height = tabbarHeight
        frame.origin.y = self.view.frame.size.height - tabbarHeight
        tabBar.frame = frame
        self.tabBar.barStyle = .default
        
    }
}






















