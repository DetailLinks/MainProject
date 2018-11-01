//
//  BaseViewController.swift
//  FirstAid
//
//  Created by 王孝飞 on 2017/7/12.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import MJRefresh
import WebKit

//import MobClick

class BaseViewController: UIViewController {

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: nibNameOrNil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//        override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//            print("===================")
//            print(Bundle.main.namespace + "." + "\(type(of: self))")
//            super.init(nibName: "\(type(of: self))", bundle: nil)
//        }
//
//        required init?(coder aDecoder: NSCoder) {
//            fatalError("init(coder:) has not been implemented")
//        }

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//
//        let name = NSStringFromClass(type(of: self)).components(separatedBy: ".").last!
//
//        let nib  = UINib.init(nibName: name, bundle: nil)
//
//        if nib.instantiate(withOwner: nil, options: nil).first == nil  {
//            super.init(nibName: nibNameOrNil , bundle: nibBundleOrNil)
//        }else{
//           super.init(nibName: name , bundle: nibBundleOrNil)
//        }
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        let classString = String(describing: type(of: self))
        if Bundle.main.path(forResource: classString, ofType: "nib") == nil {
            print("n-xib")
            print(classString)
            super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
            
        } else {
            print("xib")
            print(classString)
            super.init(nibName: nibNameOrNil ?? classString, bundle: nibBundleOrNil)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isShowBack = false
    
    var isFirstPush = false
    
    var baseWebview = UIWebView()
    
    var emptyView = UIView()
    
    var wkWebView  = WFWkWebView()
    
    var baseTableView = UITableView()
    lazy var cellClassString = ""
     var base_dataList = [AnyObject](){
        didSet{
            self.baseTableView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("父类的awakeFromNib")
    }
    
    
    ///修改
    ///自定义navBar
    lazy var navBar = WFNavigationBar(frame: CGRect(x: 0, y: 0, width: Screen_width, height: navigation_height - 0.5))
    
    ///自定义navItem
     lazy var navItem = UINavigationItem()
    
    //刷新数据的页数
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ///设置界面
      setUpUI()
        
      ///加载数据
      loadData()
      NotificationCenter.default.addObserver(self, selector: #selector(cleanCookie), name:  NSNotification.Name(rawValue: notifi_notLogout_clean_cookie), object: nil)
        
        //注册登录成功刷新数据
//        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccessReloadData), name: NSNotification.Name(rawValue: Notification_LoginSuccess_Clik), object: nil)
    }
    
    @objc private func cleanCookie() {
        
        let  storage  = HTTPCookieStorage.shared
        
        storage.removeCookies(since: Date(timeIntervalSince1970: 0))
        
        let  cookieArray = HTTPCookieStorage.shared.cookies!
        for cookie in cookieArray
        {
            HTTPCookieStorage.shared.deleteCookie(cookie)
        }
        
        removeWKWebViewCookies()
        //HTTPCookieStorage.shared.cookies! = cookieArray
        
//        for cookie in storage {
//            storage.deleteCookie(cookie)
//        }
        
    }
  func removeWKWebViewCookies(){ //iOS9.0以上使用的方法
        if #available(iOS 9.0, *) {
            let dataStore = WKWebsiteDataStore.default()
            dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), completionHandler: { (records) in for record in records{
            //清除本站的cookie 
            //       if record.displayName.contains("medtion") || record.displayName.contains("medtion.how2go") {
                //这个判断注释掉的话是清理所有的cookie 
            WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: { //清除成功
                    print("清除成功\(record)") })
                //}
                } })
        } else {
            //ios8.0以上使用的方法 
            let libraryPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.libraryDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first
            let cookiesPath = libraryPath! + "/Cookies"
            try? FileManager.default.removeItem(atPath: cookiesPath) }
         }
        
        
    ///重写title方法
    override var title: String?
    {
        didSet{
            navItem.title = title
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: notifi_notLogout_clean_cookie), object: nil)
    }
    
//    func isLogonNow(_ title : String ) {
//        
//        if NetworkerManager.shared.userCount.isLogon == false  {
//            
//            navigationController?.pushViewController(WFLoginViewController(), animated: true)
//            
//            return
//        }
//        
//    }
    
         func showAlertController(_ title : String) {
        
        let vc  = UIAlertController(title: "提示", message: title, preferredStyle: .alert)
        let action  = UIAlertAction(title: "确定", style: .cancel, handler: nil)
        vc.addAction(action)
        present(vc, animated: true) { 
            return
        }
        
    }
    
}



// MARK: - 加载数据
extension BaseViewController {
    
    //加载tableView数据
    func loadData(){
        
    }
    
}

// MARK: - 设置tableView
extension BaseViewController:UITableViewDelegate,UITableViewDataSource {
    
    func base_setupTableView(){
        
     view.addSubview(baseTableView)
     baseTableView.frame = CGRect(x: 0, y: navigation_height, width: Screen_width, height: Screen_height - navigation_height)
     baseTableView.delegate = self
     baseTableView.dataSource = self
        
     baseTableView.tableFooterView = UIView()
     baseTableView.separatorColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)

     addFreshContol()
     regestCellString("UITableViewCell")
    
    }
    
    //销毁tableView
    func removeTabelView(){
        
        baseTableView.delegate = nil
        baseTableView.dataSource = nil
        
        baseTableView.removeFromSuperview()
    }
    
    
    //添加刷新控件
    func addFreshContol(){
    
        baseTableView.mj_header = MJRefreshStateHeader(refreshingBlock: {[weak self] in
            
            self?.page = 1
            self?.base_dataList.removeAll()
            
            self?.loadData()
            self?.baseTableView.endFresh()
        })
        
        baseTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            self?.page += 1
            self?.loadData()
            self?.baseTableView.endFresh()
        })
        
        
    }
    
    /// 注册cellString
    func regestCellString(_ cellString:String)  {
            cellClassString = cellString
            baseTableView.register(NSClassFromString(cellString).self, forCellReuseIdentifier: cellString)
    }
    
    func regestNibCellString(_ cellString:String) {
        cellClassString = cellString
        baseTableView.register(UINib.init(nibName: cellString, bundle: nil), forCellReuseIdentifier: cellString)
    }
    
    
    
    //MARK: - 代理 数据源
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellClassString, for: indexPath)
        
        if base_dataList.count > 0 {
            cell.setValue(base_dataList[indexPath.row], forKey: "model")
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
         return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return base_dataList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

// MARK: - 设置界面
extension BaseViewController{
    
    ///设置界面
    func setUpUI()  {
    
        automaticallyAdjustsScrollViewInsets = false
        
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        
        //设置navgationBar
        setUpNavigationController()
        //设置tableView
        base_setupTableView()
        
        setEptyMeeting()
    }
    
    func  setEptyMeeting() {
        
        emptyView = UIView(frame: view.frame)
        
        let emptyImage = UIImageView(image: #imageLiteral(resourceName: "空订单拷贝"))
        
       emptyView.addSubview(emptyImage)
        
        emptyImage.center = CGPoint(x: Screen_width / 2, y: emptyView.xf_height / 4)
        
        emptyView.backgroundColor = UIColor.white
        emptyView.isHidden = true
        
        view.addSubview(emptyView)
    }
    
    func setUpNavigationController() {
        
        view.addSubview(navBar)
        
//        navBar.frame = navigationController?.navigationBar.frame ?? CGRect(x: 0, y: 0, width: Screen_width, height: 64)
        
        navBar.items = [navItem]
        
        //改变标题栏 字体大小和颜色
        navBar.titleTextAttributes =
                                                        [NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1) ,
                                                                                NSFontAttributeName : UIFont.init(name: PF_M, size: 18) ?? "" ]
        
        //前景色
        navBar.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            //UIColor(red: 66.0/255, green: 135.0/255, blue: 255.0/255, alpha: 1)
        navBar.shadowImage = UIImage.createImage(with: #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1))
       // navBar.setBackgroundImage(UIImage(), for: .default)
       // navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        //改变背景颜色
       // navigationController?.navigationBar.barStyle = .black
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(title)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(title)
        
    }
}

// MARK: - 添加提示
extension BaseViewController{

    //提示成功
    func showSuccess(notification : Notification){
        
    }
    
    //提示错误
    func showError(error : Error) {
        
    }
    
}


