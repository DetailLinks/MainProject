//
//  VideoClipView.swift
//  视频裁剪修改版本
//
//  Created by 张崇超 on 2018/6/29.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import AVKit

let kWidth = UIScreen.main.bounds.size.width
let kHeight = UIScreen.main.bounds.size.height
let kNavBarHeight: CGFloat = kHeight > 736.0 ? (88.0) : (64.0)
let kWindow = UIApplication.shared.keyWindow
let kRootVC = kWindow?.rootViewController

class VideoClipView: UIView {

    var controller : UIViewController?
    
    /// 截图的时间间隔 最大时间: clipeTimeSpace * 5
    var clipeTimeSpace: CGFloat = 2.0
    /// 视频地址 (本地)
    var videoPath: String = ""
    // MARK: ====显示相关====
    /// 放视频
    @IBOutlet weak var topView: UIView!
    /// 放控件
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var showView: UIView!
    /// 时间展示 0.0/15.0
    @IBOutlet weak var timeShowL: UILabel!
    /// 已截取 15.0s
    @IBOutlet weak var clipTimeL: UILabel!
    // MARK: ====滑块相关====
    @IBOutlet weak var bottomLine: UIView!
    @IBOutlet weak var topLine: UIView!
    @IBOutlet weak var leftDrag: UIView!
    @IBOutlet weak var leftCons: NSLayoutConstraint!
    @IBOutlet weak var rightDrag: UIView!
    @IBOutlet weak var rightCons: NSLayoutConstraint!
    /// true: 左滑块 false: 右滑块 nil: 都不是
    private var isLeftDrag: Bool?
    /// 控件的宽度
    @IBOutlet weak var dragWidthCons: NSLayoutConstraint!
    /// 空白区域 父视图很大,图片很小 扩大点击区域
    fileprivate var whiteWidth: CGFloat = 0.0
    /// 两个控件之间最小的距离 一个单元格宽度
    fileprivate let minSpace: CGFloat = (kWidth / 7.0).intFloatNum()
    
    @IBOutlet weak var bootHeightCons: NSLayoutConstraint!
    @IBOutlet weak var bottomConstaint: NSLayoutConstraint!
    @IBOutlet weak var bottomHeight: UIView!
    @IBOutlet weak var backBtn: UIButton!
    
    // MARK: ====时间相关====
    /// 定时器
    fileprivate var timer: CADisplayLink?
    /// 集合视图快进的时间
    fileprivate var scrolPlayTime: CGFloat = 0.0
    /// 左滑块快进的时间
    fileprivate var leftPlayTime: CGFloat = 0.0
    /// 开始播放的时间
    fileprivate var beginPlayTime: CGFloat = 0.0
    /// 结束播放的时间
    fileprivate var endPlayTime: CGFloat = 15.0
    /// 1pt对应的秒数
    fileprivate var videoAsecptNum: CGFloat = 0.0
    /// 视频总时长
    fileprivate var totalDuration: CGFloat = 0.0
    /// 截取的总时长
    fileprivate var totalClipDuration: CGFloat = 0.0
    /// 已截取的时长
    fileprivate var clipDuration: CGFloat = 0.0
    /// 手势是否在滑块上未离开
    fileprivate var isDragging: Bool = false
    // MARK: ====集合视图相关====
    fileprivate var imgsArr: [UIImage?] = []
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var layout: UICollectionViewFlowLayout!    
    fileprivate let cellWidth: CGFloat = (kWidth / 7.0).intFloatNum()
    /// 视频播放器
    fileprivate var player: AVPlayer?
    /// 处理完的回调
    fileprivate var callBack: ((_ path: String) -> Void)?
    
    @IBOutlet weak var topVIewCons: NSLayoutConstraint!
    
    func setIsLook(_ isLook : Bool) {
        if isLook == true{
            backBtn.isHidden = false
            bootHeightCons.constant = 0
            bottomConstaint.constant = 0
            topVIewCons.constant = 60
        }
    }
    
    // MARK: -初始化工具
    /// 初始化工具
    ///
    /// - Parameter videoPath: 视频地址
    /// - Returns: self
    class func loadXibView(videoPath: String,_ isOnlyLook : Bool = false , callBack: ((_ path: String) -> Void)?) -> VideoClipView {
        let tool = Bundle.main.loadNibNamed("VideoClipView", owner: nil, options: nil)?.last as! VideoClipView
        tool.frame = CGRect.init(x: 0.0, y: 0.0, width: kWidth, height: kHeight)
        tool.setIsLook(isOnlyLook)
        tool.callBack = callBack
        tool.videoPath = videoPath
        
        var totalDuration: CGFloat = videoPath.getVideoDuration().intFloatNum()
        
        tool.totalDuration = videoPath.getVideoDuration()

        tool.clipeTimeSpace = tool.totalDuration / 6.0
        
        // 获取视频的图片截图
        tool.imgsArr = videoPath.getVideoThumbImg(timeSpace: tool.clipeTimeSpace)
        // 可以截取的单元格最多5个
        let cellNum: CGFloat = min(6.0, CGFloat(tool.imgsArr.count))
        // 获取视频总时长 43.2
        
        print("总时长:\(tool.totalDuration)")

        // 视频时长是否大于 最大裁剪时长
        totalDuration = min(totalDuration, tool.clipeTimeSpace * cellNum)
        // 集合视图总长度
        let allLength: CGFloat = tool.cellWidth * cellNum
        // 1pt对应的秒数
        tool.videoAsecptNum = totalDuration / allLength
        
        // 安全判断结束时长
        tool.totalClipDuration = totalDuration
        // 结束时间
        tool.endPlayTime = totalDuration
        tool.timeShowL.text = "0.0/\(totalDuration)s"
        // 截取的时间
        tool.clipDuration = totalDuration
        tool.clipTimeL.text = "已截取\(String.init(format: "%.1f", totalDuration))s"
        // 空白区域计算
        tool.whiteWidth = tool.dragWidthCons.constant - 10.0
        
        // 初始化播放器
        let item = AVPlayerItem.init(url: URL.init(fileURLWithPath: videoPath))
        
        let player = AVPlayer.init(playerItem: item)
        let playerLayer = AVPlayerLayer.init(player: player)
        playerLayer.frame = tool.topView.bounds
        playerLayer.videoGravity = kCAGravityResizeAspect//.resizeAspect
        //playerLayer.videoGravity = .resizeAspectFill
        
        tool.topView.layer.addSublayer(playerLayer)
        player.volume = 1.0
        tool.player = player
        tool.player?.play()
        
        // 添加定时器 commonModes
        let timer = CADisplayLink.init(target: tool, selector: #selector(timeChangeAction))
        timer.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        tool.timer = timer
        
        // 更新右边的约束, 若果视频截图不足5个
        if cellNum < 5.0 {
            
            tool.rightCons.constant = (5.0 - cellNum) * tool.cellWidth + tool.dragWidthCons.constant
        }
        
        return tool
    }
    
    // MARK: -取消按钮点击事件
    @IBAction func cancleAction() {
        
        self.player?.pause()
        NotificationCenter.default.removeObserver(self)
        self.player = nil
        UIView.animate(withDuration: 0.3, animations: {
            
            self.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
            
        }) {[weak self] (isOK) in
            self?.removeFromSuperview()
            self?.controller?.dismiss(animated: true, completion: {
            self?.controller = nil
            })
        }
    }
    // MARK: -完成按钮点击事件
    @IBAction func finishAction() {
        
//        let pathArr = self.videoPath.components(separatedBy: ".")
        VideoClipTool.videoClipMethod(fileUrl: URL.init(fileURLWithPath:self.videoPath), startTime: self.beginPlayTime, endTime: self.endPlayTime) { (index) in
            print("传入的路径")
            print(self.videoPath)
            DispatchQueue.main.async {
                
                self.cancleAction()
                self.callBack?(index)
            }
        }
    }
    
    // MARK: 开始点击
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 点击时哪一个
        let tapView = touches.first!.view!
        if tapView == self.leftDrag {
            
            self.isLeftDrag = true
            
        } else if tapView == self.rightDrag {
            
            self.isLeftDrag = false

        } else {
            
            self.isLeftDrag = nil
        }
    }
    
    // MARK: 拖动滑块
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        let point = touches.first!.location(in: self)
        if self.isLeftDrag == nil {  return }
        self.isDragging = true
        self.player?.volume = 0.0
        
        // 线条更新
        var newLineFrame = self.topLine.frame
        
        if self.isLeftDrag! {
            
            var newFrame = self.leftDrag.frame
            // 减去父视图 self.whiteWidth的空白区域
            newFrame.origin.x = point.x.intFloatNum() - self.whiteWidth
            
            let rightX = self.rightDrag.frame.minX.intFloatNum()
            // 间隔 (无间隔 newFrame.origin.x + self.dragWidthCons.constant)
            let leftX = newFrame.origin.x + self.dragWidthCons.constant + self.minSpace

            // 最左边不可移动
            if (newFrame.origin.x >= self.leftCons.constant) && (leftX <= rightX) {
                
                self.leftDrag.frame = newFrame
            }
            // 线条更新 self.whiteWidth是父控件的空白区域大小
            newLineFrame.origin.x = self.leftDrag.frame.minX + self.whiteWidth
            
            // 开始时间
            let leftOffsetX = self.leftDrag.frame.minX.intFloatNum() - self.leftCons.constant
            self.leftPlayTime = leftOffsetX * self.videoAsecptNum
            self.beginPlayTime = self.leftPlayTime + self.scrolPlayTime
            self.player?.seekTimeToPlay(time: self.beginPlayTime, isPlay: false)
            
        } else {
            
            var newFrame = self.rightDrag.frame
            newFrame.origin.x = point.x.intFloatNum()
            
            let leftX = self.leftDrag.frame.minX.intFloatNum()
            // 间隔 (无间隔 newFrame.origin.x - self.dragWidthCons.constant)
            let rightX = newFrame.origin.x - self.dragWidthCons.constant - self.minSpace
            
            // 最右边不可移动
            if (point.x <= kWidth - self.rightCons.constant - self.self.dragWidthCons.constant) && (leftX <= rightX) {
                
                self.rightDrag.frame = newFrame
            }
        }
        // 线条更新
        newLineFrame.size.width = self.rightDrag.frame.maxX - self.leftDrag.frame.minX - self.whiteWidth * 2.0
        self.topLine.frame = newLineFrame
        self.bottomLine.frame = CGRect.init(x: self.topLine.frame.minX, y: self.bottomLine.frame.minY, width: self.topLine.frame.width, height: 2.0)
        // 计算滑块之间的距离
        let rightX = self.rightDrag.frame.minX
        let leftX = self.leftDrag.frame.minX
        let distance = rightX - leftX - self.dragWidthCons.constant
        self.clipDuration = distance * self.videoAsecptNum
        self.clipTimeL.text = "已截取\(self.clipDuration.toString())s"
        // 结束时间
        self.setTimeShowLabel()
    }
    
    // MARK: 拖动结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.isLeftDrag == nil { return }
        
        if let event = event {
            
            let allTouch = event.allTouches
            if let allTouch = allTouch {
                
                for touch in allTouch {
                    
                    // 手指是否离开
                    if touch.phase == .ended || touch.phase == .cancelled {
     
                        // 快进到开始时间
                        self.scrollViewDidEndDecelerating(colView)
                    }
                }
                
            } else {
                
                self.player?.seekTimeToPlay(time: self.beginPlayTime, isPlay: true)
                self.isDragging = false
            }
            
        } else {
            
            self.player?.seekTimeToPlay(time: self.beginPlayTime, isPlay: true)
            self.isDragging = false
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.touchesEnded(touches, with: event)
    }

    // MARK: 设置UI时间显示
    func setTimeShowLabel() {
        
        // 结束时间
        self.endPlayTime = self.beginPlayTime + self.clipDuration
        if self.endPlayTime >= self.totalDuration {
            
            // 结束时长超过总时长
            self.endPlayTime = self.totalDuration
            self.beginPlayTime = self.endPlayTime - 10.0
            self.beginPlayTime = self.beginPlayTime < 0.0 ? (0.0) :(self.beginPlayTime)
        }
        
        // 0.0/10.0s
        self.timeShowL.text = "\(self.beginPlayTime.toString())/\(self.endPlayTime.toString())s"
        
        // 右滑块滑动时,快进视频,但不影响开始时间
        if let isLeftDrag = self.isLeftDrag {
            
            if !isLeftDrag {
                
                self.player?.seekTimeToPlay(time: self.endPlayTime, isPlay: false)
            }
        }
    }
    
    // MARK: 定时器事件
    @objc func timeChangeAction() {
        
        if self.player != nil && !self.isDragging {
            
            var currentDuration: CGFloat = self.player!.currentItem!.currentTime().toFloat()
            currentDuration = currentDuration < 0.0 ?(0.0):(currentDuration)
            
            self.timeShowL.text = "\(currentDuration.toString())/\(self.endPlayTime.toString())s"
            
            if currentDuration >= self.endPlayTime || currentDuration > self.totalDuration {
                
                // 到达最大播放时长,重播
                self.player!.seekTimeToPlay(time: self.beginPlayTime, isPlay: true)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layout.itemSize = CGSize.init(width: self.cellWidth, height: self.colView.frame.height - 1.0)
        self.colView.dataSource = self
        self.colView.delegate = self
        self.colView.register(VideoClipCell.self, forCellWithReuseIdentifier: "VideoClipCell")
        // 自动偏移一个单元格
        self.colView.contentInset = UIEdgeInsetsMake(0.0, 30, 0.0, 30)
        self.leftCons.constant = 0//self.cellWidth - self.dragWidthCons.constant
        self.rightCons.constant = self.leftCons.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(resumePlay), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(pausePlay), name: NSNotification.Name.UIApplicationDidEnterBackground, object: nil)
    }
    @objc func resumePlay() {
        
        self.player?.play()
    }
    @objc func pausePlay() {
        
        self.player?.pause()
    }
}

extension VideoClipView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // 结束滚动
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // 结束时间
        self.setTimeShowLabel()
        // 快进到开始时间
        self.player?.seekTimeToPlay(time: self.beginPlayTime, isPlay: true)
        // 手指离开,定时器继续工作
        self.isDragging = false
        // 播放器音量回复
        self.player?.volume = 1.0
        print("开始时间:\(self.beginPlayTime)")
        print("结束时间:\(self.endPlayTime)")
    }

    // 开始滚动
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if self.player != nil {
            self.isDragging = true
        }
        self.player?.volume = 0.0
        
        var offsetX = scrollView.contentOffset.x + self.cellWidth
        offsetX = max(0.0, offsetX)
        
        // 快进了多少秒
        self.scrolPlayTime = offsetX * self.videoAsecptNum
        // 开始时间
        self.beginPlayTime = self.leftPlayTime + self.scrolPlayTime
        self.player?.seekTimeToPlay(time: self.beginPlayTime, isPlay: false)
        // 结束时间
        self.setTimeShowLabel()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.scrollViewDidEndDecelerating(scrollView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.imgsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoClipCell", for: indexPath) as! VideoClipCell
        cell.coverImgV.image = self.imgsArr[indexPath.row]
        
        return cell
    }
}
