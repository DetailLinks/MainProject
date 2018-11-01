//
//  WFHomeViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/23.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import MJRefresh
import SDCycleScrollView
import SVProgressHUD

///四个和五个一块弄212：234  cell Height  110 
class WFHomeViewController: BaseViewController {

//    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
//        super.init(nibName: "WFHomeViewController", bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       print("这个是awakeFromNib")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.layoutIfNeeded()
    }
    
    @IBOutlet weak var searchBarHeightCons: NSLayoutConstraint!
    
    ///储存ad
    var adDataList = [WFAdModel]()
    
    ///轮播图
    @IBOutlet weak var cycleScrollView: SDCycleScrollView!
    
    /// scroView
    @IBOutlet weak var scrowView: UIScrollView!
    
    /// tableView的高度s
    @IBOutlet weak var tableViewHeightConstant: NSLayoutConstraint!
    
    /// pageContorl
    @IBOutlet weak var pageControl: WFPageControl!
    
    
    /// 滚动视图
    @IBOutlet weak var collectionView: UICollectionView!

     /// 资讯列表
     @IBOutlet weak var inforTableView: UITableView!
    
    /// 搜索框
    @IBOutlet weak var searchBar: UISearchBar!

    /// 更多点击资讯
    @IBAction func moreBtnClick(_ sender: Any) {
        literatureCompileClick(self)
//        navigationController?.pushViewController(WFMoreViewController(), animated: true)
    }
  
    ///云课堂
    @IBAction func meetingSysTemClick(_ sender: Any) {
        
//        let vc  = WFVideoDetailController()//WFDetailViewController()
//        vc.htmlString = Photo_Path + "/h5classes/home.html" //"/classes/index.html#/home" //
//        vc.title = "云课堂"
//        WFNewVideoViewController
        let vc  = WFCloudClassViewController()
        navigationController?.pushViewController(vc, animated: true)
}
    ///直录播
    @IBAction func miniCaseClick(_ sender: Any){
    
        let tabbar = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        tabbar?.selectedIndex = 3

    }
    ///品牌专区
    @IBAction func officeEareClick(_ sender: Any) {
        
        let vc  = WFVideoDetailController()
        vc.htmlString = Photo_Path + "/brandList.jspx"
        vc.title = "品牌专区"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///评分工具
    @IBAction func operationPlayingClick(_ sender: Any){
        
        
//        let vc  = WFVideoDetailController()
//        vc.htmlString = Photo_Path + "/pms/index.jspx"///pms/index.jspx
//        vc.title = "军火库"
//        navigationController?.pushViewController(vc, animated: true)
       
        let vc  = WFVideoDetailController()
        vc.htmlString = Photo_Path + "/minitools/index.html"
        vc.title = "评分工具"
        navigationController?.pushViewController(vc, animated: true)

    }
    @IBAction func caseDiscussClick(_ sender: Any){
    
        let vc  = WFVideoDetailController()
        vc.htmlString = Photo_Path + "/mp/list.jspx"        //
        vc.title = "病例讨论"
        navigationController?.pushViewController(vc, animated: true)

    }
    
    @IBAction func literatureCompileClick(_ sender: Any){
    
        let vc  = WFVideoDetailController()
        vc.htmlString = Photo_Path + "/template/1/bluewise/h5_info_special.html"
        vc.title = "文章专栏"
//        vc.isInfo = true 
        navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func newTechClick(_ sender: Any){}
    @IBAction func newProductClick(_ sender: Any){}
    @IBAction func dualRafural(_ sender: Any){

        SVProgressHUD.showInfo(withStatus: "正在开发开发中")

    }
    @IBAction func digitalAnilayziClick(_ sender: Any){}
    
    ///适配屏幕字体
    
    /// 专业会议 从做到有由上而下
    @IBOutlet weak var meetingBtn: UIButton!
    
    @IBOutlet weak var digitalMarket: UIButton!
    
    @IBOutlet weak var miniCaseBtn: UIButton!
    
    @IBOutlet weak var playingBtn: UIButton!
    
    @IBOutlet weak var discussBtn: UIButton!
    
    @IBOutlet weak var newestBtn: UIButton!
    
    @IBOutlet weak var newTecBtn: UIButton!
    
    @IBOutlet weak var newProductBtn: UIButton!
    
    @IBOutlet weak var doubleTransBtn: UIButton!
    
    @IBOutlet weak var analazyBtn: UIButton!
   
    @IBOutlet weak var newsBtn: UILabel!{
        didSet{
            newsBtn.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var navigationBarConstant: NSLayoutConstraint!
    
    @IBOutlet weak var moreBtn: UIButton!{
        didSet{
            moreBtn.layer.masksToBounds = true
            moreBtn.titleLabel?.layer.masksToBounds = true
            moreBtn.titleLabel?.backgroundColor = .white
            moreBtn.imageView?.backgroundColor = .white
            
            moreBtn.imageView?.layer.masksToBounds = true
            
        }
    }
    
    
}

// MARK: - 加载网路数据
extension WFHomeViewController{
    
    override func loadData() {
        
        tableViewHeightConstant.constant = 10 * 88
      //  view.layoutIfNeeded()
        
        loadAdNet()
        
        loadHoneInfoData()
    }
    
  private  func loadAdNet() {
    
     NetworkerManager.shared.getAppAdSolts { (isSuccess, json) in
        
        if isSuccess == true {
            print(json)
            
            var titleArray = [String]()
            var imageArray = [String]()
            
            for  item in json {
                
                titleArray.append(item.name ?? "")
                imageArray.append(item.imageString )
                
            }
            
            self.adDataList = json
            
//            self.cycleScrollView.titlesGroup = titleArray
            self.cycleScrollView.imageURLStringsGroup = imageArray
            
            self.pageControl.numberOfPages = json.count
            self.pageControl.currentPage = 0
        }
        
    }
    }
    
    func loadHoneInfoData() {
        
        NetworkerManager.shared.getHomePageInfo(page) { (isSuccess, json) in
            
            if isSuccess == true {
                
                self.base_dataList = self.base_dataList + json
                
                self.tableViewHeightConstant.constant = CGFloat(88 * self.base_dataList.count)
                
                self.inforTableView.reloadData()
            }
        }
    }
}

// MARK: - tableView的数据源和代理方法
extension WFHomeViewController{
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(
                                        withIdentifier: WFInforTableViewCell().identfy)
                                         as? WFInforTableViewCell
        cell?.model = base_dataList[indexPath.row] as? WFCollectionModel
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return base_dataList.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = WFVideoDetailController()//WFAriticleViewController()
        
        //vc.isInfo = true
        vc.htmlString = Photo_Path + ((base_dataList[indexPath.row] as? WFCollectionModel)?.url ?? "")
        
        self.navigationController?.pushViewController(vc , animated: true)
        
    }
}

///设置界面
extension WFHomeViewController:SDCycleScrollViewDelegate,UISearchBarDelegate{
    
    override func setUpUI() {
        super.setUpUI()
        
        let VC  = WFCacheManagerController.share
        VC.setAliplayerDownloadConfig()
        VC.loadDownLoadData()
        removeTabelView()
        navItem.title = "神外资讯"
        
        navigationBarConstant.constant = navigation_height
        
        setSearchBar()
        
        setUptableView()
        
        addRefresh()
        
         setFontSize()
        
        setUpCycleView()
        
//        let obseve =   CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault() as! CFAllocator, CFRunLoopActivity.beforeWaiting.rawValue, false, 0) { (observer , nil ) in
//             WFNewVideoViewController()
//        }
//        
//        CFRunLoopAddObserver(RunLoop.current as! CFRunLoop, obseve,CFRunLoopMode.defaultMode)
    }
    
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView!, didSelectItemAt index: Int) {
        
//        let adController  = WFAdViewController()
//        adController.htmlString = adDataList[index].url ?? ""

        let vc  = WFVideoDetailController()
        
        if adDataList[index].url ?? "" == "" {
            return
        }
        
        vc.htmlString = adDataList[index].url ?? ""
        
        navigationController?.pushViewController(vc , animated: true )
    }
    
    ///设置轮播图
    private func setUpCycleView() {
        
        cycleScrollView.delegate = self
        cycleScrollView.titleLabelBackgroundColor = UIColor.clear
        cycleScrollView.autoScrollTimeInterval = 5
        cycleScrollView.showPageControl = false
        cycleScrollView.placeholderImage = #imageLiteral(resourceName: "首页banner")//24911529466020_.pic_hd// #imageLiteral(resourceName: "casediscuss_img_neuro")//casediscuss_img_neuro
        cycleScrollView.itemDidScrollOperationBlock = {(offset) in
        
            self.pageControl.currentPage = offset
        }
    }
    
    /// 设置数据列表
   private  func setUptableView() {
        
        inforTableView.tableFooterView = UIView()
        inforTableView.delegate = self
        inforTableView.dataSource = self
        
        inforTableView.register(UINib.init(nibName: WFInforTableViewCell().identfy,
                                                bundle: nil),
                                                forCellReuseIdentifier: WFInforTableViewCell().identfy)
    
    }
    
    /// 设置searchBar属性
   private func setSearchBar() {
        
        searchBar.backgroundImage = UIImage()

        searchBar.delegate = self
    
         view.layoutIfNeeded()
    
        ///设置searchBar为圆角
        if  let tf : UITextField = searchBar.value(forKey: "searchField") as? UITextField{

            tf.backgroundColor = UIColor.white
            tf.layer.cornerRadius = 14
            tf.layer.masksToBounds = true

            searchBarHeightCons.constant = tf.frame.height + 16
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBarClick()
        return false
    }
    
   private func searchBarClick(){
    
    navigationController?.pushViewController(WFSearchViewContoller(), animated: true)
    
    }
}

// MARK: - 添加刷新控件
extension WFHomeViewController{
    
    func addRefresh() {
        scrowView.addMjrefrest(refreshHeaderClosure: {
                    print("上拉刷新")
            
                    self.page = 1
                    self.base_dataList.removeAll()
                    self.loadData()
                    self.scrowView.endFresh()
        }, refreshFooterClosure: {
            print("下拉加载")
            
            self.page += 1
            self.loadHoneInfoData()
            self.scrowView.endFresh()
        })
        
//      scrowView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
//        print("上拉刷新")
//
//        self.page = 1
//        self.base_dataList.removeAll()
//        self.loadData()
//        self.scrowView.endFresh()
//      })
//
//      scrowView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
//        print("下拉加载")
//
//        self.page += 1
//        self.loadHoneInfoData()
//        self.scrowView.endFresh()
//      })
    }
}

// MARK: - 适配字体
extension WFHomeViewController{
    
    func setFontSize() {
        
        if Screen_width == 320 {
            
            setFont("神经外科医生MOOC", btn: meetingBtn)
            setFont("Digital Maketing", btn: digitalMarket)
            setFont("随时随地体验精彩", btn: miniCaseBtn)
            setFont("快速实用临床助手", btn: playingBtn)
            setFont("Case Discussion", btn: discussBtn)
            setFont("传播最新技术理念", btn: newestBtn)
            
            
            setFont("最新技术解读", btn: newTecBtn)
            setFont("最新产品介绍", btn: newProductBtn)
            setFont("在线双向转诊", btn: doubleTransBtn)
            setFont("数据分析报告", btn: analazyBtn)
        }
        
    }
    
    private  func setFont(_ string : String , btn : UIButton ) {
        
        let  attSring  = NSAttributedString(string: string, attributes: [NSFontAttributeName : UIFont(name: "PingFang-SC Regular", size: 10) ?? UIFont.systemFont(ofSize: 10), NSForegroundColorAttributeName : #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1) ])
        
            btn.setAttributedTitle(attSring, for: .normal)
        
    }
    
}











