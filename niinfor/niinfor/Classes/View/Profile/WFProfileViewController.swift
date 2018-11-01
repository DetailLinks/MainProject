//
//  WFProfileViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDWebImage
class WFProfileViewController: BaseViewController {
    
    @IBOutlet weak var tabbarContant: NSLayoutConstraint!
    
   ///适配小屏幕滚动
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let srowV  = tableView.superview as! UIScrollView
        
        srowV.isScrollEnabled = srowV.contentSize.height > Screen_height - (isIphoneX ? 84 : 49)
        
    }
    
//    lazy var timer  = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(timeMinint), userInfo: nil, repeats: true)
//    
//     func timeMinint(){
//        
//        let item  = self.tabBarController?.tabBar.items?[3]
//        
//        item?.badgeValue = userList.count == 0 ? nil : "\(userList.count)"
//    }
    

    
    lazy var dataList : [[[String:String]]] =  {
       
//        let arr = [
//            //第一部分
//            [["image":"message","title":"我的消息" ],
//             ["image":"feedback","title":"意见反馈" ],
//             ["image":"settings","title":"系统设置" ]
//             ],
//            //第二部分
//            [
//            ]
//        ]
    
        let arr = [
            //第一部分
        [  //["image":"order","title":"我的订单" ],
           ["image":"namelist","title":"常用名单" ],
           ["image":"message","title":"我的消息" ],
           ["image":"case","title":"病例讨论" ]
            ],
            //第二部分
            [  ["image":"share","title":"应用分享" ],
               ["image":"feedback","title":"意见反馈" ],
               ["image":"settings","title":"系统设置" ]
            ]
        ]
        return arr
    }()
    
    /// listView
    @IBOutlet weak var tableView: UITableView!

    /// 登录注册按钮
    @IBOutlet weak var loginBtn: UIButton!
    
    /// 会议收藏按钮点击
    @IBAction func meetingBtnClick(_ sender: Any) {
     
        if NetworkerManager.shared.userCount.isLogon == false  {
            
            navigationController?.pushViewController(WFLoginViewController(), animated: true)
            
            return
        }
        
      navigationController?.pushViewController(WFInforCollectionViewController(), animated: true)
    }
    
    func isLogonNow(_ title : String ) {
        
        if NetworkerManager.shared.userCount.isLogon == false  {
            
            navigationController?.pushViewController(WFLoginViewController(), animated: true)
            
            return
        }
        
    }
    
    /// 资讯收藏按钮点击
    @IBAction func inforBtnClick(_ sender: Any) {
        
        if NetworkerManager.shared.userCount.isLogon == false  {
            
            navigationController?.pushViewController(WFLoginViewController(), animated: true)
            
            return
        }

        
        let vc  = WFInforCollectionViewController()
        vc.isMeeingCollection = false
      
         navigationController?.pushViewController(
                                              vc,
                                              animated: true)
    }
    
    /// 视频收藏按钮点击
    @IBAction func videoBtnClick(_ sender: Any) {
        
        if NetworkerManager.shared.userCount.isLogon == false  {
            
            navigationController?.pushViewController(WFLoginViewController(), animated: true)
            
            return
        }

        navigationController?.pushViewController(WFVideoCollectionViewController(), animated: true)
    }
    
    
    /// 登录按钮点击
    @IBAction func loginBtnClick(_ sender: Any) {
        //loginBtnClick(self)
        
        headerButton.isEnabled = false
        loginBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            
            self.headerButton.isEnabled = true
            self.loginBtn.isEnabled = true
            
            
        }

        
        if NetworkerManager.shared.userCount.isLogon == true  {
            return
        }
        
        navigationController?.pushViewController(WFLoginViewController(), animated: true)
    }
    
    @IBOutlet weak var headerButton: UIButton!
    /// 头像视图点击
    @IBAction func iconViewClick(_ sender: Any) {
        
        headerButton.isEnabled = false
        loginBtn.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()) {
            
            self.headerButton.isEnabled = true
            self.loginBtn.isEnabled = true
            
            
        }

        
        if NetworkerManager.shared.userCount.isLogon == false  {
            
            navigationController?.pushViewController(WFLoginViewController(), animated: true)
            
            return
        }
        
        loadLoginData1()
        
        
    }
    
    ///点击头像进入
    func loadLoginData1() {
        
//        guard let username  = UserDefaults.standard.value(forKey: user_username) as? String,
//            let password  = UserDefaults.standard.value(forKey: user_password) as? String else {
//                return
//        }
        guard let userid  = UserDefaults.standard.value(forKey: user_userid) as? String else {
                return
        }

        NetworkerManager.shared.getUserByLogin(userid) { (isSuccess) in
            
            if isSuccess == true {
               self.navigationController?.pushViewController(WFPersonalInforViewController(), animated: true)
            }
        }
    }

    
    
    @IBOutlet weak var verifiImageView: UIImageView!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var logonBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
        let manager  = SDWebImageManager.shared().imageCache?.getSize()
        
        print(manager)
    }
    
      func loginSuccess() {
        
         //loadLoginData ()
    
          self.view = nil
    }
    
    func loadLoginData() {
        
        guard let username  = UserDefaults.standard.value(forKey: user_username) as? String,
            let password  = UserDefaults.standard.value(forKey: user_password) as? String else {
                return
        }
        
//        let passwordString = SWJiaMi.jiami(username, passWord:password)
//        
//        NetworkerManager.shared.loginRequest(UsernameAndPassword: ["username":username,"password":passwordString ?? ""]) { (isSuccess ) in
//            
//            if isSuccess == true {
//                
//            }
//        }
    }
    
    deinit {
        
//        timer.invalidate()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
}

///设置界面
extension WFProfileViewController{
    
    override func setUpUI(){
        super.setUpUI()
        view.isMultipleTouchEnabled = false
        navItem.title = ""
        removeTabelView()
        
        tabbarContant.constant = isIphoneX ? 84 : 49
        setUpTableView()
        let font = UIFont(name: "PingFangSC-Regular", size: 16)
        
        if  NetworkerManager.shared.userCount.isLogon == true {
            
            let string = NSAttributedString(string: NetworkerManager.shared.userCount.realName ?? "" , attributes: [NSFontAttributeName : font ?? "" ,NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
            
            loginBtn.setAttributedTitle(string, for: .normal)
            
        }else {
            
            let namestring = "登录/注册"
            
            let string = NSAttributedString(string:namestring , attributes: [NSFontAttributeName : font ?? "" ,NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)])
            
            loginBtn.setAttributedTitle(string, for: .normal)
        }
        
        let url = URL(string: NetworkerManager.shared.userCount.avatarAddressString )
        //avatarImageView.sd_setImage(with: url , placeholderImage: #imageLiteral(resourceName: "profile_img_portrait_woman"))
        avatarImageView.sd_setImage(with:url , placeholderImage: NetworkerManager.shared.userCount.gender == "F" ? #imageLiteral(resourceName: "profile_img_portrait_woman") : #imageLiteral(resourceName: "profile_img_portrait_man") )
        
        avatarImageView.updateConstraintsIfNeeded()
        
        var ImageFrame = avatarImageView.frame
        
        ImageFrame.size = CGSize(width: Screen_width * 0.23  , height: Screen_width * 0.23)
        
        avatarImageView.frame = ImageFrame
        
        avatarImageView.layer.cornerRadius = Screen_width * 0.115
            //avatarImageView.xf_height / 2.0
        avatarImageView.clipsToBounds = true
        
        ///认证图标
        verifiImageView.image = NetworkerManager.shared.userCount.isAuth == 1 ? #imageLiteral(resourceName: "profile_icon_certified")  : #imageLiteral(resourceName: "profile_icon_uncertified")
        
//          timer.fireDate = Date.distantPast
    }
    
    /// 设置tableView
    private func setUpTableView() {
        
        tableView.tableFooterView = UIView()
        
        tableView.delegate = self
        tableView.dataSource = self
        ///注册cell
        tableView.register(UINib.init(nibName:WFSettingTableViewCell().identfy,
                                                        bundle: nil),
                                                        forCellReuseIdentifier: WFSettingTableViewCell().identfy)
        
        tableView.reloadData()
    }
    
}

// MARK: - tableView 代理方法
extension WFProfileViewController{
    
  /*  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            

            switch indexPath.row {

                
            case 0:
                if NetworkerManager.shared.userCount.isLogon == false  {
                    
                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
                    
                    return
                }

                navigationController?.pushViewController(WFMessageViewController(), animated: true)
            case 1:
                if NetworkerManager.shared.userCount.isLogon == false  {
                    
                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
                    
                    return
                }

                //navigationController?.pushViewController(WFCaseDiscussViewController(), animated: true)
                navigationController?.pushViewController(WFSuggestionViewController(), animated: true)
            case 2:
                navigationController?.pushViewController(WFSystemSettingViewController(), animated: true)
            default:
                break
            }
            
        }else{
        }
        
    }*/
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
//            if NetworkerManager.shared.userCount.isLogon == false  {
//                
//                navigationController?.pushViewController(WFLoginViewController(), animated: true)
//                
//                return
//            }
            
          //  isLogonNow("请登录")
            switch indexPath.row {
           // case 0:
               // navigationController?.pushViewController(WFMyOrderController(), animated: true)
            case 0:
                
                let vc =  WFVideoDetailController()
                vc.title = "常用名单"
                vc.htmlString = Photo_Path + "/member/registers.jspx"
                
                navigationController?.pushViewController(vc, animated: true)
            case 1:
                
                navigationController?.pushViewController(WFMessageViewController(), animated: true)
            
            case 2:
                
                if NetworkerManager.shared.userCount.isLogon == false  {
                    
                    navigationController?.pushViewController(WFLoginViewController(), animated: true)
                    
                    return
                }
                
                navigationController?.pushViewController(WFCaseDiscussViewController(), animated: true)
                
            default:
                break
            }
            
        }else{
            
            switch indexPath.row {
            case 0:
                AppDelegate.shareUrl("http://www.medtion.com/download.html", imageString: "24321528943095_.pic", title: "神外资讯", descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范", viewController: self, .wechatSession)//("", title: "", .wechatSession)
                //navigationController?.pushViewController(WFMyOrderController(), animated: true)
            case 1:
                navigationController?.pushViewController(WFSuggestionViewController(), animated: true)
            case 2:
                navigationController?.pushViewController(WFSystemSettingViewController(), animated: true)
                
            default:
                break
            }
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFSettingTableViewCell().identfy, for: indexPath) as? WFSettingTableViewCell
        
        cell?.dict = dataList[indexPath.section][indexPath.row]
        
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList[section].count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 0 || section == 1{
            return nil
        }
        
        let headerView  = UIView(frame: CGRect(x: 0, y: 0, width: Screen_width, height: 10))
        headerView.backgroundColor = #colorLiteral(red: 0.9215686275, green: 0.9215686275, blue: 0.9215686275, alpha: 1)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0.01
        }
        return 0//原来是10
    }
}

