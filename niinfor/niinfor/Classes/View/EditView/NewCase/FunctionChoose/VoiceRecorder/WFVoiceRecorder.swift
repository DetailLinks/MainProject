//
//  WFVoiceRecorder.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/31.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import AVFoundation
class WFVoiceRecorder : NSObject {

    
    class func share() ->WFVoiceRecorder{
        let recoder : WFVoiceRecorder = WFVoiceRecorder.init()
//            recoder.audioRecorder.delegate = recoder
        return recoder
    }
    
    //录音器
    var audioRecorder:AVAudioRecorder!
    //播放器
    var audioPlayer:AVAudioPlayer!
    //获取音频会话单例
    let audioSession = AVAudioSession.sharedInstance()
    var filePath : String?
    
    var playingComplict : ((Bool)->())?
    
    
    /**
     定义音频的编码参数
     AVSampleRateKey:声音采样率 8000/11025/22050/44100/96000（影响音频的质量）
     AVFormatIDKey:编码格式
     AVLinearPCMBitDepthKey:采样位数  8、16、24、32 默认为16
     AVNumberOfChannelsKey:音频通道数 1 或 2
     AVEncoderAudioQualityKey:音频质量
     */
    let recordSettings = [AVSampleRateKey:NSNumber.init(value: 44100.0),AVFormatIDKey:NSNumber.init(value:kAudioFormatLinearPCM),AVLinearPCMBitDepthKey:NSNumber.init(value: 16),AVNumberOfChannelsKey:NSNumber.init(value: 1),AVEncoderAudioQualityKey:NSNumber.init(value:AVAudioQuality.high.rawValue)]
    
    var voiceIsPlaying : Bool {
        return audioPlayer.isPlaying
    }
    var voiceIsRecoding : Bool {
        return audioRecorder.isRecording
    }

    
    override init() {
        super.init()
        initRecorder()
    }
    
    func initRecorder() {
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            //MARK:加这段代码解决声音很小的问题
            try audioSession.overrideOutputAudioPort(AVAudioSessionPortOverride.speaker)
            try audioRecorder = AVAudioRecorder(url: self.directoryUrl()! as URL, settings: recordSettings)
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.delegate = self
        } catch let error as NSError {
            print(error)
        }
    }
    
    func directoryUrl () -> NSURL? {
        let path = NSTemporaryDirectory()//NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        filePath = path + "/\(getTimeStamp())record.wav"
        print(filePath)
        let fileUrl = NSURL.init(fileURLWithPath: filePath!)
        return fileUrl
    }
    
   fileprivate  func getTimeStamp() -> String {
    
    let dataFommter = DateFormatter()
    dataFommter.dateFormat = "yyyyMMddhhmmss"
    let date  = Date()
    return dataFommter.string(from: date)
    }
    
      func beginRecorder() {
        //如果正在播放，则停止播放
        if let audio = audioPlayer {
            if audio.isPlaying {
                audio.stop()
            }
        }
        
        if !audioRecorder.isRecording {
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch let error as NSError {
                print(error)
            }
        }
    }
    
    
    func pauseRecoder() {
         if audioRecorder.isRecording {
//            do {
//                try audioSession.setActive(true)
                audioRecorder.pause()
//            } catch let error as NSError {
//                print(error)
//            }

        }
    }
    
    func stopRecorder() {
        
         print("停止录制")
            audioRecorder.stop()
            do {
                try audioSession.setActive(false)
            } catch let error as NSError {
                print(error)
            }
    }
    
    func startPlaying() {
        
//        audioRecorder.stop()
        do {
            print(audioRecorder.url.path)
            let url:URL? = audioRecorder.url//directoryUrl() as URL?  //
            if let url = url {
                try audioPlayer = AVAudioPlayer.init(contentsOf: url)
//                audioPlayer.delegate = self
                let isPlay = audioPlayer.play()
                print("------isPlay")
                print(isPlay)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    func pausePlaying() {
        
        if let player = audioPlayer {
            if player.isPlaying {
                
                    player.pause()
            }
        }
    }
    
    func recorderFileIsExit() -> Float {
        //计算录制文件的大小
        let manager = FileManager.default
        if manager.fileExists(atPath: filePath!) {
            do {
                let attr = try manager.attributesOfItem(atPath: filePath!)
                let size = attr[FileAttributeKey.size] as! Float
                print("文件大小为 \(size/1024.0)Kb")
                return size
            } catch let error as NSError {
                print(error)
            }
        }
        return 0
    }
    
    func getVoiceFileDuration() ->Float{
        let url:URL? = audioRecorder.url
        if let url = url {
            try? audioPlayer = AVAudioPlayer.init(contentsOf: url)
            return Float(audioPlayer.duration)
        }
        return 0
    }
    
    
    func  deleteVoiceFile(){
          let manager = FileManager.default
          if manager.fileExists(atPath: self.filePath!) {
             try? manager.removeItem(atPath: self.filePath!)
          }
    }

}



extension WFVoiceRecorder : AVAudioRecorderDelegate {

        func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag {
                print("录制完成")
            }else{
                print("录制录制")
            }
        }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print(error)
    }
    
    }

extension Data {
    
    func saveToPath(_ pathN : String = "") -> String {
        let path = NSTemporaryDirectory()//NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last
        let filePath = path + "/\(getTimeStamp())sl\(pathN)jflsjflsrecord.wav"
        let fileUrl = URL.init(fileURLWithPath: filePath)
        var error = NSError()
        
        do {
            try self.write(to: fileUrl)
            
        } catch let err as NSError {
            
            error = err
        }

        return filePath
    }
    
    func getTimeStamp() -> String {
        
        let dataFommter = DateFormatter()
        dataFommter.dateFormat = "yyyyMMddhhmmss"
        let date  = Date()
        return dataFommter.string(from: date)
    }
    
    func saveVideoToPath(_ pathN : String = "") -> String {
        //  NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        let VideoSavePath: String = NSTemporaryDirectory() +
        "\(getTempPath())shor\(pathN)tVideoTemp.mp4"
        
        let fileUrl = URL.init(fileURLWithPath: VideoSavePath)
        var error : NSError?
        
        do {
            try self.write(to: fileUrl)
            
        } catch let err as NSError {
            
            error = err
            print(error)
        }

        return VideoSavePath
    }
    
}


extension WFVoiceRecorder : AVAudioPlayerDelegate {

        func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
            if flag {
                if playingComplict != nil {
                    playingComplict!(true)
                }
                print("播放完成")
            }
        }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print(error)
    }
    
    func audioPlayerBeginInterruption(_ player: AVAudioPlayer) {
         print("audioPlayerBeginInterruption")
    }
    func audioPlayerEndInterruption(_ player: AVAudioPlayer, withOptions flags: Int) {
         print("audioPlayerEndInterruption")
    }
    
    
}

