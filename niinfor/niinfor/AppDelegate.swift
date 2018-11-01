
//
//  AppDelegate.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

var userList = [WFMessageModel]()

import UIKit
import AVFoundation
import SVProgressHUD

var isNotification = false

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var isRotation  = false
    
    var window: UIWindow?
    
    var networkStatusCode : Int = 0
    
    
//    func CustomUncaughtExceptionHandler() -> @convention(c) (NSException) -> Void {
//        return { (exception) -> Void in
//            let arr = exception.callStackSymbols//得到当前调用栈信息
//            let reason = exception.reason//非常重要，就是崩溃的原因
//            let name = exception.name//异常类型
//
//            NSLog("exception type : \(name) \n crash reason : \(String(describing: reason)) \n call stack info : \(arr)");
//
//
//        }
//    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        AVAudioSession *session = [AVAudioSession sharedInstance];
//
//        [session setActive:YES error:nil];
//
//        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        UIScreen.forceScreen()
        //NSSetUncaughtExceptionHandler(CustomUncaughtExceptionHandler())
        
        if  let userInfo = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] {
            
            isNotification = true
            
        }
        
        window = UIWindow(frame: CGRect(x: 0, y: 0, width: Screen_width, height: Screen_height))
        
        window?.rootViewController = MainViewController()
        
        window?.makeKeyAndVisible()
        
        setUmengShare("")
        
        f_jpushOriginalSet(launchOptions: launchOptions)
        
//        updateVersion()
    
        SVProgressHUD.setMinimumDismissTimeInterval(0.75)
        loadData()
        
//        NSURLCache *urlCache = [[NSURLCache alloc]initWithMemoryCapacity:25*1024*1024 diskCapacity:100*1024*1024 diskPath:nil];
        

        let urlCache = URLCache.init(memoryCapacity: 25*1024*1024, diskCapacity: 25*1024*1024, diskPath:"/Users/fei/Desktop/Book" )
            URLCache.shared = urlCache
        
        return true
    }
    
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print("------------")
        print(url)
        print(options)
        print("------------")
        
        
        var  result = UMSocialManager.default().handleOpen(url as URL?, options: options)
        if result == false{

        
        result = true
        if url.scheme ==  "www.medtion.com" {

        let urlString = url.absoluteString as NSString
        
        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
            
        if  urlString.contains("info"){
            
          let vc = WFAriticleViewController()
            vc.htmlString = Photo_Path + urlString.substring(from: 18)
            vc.isInfo = true
            controler?.pushViewController(vc , animated: true)

        }else {
            let  vc  = WFVideoDetailController()
            vc.htmlString = Photo_Path + urlString.substring(from: 18)
            
            controler?.pushViewController(vc , animated: true)
            }
        }
        }
        return result
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        
        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        if mainContoller?.selectedIndex == 3 {
            
            let controler = mainContoller?.viewControllers?[(mainContoller?.selectedIndex)!] as? WFNavigationController
            controler?.childViewControllers.last?.viewDidAppear(false)
            
        }
    }

    
    ///管理全屏
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {

        return isRotation  ? .all : .portrait
    }
    
    
    
    //保存数据
    func saveData() {
        let data = NSMutableData()
        //申明一个归档处理对象
        let archiver = NSKeyedArchiver(forWritingWith: data)
        //将lists以对应Checklist关键字进行编码
        archiver.encode(userList, forKey: "userList")
        //编码结束
        archiver.finishEncoding()
        //数据写入
        data.write(toFile: dataFilePath(), atomically: true)
    }
    
    //读取数据
    func loadData() {
        //获取本地数据文件地址
        let path = self.dataFilePath()
        //声明文件管理器
        let defaultManager = FileManager()
        //通过文件地址判断数据文件是否存在
        if defaultManager.fileExists(atPath: path) {
            //读取文件数据
            let url = URL(fileURLWithPath: path)
            let data = try! Data(contentsOf: url)
            //解码器
            let unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            //通过归档时设置的关键字Checklist还原lists
            userList = unarchiver.decodeObject(forKey: "userList") as! Array
            //结束解码
            unarchiver.finishDecoding()
        }
    }
    
    //获取沙盒文件夹路径
    func documentsDirectory()->String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                        .userDomainMask, true)
        let documentsDirectory = paths.first!
        return documentsDirectory
    }
    
    //获取数据文件地址
    func dataFilePath ()->String{
        return self.documentsDirectory().appendingFormat("/userList.plist")
    }
    
}

