//
//  WFNewVideoViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/14.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import AliyunVodPlayerSDK
import AliyunVodPlayerViewSDK
import MJRefresh
import RealmSwift
class WFNewVideoViewController: BaseViewController {

    let realm  = try! Realm()
    
    var className  = ""{
        didSet{
            slideView.className = className
        }
    }
    var classImage = ""
    
    
    var classId  = ""{
        didSet{
            loadClassDetail()
            loadCommantList()
            loadRelventClass()
            slideView.classId = classId
        }
    }
    
    
    var videoClassListModel  : WFVideoClassModel = WFVideoClassModel(){
        didSet{
            if videoModel.vid != "" {
                for item in videoClassListModel.videoList{
                    if item.vid == videoModel.vid{
                        item.isDefaultModel = true
                    }
                }
            }
            slideView.videoClassListModel = videoClassListModel
            
            
            downLoadView.className = className
            downLoadView.classimage = classImage
            downLoadView.classid = classId
            
            let videoArr = realm.objects(MainClassVideoStoreModel.self)
            if videoArr.isEmpty {
                downLoadView.videoClassListModel = videoClassListModel
                return
            }
            for item  in videoArr {
                if item.classId == classId {
                   downLoadView.saveModel = item
                   downLoadView.isSaveClass = true
                   downLoadView.videoClassListModel = videoClassListModel
                   return
                }
            }
            downLoadView.videoClassListModel = videoClassListModel
        }
    }
    
    
    var videoModel  : WFDetailVideoModel = WFDetailVideoModel(){
        didSet{
            if !videoClassListModel.videoList.isEmpty {
                for item in videoClassListModel.videoList{
                    if item.vid == videoModel.vid{
                        item.isDefaultModel = true
                    }
                }
            }
            slideView.detailModel = videoModel
        }
    }
    
    var commontPage = 1
    
    var commantModel : [WFCommentListModel]  = []{
        didSet{
            slideView.commantModel = commantModel
        }
    }
    
    var currentClass : [WFFreeClassModel] = []{
        didSet{
            slideView.currentClass = currentClass
        }
    }
    var playPath = ""
    var playVid = ""
    var isOfflinePlay = false{
        didSet{
            slideView.isHidden = true
        }
    }
    /*
     1e0efe4573404f248fcfddf5d81321d8
     bb17caa7bf9c40a0a466388cea8e9505
     bb17caa7bf9c40a0a466388cea8e9505
     d8c420d2093e454889e7a94dcd849a9b
     */
    fileprivate var videoID:String = ""{
        didSet{
           let model = realm.objects(MainClassVideoStoreModel)
            for classModel  in model {
                if classModel.classId == self.classId{
                    for videoModel in classModel.models{
                        if videoModel.vid == self.videoID && videoModel.downloadStatus == 2{
                            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                                            .userDomainMask,  true).first! + "/" + videoModel.videoPath.split(separator: "/").last!
                            self.aliyunVodPlayer?.playPrepare(with: URL(fileURLWithPath:paths ))
                            return
                        }
                    }
                }
            }
            loadViewData()
        }
    }
   fileprivate var playAuth:String = "" {
        didSet{
//            if playUrl != "" {
//               return
//            }
            self.aliyunVodPlayer?.playPrepare(withVid: self.videoID, playAuth: self.playAuth)
        }
    }
    
    ///控制锁屏
    fileprivate var isLock = false
    ///视屏播放主界面
    fileprivate var aliyunVodPlayer:AliyunVodPlayerView?
    //进入前后台时，对界面旋转控制
    fileprivate var isBecome = false
    //进入前后台时，对界面旋转控制

    fileprivate let downLoadView = WFDownloadView.init(frame: CGRect.zero)
    fileprivate var downloadConstriant : CGFloat = 1000
    
    fileprivate var isStatusHidden : Bool = false
//    {
//        return (self.navigationController?.navigationBar.isHidden)!
//    }
    
    fileprivate var iphoneType : String{
        return WFDevice.iphoneType()
    }
    
    var chooseView : WFChooseView?
    ///滑动视图
    fileprivate var slideView  = WFVideoSlideView.init(frame: CGRect.zero)
    fileprivate var timer : Timer?
    deinit {
        aliyunVodPlayer?.stop()
        aliyunVodPlayer?.releasePlayer()
        aliyunVodPlayer?.removeFromSuperview()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
    }
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        aliyunVodPlayer?.pause()
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
}
extension WFNewVideoViewController{
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
        
        if isOfflinePlay {
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory,
                                                            .userDomainMask,  true).first! + "/" + playPath.split(separator: "/").last!
            self.aliyunVodPlayer?.playPrepare(with: URL(fileURLWithPath:paths ))
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: false)
    }
    
    @objc func commentSuccessNotification() {
          loadCommantList()
    }
    
    @objc func deleteBtnClick(){
        downLoadView.snp.updateConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!).offset(1000)
        }
        UIView.animate(withDuration: 0.4, animations: {
            self.downLoadView.layoutIfNeeded()
        }) { (istrue) in
            self.downLoadView.isHidden = true
        }
        downloadConstriant = 1000
    }
    
    @objc func currentClassNotification(_ notify : Notification) {
        guard let dict  = notify.object as? [String : String] else { return }
        classId = dict["classId"] ?? ""
        classImage = dict["classImage"] ?? ""
        className = dict["className"] ?? ""
        
    }
    
    @objc func cacheBtnClick( _ btn : UIButton) {
        
        let vc   = WFCacheManagerController.share
        vc.isShowBack = true
        let nav  = WFNavigationController.init(rootViewController: vc)
            deleteBtnClick()
//        var list  = [WFVideoListModel]()
//        for model  in downLoadView.videoClassListModel.videoList {
//            if model.isSelectDownload == true{
//               list.append(model)
//            }
//        }
        
//        vc.videoClassListModel = videoClassListModel
        self.present(nav, animated: true, completion: nil)
    }
}


extension WFNewVideoViewController {
    
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        setVideoView()
        
        view.addSubview(slideView)
        slideView.delegate = self
        slideView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!)
        }
        slideView.clipsToBounds = true
        slideView.thirdTableView.mj_header = MJRefreshStateHeader(refreshingBlock: {[weak self] in
            
            self?.commontPage = 1
            self?.commantModel.removeAll()
            
            self?.loadCommantList()
            self?.slideView.thirdTableView.endFresh()
        })
        
        slideView.thirdTableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {[weak self] in
            self?.commontPage += 1
            self?.loadCommantList()
            self?.slideView.thirdTableView.endFresh()
        })
        
        view.addSubview(downLoadView)
        
        downLoadView.cacheManagerBtnView.addTarget(self, action: #selector(cacheBtnClick(_:)), for: .touchUpInside)
        downLoadView.isHidden = true
        downLoadView.topDeleteBtnView.addTarget(self, action: #selector(deleteBtnClick), for: .touchUpInside)
        downLoadView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!).offset(1000)
        }


        NotificationCenter.default.addObserver(self,
                                               selector: #selector(becomeActive),
                                               name: NSNotification.Name.UIApplicationDidBecomeActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(resignActive),
                                               name: NSNotification.Name.UIApplicationWillResignActive,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(commentSuccessNotification),
                                               name: NSNotification.Name(rawValue: notifi_comment_success_notify),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(currentClassNotification(_:)),
                                               name: NSNotification.Name(rawValue: notifi_current_class_notify),
                                               object: nil)


    }
    
     fileprivate func setVideoView() {
        let viewC = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: 20))
        viewC.backgroundColor = UIColor.black
        view.addSubview(viewC)
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
        appdelegate?.isRotation = true
        ///
        self.navigationController?.navigationBar.isHidden = true
        
        var width     : CGFloat = 0
        var height    : CGFloat = 0
        var topHeight : CGFloat = 0
        
        let orientation = UIApplication.shared.statusBarOrientation
        if (orientation == .portrait ) {
            width = Screen_width
            height = Screen_width * 9 / 16.0
            topHeight = 20
        }else{
            width = Screen_width
            height = Screen_height
            topHeight = 0
        }
        aliyunVodPlayer = AliyunVodPlayerView(frame: CGRect(x: 0, y: topHeight, width: width ,height: height), andSkin: AliyunVodPlayerViewSkin.blue)
        aliyunVodPlayer?.delegate = self
        aliyunVodPlayer?.setAutoPlay(true)
        aliyunVodPlayer?.circlePlay = false
        aliyunVodPlayer?.fixedPortrait = false
        self.isLock = (aliyunVodPlayer?.isScreenLocked ?? false || aliyunVodPlayer?.fixedPortrait ?? false) ? true : false
        aliyunVodPlayer?.isScreenLocked = isLock
        view.addSubview(aliyunVodPlayer!)
        
        ///设置缓存文件
        setCacheForPlaying()
        
        ///查看缓存文件时候打开
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(timeRun), userInfo: nil , repeats: true)
        
    }
    
    fileprivate func setCacheForPlaying(){
        //缓存设置
        let path = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        aliyunVodPlayer?.setPlayingCache(false, saveDir: path, maxSize: 30, maxDuration: 10000)
    }

    
    func timeRun() {
        
    }
    func becomeActive() {
         isBecome = false
    }
    func resignActive() {
        isBecome = true
        if self.aliyunVodPlayer?.isPlaying == true {
//           self.aliyunVodPlayer?.pause()
        }
    }
    

    
}

///网络请求数据
extension WFNewVideoViewController{
    
    func loadClassDetail() {
        NetworkerManager.shared.getDefauleVideo(classId) { (isSuccess, json) in
            if isSuccess {
                if let model = json{
                    self.videoModel = model
//                    if !self.isOfflinePlay{
                        self.videoID = model.vid
                        self.loadVideoClassListData("\(model.course.id)")
//                    }
                }
            }
        }
    }
    
    fileprivate func loadVideoClassListData (_ id : String) {
        NetworkerManager.shared.getCourseVideos(id) { (isSuccess, code) in
            if isSuccess{
                if let model = code {
                    self.videoClassListModel = model
                }
            }
        }
    }
    
    fileprivate func getCourseVideo(_ id : String) {
        NetworkerManager.shared.getCourseVideo(id) { (isSuccess, code) in
            if isSuccess{
                if let model = code {
                    self.videoModel = model
                }
            }
        }
    }
    
    fileprivate func loadCommantList(){
        NetworkerManager.shared.getCourseCommentList(classId, "\(commontPage)") { (isSuccess, jsonArr ) in
            if isSuccess{
                if self.commontPage == 1{
                    if self.slideView.thirdTableView.mj_footer != nil {
                        self.slideView.thirdTableView.mj_footer.resetNoMoreData()
                    }
                   self.commantModel.removeAll()
                }
                if jsonArr.count < 10 && self.commontPage != 1{
                    self.commontPage -= 1
                    self.slideView.thirdTableView.mj_footer.endRefreshingWithNoMoreData()
                }
                self.commantModel = self.commantModel + jsonArr
            }
        }
    }
    
   fileprivate func loadViewData () {
        NetworkerManager.shared.getPlayAuth(videoID) { (isSuccess, code) in
            if isSuccess{
                self.playAuth = code
            }
        }
    }
    
    fileprivate func loadRelventClass(){
        NetworkerManager.shared.getCurrentCourseLimit(classId) { (isSuccess, jsonArr ) in
            if isSuccess{
                self.currentClass = jsonArr
            }
        }
    }
}

////屏幕旋转
extension WFNewVideoViewController{
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var width     : CGFloat = 0
        var height    : CGFloat = 0
        var topHeight : CGFloat = 0
        
        let orientation = UIApplication.shared.statusBarOrientation
        if (orientation == .portrait ) {
            width     = Screen_width
            height    = Screen_width * 9 / 16.0
            topHeight = 20
        }else{
            width     = Screen_width
            height    = Screen_height
            topHeight = 0
        }
        
        let tempFrame = CGRect(x: 0, y: topHeight, width: width ,height: height)
        let device    = UIDevice.current
        
        ///x
        if iphoneType != "iPhone10,3" && iphoneType != "iPhone10,6" {
            switch device.orientation {
    
            case .unknown,
                 .faceDown,
                 .faceUp,
                 .portraitUpsideDown:
                  break
                
            case .portrait:
                  self.aliyunVodPlayer?.frame = tempFrame
            
            case .landscapeLeft,
                 .landscapeRight:
                 self.aliyunVodPlayer?.frame = CGRect.init(x: 0, y: 0, width:  Screen_height, height: Screen_width )
            
            }
        }
        
        
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 110000
        
        var safeEdges = UIEdgeInsets.zero
        if #available(iOS 11, *){
            safeEdges  = view.safeAreaInsets
        }else{
            safeEdges  = UIEdgeInsets.zero
        }

        
        if iphoneType != "iPhone10,3" && iphoneType != "iPhone10,6" {
            switch device.orientation {
                
            case .unknown,
                 .faceDown,
                 .faceUp,
                 .portraitUpsideDown:
                
                if isStatusHidden == true{
                    
                    var frame  = self.aliyunVodPlayer?.frame
                    frame?.origin.x = safeEdges.left
                    frame?.origin.y  = safeEdges.top
                    frame?.size.width = Screen_width - safeEdges.left*2
                    frame?.size.height = Screen_height - safeEdges.bottom - safeEdges.top
                    self.aliyunVodPlayer?.frame = frame!
                    
                }else{
                    
                    var frame  = self.aliyunVodPlayer?.frame
                    frame?.origin.y  = safeEdges.top
                    
                    ///竖屏全屏时 isStatusHidden 来自是否旋转回调
                    if (self.aliyunVodPlayer?.fixedPortrait)! && self.isStatusHidden == true{
                        frame?.size.height = Screen_height - safeEdges.top - safeEdges.bottom;
                    }
                    self.aliyunVodPlayer?.frame = frame!
                }
                
            case .portrait:
                
                var frame = tempFrame;
                frame.origin.y = safeEdges.top;
                
                //竖屏全屏时 isStatusHidden 来自是否 旋转回调。
                if self.aliyunVodPlayer?.fixedPortrait && self.isStatusHidden {
                    frame.size.height = Screen_height - safeEdges.top - safeEdges.bottom;
                }
                self.aliyunVodPlayer.frame = frame
                
            case .landscapeLeft,
                 .landscapeRight:
                
                var frame = self.aliyunVodPlayer?.frame
                frame.origin.x = safeEdges.left;
                frame.origin.y = safeEdges.top;
                frame.size.width = Screen_width - safeEdges.left * 2;
                frame.size.height = Screen_height - safeEdges.bottom;
                self.aliyunVodPlayer?.frame = frame;
                
            }
        }

#else
        
#endif

    }
}

extension WFNewVideoViewController : AliyunVodPlayerViewDelegate {
    
    func onBackViewClick(with playerView: AliyunVodPlayerView!) {
        self.navigationController?.navigationBar.isHidden = false
        self.dismiss(animated: true, completion: nil)
        aliyunVodPlayer?.stop()
        aliyunVodPlayer?.releasePlayer()
        aliyunVodPlayer?.removeFromSuperview()
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onPause currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onResume currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onStop currentPlayTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onSeekDone seekDoneTime: TimeInterval) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, lockScreen isLockScreen: Bool) {
         self.isLock = isLockScreen
    }
    
    func onFinish(with playerView: AliyunVodPlayerView!) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onVideoQualityChanged quality: AliyunVodPlayerVideoQuality) {
        downLoadView.videoQuality = quality
    }
    
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, fullScreen isFullScreen: Bool) {
        print("全屏按钮")
        print(isFullScreen)
        self.isStatusHidden = isFullScreen
        if isFullScreen == false {
            slideView.mainScrollView.contentOffset  = CGPoint.init(x: CGFloat(slideView.classSegmentView.selectedSegmentIndex) * Screen_width, y: 0)
        }else{
            
            if downLoadView.isHidden == false {
                downLoadView.snp.updateConstraints { (maker) in
                    maker.left.right.bottom.equalToSuperview()
                    maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!).offset(1000)
                }
                UIView.animate(withDuration: 0.4, animations: {
                    self.downLoadView.layoutIfNeeded()
                }) { (istrue) in
                    self.downLoadView.isHidden = true
                }
                downloadConstriant = 1000
            }
            
        }
    }
    
    func onCircleStart(with playerView: AliyunVodPlayerView!) {
        
    }
    
    func aliyunVodPlayerView(_ playerView: AliyunVodPlayerView!, onVideoDefinitionChanged videoDefinition: String!) {
        
    }
    
    ///点击按钮的方法
    func downloadBtnClick(_ playerView: AliyunVodPlayerView!) {
        
        if self.isStatusHidden {
            self.aliyunVodPlayer?.setFullScreen(false)
        }
        if downloadConstriant == 0 {
            downLoadView.snp.updateConstraints { (maker) in
                maker.left.right.bottom.equalToSuperview()
                maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!).offset(1000)
            }
            UIView.animate(withDuration: 0.4, animations: {
                self.downLoadView.layoutIfNeeded()
            }) { (istrue) in
                self.downLoadView.isHidden = true
            }
            downloadConstriant = 1000
            
        }else{
            self.isStatusHidden = false
            setNeedsStatusBarAppearanceUpdate()
            downLoadView.snp.updateConstraints { (maker) in
                maker.left.right.bottom.equalToSuperview()
                maker.top.equalTo((self.aliyunVodPlayer?.snp.bottom)!).offset(0)
            }
            self.downLoadView.isHidden = false
            UIView.animate(withDuration: 0.4, animations: {
                self.downLoadView.layoutIfNeeded()
            }) { (istrue) in
            }
            downloadConstriant = 0
        }
    }
    
    func listenBtnClick(_ playerView: AliyunVodPlayerView!) {
        print("listenBtnClick")
    }
    
    func shareBtnClick(_ playerView: AliyunVodPlayerView!) {
        print("shareBtnClick")
        
        var videoId  = ""
        
        for item  in videoClassListModel.videoList {
            if item.isDefaultModel == true{
                videoId = "\(item.id)"
                break
            }
        }
        
        
        AppDelegate.shareUrl("\(Photo_Path)/courses/play.jspx?courseId=\(classId)&videoId=\(videoId)", imageString: videoModel.course.image, title: videoModel.course.name, descriptionString: "【神外资讯】传播神经外科最新技术和理念，促进中国神经外科诊疗走向规范", viewController: self, .wechatSession)
        
    }
    
    func editeBtnClick(_ playerView: AliyunVodPlayerView!) {
        var chooseFrame  =  (self.aliyunVodPlayer?.frame)!
            chooseFrame.origin.x += chooseFrame.size.width
        
         chooseView = WFChooseView.init(frame: chooseFrame)
         chooseView?.delegate = self
         view.addSubview(chooseView!)
        
        UIView.animate(withDuration: 0.3) {
          chooseFrame.origin.x -= chooseFrame.size.width
          self.chooseView?.frame = chooseFrame
        }
        
    }
    //MARK: - 锁屏功能
    /**
     * 说明：播放器父类是UIView。
     屏幕锁屏方案需要用户根据实际情况，进行开发工作；
     如果viewcontroller在navigationcontroller中，需要添加子类重写navigationgController中的 以下方法，根据实际情况做判定 。
     */
    
    override var shouldAutorotate: Bool{
        return !self.isLock
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if self.isLock{
            return .portrait
        }else{
            return .all
        }
    }
    override var prefersStatusBarHidden: Bool{
         return isStatusHidden
    }
}

extension WFNewVideoViewController : WFSlideViewClickProtocol{
    func currentBtnClick(_ vid: String, _ classID: String) {
        let vc  = WFMoreClassConttoller()
        vc.isShowBack = true
        vc.classId = classId
        let nav = WFNavigationController.init(rootViewController: vc)
        vc.title = "相关课程"
        vc.isFreeClass = false
        self.present(nav , animated: false, completion: nil)
        
    }
    
    func clickChangeVideo(_ vid : String, _ classID : String){
        self.videoID = vid
        getCourseVideo(classID)
    }

}
///ChooseViewDelegate
extension WFNewVideoViewController : ChooseFuncBtnProtocol {
    func btnClickWith(_ funcEnum: Int) {
        switch funcEnum {
        case 0 : print("投诉一下"); break
        case 1 : print("收藏一下"); break
        case 2 : print("投屏一下"); break
        default: break
        }
        
        guard var chooseFrame  =  self.aliyunVodPlayer?.frame else{
            self.chooseView?.removeFromSuperview()
            return
        }
        
        UIView.animate(withDuration: 0.3, animations: {
            chooseFrame.origin.x += chooseFrame.size.width
            self.chooseView?.frame = chooseFrame
        }) { (isTrue) in
            self.chooseView?.removeFromSuperview()
        }
    }
}

//重写Nav方法控制锁屏
extension UINavigationController {
    override open var shouldAutorotate: Bool {
        return (self.viewControllers.last?.shouldAutorotate)!
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return (self.viewControllers.last?.supportedInterfaceOrientations)!
    }
    
}


class WFDevice {
    
    static func isIphoneX() -> Bool {
        return iphoneType() == "iPhone X"
    }
    
    static func bottomOffset() -> CGFloat {
        return isIphoneX() ? 20 : 0
    }
    
    static func topOffset() -> CGFloat {
        return isIphoneX() ? 28 : 0
    }
    
    static func iphoneType() ->String {
        
        var systemInfo = utsname()
        uname(&systemInfo)
        
        let platform = withUnsafePointer(to: &systemInfo.machine.0) { ptr in
            return String(cString: ptr)
        }
        
        if platform == "iPhone1,1" { return "iPhone 2G"}
        if platform == "iPhone1,2" { return "iPhone 3G"}
        if platform == "iPhone2,1" { return "iPhone 3GS"}
        if platform == "iPhone3,1" { return "iPhone 4"}
        if platform == "iPhone3,2" { return "iPhone 4"}
        if platform == "iPhone3,3" { return "iPhone 4"}
        if platform == "iPhone4,1" { return "iPhone 4S"}
        if platform == "iPhone5,1" { return "iPhone 5"}
        if platform == "iPhone5,2" { return "iPhone 5"}
        if platform == "iPhone5,3" { return "iPhone 5C"}
        if platform == "iPhone5,4" { return "iPhone 5C"}
        if platform == "iPhone6,1" { return "iPhone 5S"}
        if platform == "iPhone6,2" { return "iPhone 5S"}
        if platform == "iPhone7,1" { return "iPhone 6 Plus"}
        if platform == "iPhone7,2" { return "iPhone 6"}
        if platform == "iPhone8,1" { return "iPhone 6S"}
        if platform == "iPhone8,2" { return "iPhone 6S Plus"}
        if platform == "iPhone8,4" { return "iPhone SE"}
        if platform == "iPhone9,1" { return "iPhone 7"}
        if platform == "iPhone9,2" { return "iPhone 7 Plus"}
        if platform == "iPhone10,1" { return "iPhone 8"}
        if platform == "iPhone10,2" { return "iPhone 8 Plus"}
        if platform == "iPhone10,3" { return "iPhone X"}
        if platform == "iPhone10,4" { return "iPhone 8"}
        if platform == "iPhone10,5" { return "iPhone 8 Plus"}
        if platform == "iPhone10,6" { return "iPhone X"}
        
        if platform == "iPod1,1" { return "iPod Touch 1G"}
        if platform == "iPod2,1" { return "iPod Touch 2G"}
        if platform == "iPod3,1" { return "iPod Touch 3G"}
        if platform == "iPod4,1" { return "iPod Touch 4G"}
        if platform == "iPod5,1" { return "iPod Touch 5G"}
        
        if platform == "iPad1,1" { return "iPad 1"}
        if platform == "iPad2,1" { return "iPad 2"}
        if platform == "iPad2,2" { return "iPad 2"}
        if platform == "iPad2,3" { return "iPad 2"}
        if platform == "iPad2,4" { return "iPad 2"}
        if platform == "iPad2,5" { return "iPad Mini 1"}
        if platform == "iPad2,6" { return "iPad Mini 1"}
        if platform == "iPad2,7" { return "iPad Mini 1"}
        if platform == "iPad3,1" { return "iPad 3"}
        if platform == "iPad3,2" { return "iPad 3"}
        if platform == "iPad3,3" { return "iPad 3"}
        if platform == "iPad3,4" { return "iPad 4"}
        if platform == "iPad3,5" { return "iPad 4"}
        if platform == "iPad3,6" { return "iPad 4"}
        if platform == "iPad4,1" { return "iPad Air"}
        if platform == "iPad4,2" { return "iPad Air"}
        if platform == "iPad4,3" { return "iPad Air"}
        if platform == "iPad4,4" { return "iPad Mini 2"}
        if platform == "iPad4,5" { return "iPad Mini 2"}
        if platform == "iPad4,6" { return "iPad Mini 2"}
        if platform == "iPad4,7" { return "iPad Mini 3"}
        if platform == "iPad4,8" { return "iPad Mini 3"}
        if platform == "iPad4,9" { return "iPad Mini 3"}
        if platform == "iPad5,1" { return "iPad Mini 4"}
        if platform == "iPad5,2" { return "iPad Mini 4"}
        if platform == "iPad5,3" { return "iPad Air 2"}
        if platform == "iPad5,4" { return "iPad Air 2"}
        if platform == "iPad6,3" { return "iPad Pro 9.7"}
        if platform == "iPad6,4" { return "iPad Pro 9.7"}
        if platform == "iPad6,7" { return "iPad Pro 12.9"}
        if platform == "iPad6,8" { return "iPad Pro 12.9"}
        
        if platform == "i386"   { return "iPhone Simulator"}
        if platform == "x86_64" { return "iPhone Simulator"}
        //        if platform == "x86_64" { return "iPhone X"}
        
        return platform
    }
}

