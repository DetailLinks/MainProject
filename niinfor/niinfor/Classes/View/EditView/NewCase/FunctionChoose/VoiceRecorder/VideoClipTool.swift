//
//  VideoClipTool.swift
//  视频裁剪修改版本
//
//  Created by 张崇超 on 2018/6/29.
//  Copyright © 2018年 ZCC. All rights reserved.
//

import UIKit
import AVKit

class VideoClipCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(coverImgV)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var coverImgV: UIImageView = {
        let imgV = UIImageView.init(frame: self.contentView.bounds)
        imgV.contentMode = .scaleAspectFill
        imgV.clipsToBounds = true
        
        return imgV
    }()
    
}

extension CGFloat {
    
    /// 获取 0.0格式的float数
    ///
    /// - Returns: 100.0
    func intFloatNum() -> CGFloat {
        
        let str = self.toString()
        return CGFloat(Double(str)!)
    }
    
    /// 转为字符传
    ///
    /// - Returns: "10.0"
    func toString() -> String {
        return String.init(format: "%.1f", self)
    }
}
// NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
//filePath = (path)! + "/\(getTimeStamp())record.wav"
//Library/Caches NSTemporaryDirectory
let VideoSavePath: String =  NSTemporaryDirectory() +
 "\(getTempPath())shortVideoTemp.mp4"

func getVideoSavePath() -> String{
    return NSTemporaryDirectory() +
    "\(getTempPath())shortVideoTemp.mp4"
}

 func getTempPath() -> String{
    
    let dataFommter = DateFormatter()
    dataFommter.dateFormat = "yyyyMMddhhmmss"
    let date  = Date()
    return dataFommter.string(from: date)
}

var timerNumber = 4


class VideoClipTool: NSObject {
    
    /// 展示View
    ///
    /// - Parameters:
    ///   - videoPath: 视频地址
    ///   - baseView: 父视图
    ///   - callBack: 处理完的回调
    static func showTool(_ isOnlylook : Bool = false,_ controller : UIViewController = UIViewController(), videoPath: String, baseView: UIView, callBack: ((_ path: String)-> Void)?) {
        
        let tool = VideoClipView.loadXibView(videoPath: videoPath,isOnlylook, callBack: callBack)
        tool.controller = controller
        tool.transform = CGAffineTransform.init(translationX: 0.0, y: kHeight)
        baseView.addSubview(tool)
        
        UIView.animate(withDuration: 0.3, animations: {
            
            tool.transform = CGAffineTransform.identity
        })
    }
    
    /// 裁剪视频
    static func videoClipMethod(fileUrl: URL, startTime: CGFloat, endTime: CGFloat, callBack: ((_ path: String) ->Void)?) {
        
        let asset = AVAsset.init(url: fileUrl)
        let exportSession : AVAssetExportSession! = AVAssetExportSession.init(asset: asset, presetName: AVAssetExportPresetPassthrough)
        

        // 重新保存   VideoSavePath.components(separatedBy: ".").joined(separator: "S.")
        let fUrl: URL = URL.init(fileURLWithPath:getVideoSavePath())
        exportSession.outputURL = fUrl
        exportSession.outputFileType = AVFileTypeMPEG4
        exportSession.shouldOptimizeForNetworkUse = true
        
        print("又传入的路径")
        print(getVideoSavePath())

        
        var videoTime = startTime
        if videoTime < 0 {
            videoTime = 0
        }

        let start = CMTimeMakeWithSeconds(Float64(videoTime), 1)
        let duration = CMTimeMakeWithSeconds(Float64(endTime - videoTime), 1)
        let range = CMTimeRange.init(start: start, duration: duration)
        exportSession.timeRange = range
        
        print("视频处理中")
        exportSession.exportAsynchronously(completionHandler: {
            switch exportSession.status{
            case AVAssetExportSessionStatus.failed :
                
                print("转换失败")
                print("Export failed " + (exportSession.error?.localizedDescription)!)
                break
                
            case AVAssetExportSessionStatus.cancelled:
                
                print("Export Canceled")
                print("转换取消")
                break
                
            case AVAssetExportSessionStatus.completed:
                
                print("Export completed:\(fUrl)")
                print("转换完成")
                // 移除之前保存的视频

                // 保存到相册
                UISaveVideoAtPathToSavedPhotosAlbum(fUrl.relativePath, nil, nil, nil)
                
                
                self.deleteTempFile(path: VideoSavePath)
                self.deleteTempFile(path:fileUrl.absoluteString)
                
                if FileManager.default.fileExists(atPath: fUrl.relativePath) == false{
                    timerNumber = timerNumber - 1
                    if timerNumber != 0{
                        
                        videoClipMethod(fileUrl: fileUrl, startTime: startTime, endTime: endTime, callBack: callBack)
                        return
                    }
                   callBack?("")
                }else{
                  callBack?(fUrl.relativePath)
                }

                break
                
            default:
                
                print("Export other status");
                break
            }
        })
    }
    // 删除之前保存的文件
    private static func deleteTempFile(path: String) {
        let url = NSURL.fileURL(withPath: path)
        let filem = FileManager.default
        var error : NSError?
        if filem.fileExists(atPath: url.path) {
            
            do {
                try filem.removeItem(at: url)
                
            } catch let err as NSError {
                
                error = err
            }
            if (error != nil) {
                print("file remove error, " + (error?.localizedDescription)!)
            }
        } else {
            
            print("no file by that name")
        }
    }
}

extension AVPlayer {
    
    /// 到指定时间播放
    ///
    /// - Parameter time: 时间
    func seekTimeToPlay(time: CGFloat, isPlay: Bool) {
        
        self.pause()
        let time = CMTime.init(seconds: Double(time), preferredTimescale: CMTimeScale(1 * NSEC_PER_SEC))
    
        self.seek(to: time, toleranceBefore: CMTime.init(value: 1, timescale: 30), toleranceAfter: CMTime.init(value: 1, timescale: 30)) { (isOk) in
            
            if isOk && self.status == .readyToPlay {
                
                isPlay ? (self.play()):(self.pause())
            }
        }
    }
}

extension CMTime {
    
    /// 转为float数
    ///
    /// - Returns: 时间
    func toFloat() -> CGFloat {
        return CGFloat(CMTimeGetSeconds(self))
    }
}

extension String {
    
    /// 根据地址获取视频时长
    ///
    /// - Returns: 视频时长
    func getVideoDuration() -> CGFloat {
        
        let urlAsset = AVURLAsset.init(url: URL.init(fileURLWithPath: self))
        return urlAsset.duration.toFloat()
    }
    
    
    /// 获取视频截图 3秒一截图
    ///
    /// - Returns: 截图数组
    func getVideoThumbImg(timeSpace: CGFloat = 3.0) -> [UIImage?] {
        
        var arr: [UIImage?] = []
        let avAsset: AVAsset = AVAsset.init(url: URL.init(fileURLWithPath: self))
        // 生成视频截图
        let generator = AVAssetImageGenerator(asset: avAsset)
        generator.appliesPreferredTrackTransform = true
        
        var seonds: CGFloat = 1.0
        for _ in 0...Int(avAsset.duration.toFloat()) {
            
            if seonds <= avAsset.duration.toFloat().intFloatNum() {
                
                let time = CMTimeMakeWithSeconds(Float64(seonds), 600)
                var actualTime:CMTime = CMTimeMake(0, 0)
                
                let imageRef: CGImage? = try? generator.copyCGImage(at: time, actualTime: &actualTime)
                
                var frameImg: UIImage?
                if let imageRef = imageRef {
                    
                    frameImg = UIImage.init(cgImage: imageRef)
                    arr.append(frameImg)
                }
                seonds += timeSpace.intFloatNum()
                
            } else {
                
                break
            }
        }
        return arr
    }
}



