//
//  WFVoiceViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/31.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
class WFVoiceViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUIAndConstant()
    }
    
    var ContentIsImpty  = true
    
    
    lazy var backImageView : UIImageView = {
        let imageV = UIImageView.init(image: UIImage.init(named:"5编辑文字1 copy 2"))
        return imageV
    }()
    
    lazy var backView : UIView = {
        let backV = UIView.init()
        backV.backgroundColor = UIColor.clear
        return backV
    }()
    
    lazy var topView : UIView = {
        let backV = UIView.init()
        backV.backgroundColor = UIColor.clear
        return backV
    }()

    let voiceImageView = UIImageView.init(image: #imageLiteral(resourceName: "Oval"))
    lazy var recordBtn : UIButton = {
        let btn = UIButton.init()
//        btn.setImage(#imageLiteral(resourceName: "语音"), for: .normal)
        btn.setImage(UIImage(), for: .selected)
        btn.setAttributedTitle(NSAttributedString.init(string: "00 ：00：00", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 26),NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]), for: .selected)
        btn.isSelected = true
        return btn
    }()
    
    lazy var deleteBtn : UIButton = {
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "取消"), for: .normal)
        btn.addTarget(self, action: #selector(deleteVoice(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var bingoBtn : UIButton = {
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "完成 copy"), for: .normal)
        btn.addTarget(self, action: #selector(complictVoice(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var pauseBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect.zero)
        btn.setImage(#imageLiteral(resourceName: "Combined Shape"), for: .normal)
        btn.addTarget(self, action: #selector(startOrStopRecording(_:)), for: .touchUpInside)
        btn.setImage(#imageLiteral(resourceName: "暂停 copy"), for: .selected)
        return btn
    }()
    
    var filePath  = ""
    
    lazy var voiceRecoder : WFVoiceRecorder = WFVoiceRecorder.share()
    lazy var timer : Timer = Timer.scheduledTimer(timeInterval: 1.1, target: self, selector: #selector(timerRepeat), userInfo: nil, repeats: true)
    
    var recordVoiceCoplict : ((String)->())?
    
    
    fileprivate var hour = 0
    fileprivate var miniter = 0
    fileprivate var second = 0
}

///响应事件
extension WFVoiceViewController{
    @objc func deleteVoice(_ btn : UIButton) {
          print("deleteVoice")
        if voiceRecoder.voiceIsRecoding == true{
            timer.fireDate = Date.distantFuture
            self.voiceRecoder.stopRecorder()
        }
          self.voiceRecoder.deleteVoiceFile()
          timer.fireDate = Date.distantFuture
        recordBtn.setAttributedTitle(NSAttributedString.init(string: "00 ：00：00", attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 26),NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]), for: .selected)
          ContentIsImpty = true
          pauseBtn.isSelected = false
        
          self.originTimeNumber()
    }
    @objc func startOrStopRecording(_ btn : UIButton) {
          print("startOrStopRecording")
          btn.isSelected = !btn.isSelected
          if btn.isSelected == true {
            ContentIsImpty = false
            timer.fireDate = Date.distantPast
//            self.recordBtn.isSelected = true
//            if self.voiceRecoder.recorderFileIsExit() != 0{
//               print("开始播放")
//               self.voiceRecoder.startPlaying()
//            }else{
                print("开始录制")
                self.voiceRecoder.beginRecorder()
                filePath = self.voiceRecoder.filePath!
//            }
          }else{
            timer.fireDate = Date.distantFuture
//            self.recordBtn.isSelected = false
//            if self.voiceRecoder.voiceIsRecoding{
                print("暂停录制")
                self.voiceRecoder.pauseRecoder()
//            }else{
//                print("停止播放")
//                self.voiceRecoder.pausePlaying()
//            }
          }
    }
    @objc func complictVoice(_ btn : UIButton) {
          print("complictVoice")
        
        if ContentIsImpty == true {
           SVProgressHUD.showInfo(withStatus: "您还没有录入任何信息")
            return
        }
        
        if  recordVoiceCoplict != nil {
            
            if voiceRecoder.voiceIsRecoding == true{
               timer.fireDate = Date.distantFuture
               self.voiceRecoder.stopRecorder()
            }else{
               self.voiceRecoder.stopRecorder()
            }
            recordVoiceCoplict!(filePath)
            try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategorySoloAmbient)
        }
        dismiss(animated: true, completion: nil )
    }
    @objc func leftBtnclick(){
        if voiceRecoder.voiceIsRecoding == true{
            timer.fireDate = Date.distantFuture
            self.voiceRecoder.stopRecorder()
        }
          dismiss(animated: true, completion: nil)
    }
    
    @objc func timerRepeat(){
        
        second += 1
        
        if second == 60 {
           miniter += 1
           second = 0
            
           if miniter == 60 {
              hour += 1
              miniter = 0
            }
        }
        recordBtn.setAttributedTitle(NSAttributedString.init(string: String.init(format: "%02ld ：%02ld：%02ld", hour,miniter,second), attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 26),NSForegroundColorAttributeName : #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)]), for: .selected)
        //recordBtn.setTitle(String.init(format: "%02ld ：%02ld:%02ld", hour,miniter,second), for: .selected)
    }

}

///MARK: 设置UI和约束
extension WFVoiceViewController{
    
   fileprivate func setUpUIAndConstant() {
        title = "录音"
        setUI()
        setConstant()
        self.voiceRecoder.playingComplict = {[weak self](isFinish) in
            self?.pauseBtn.isSelected = false
            self?.timer.fireDate = Date.distantFuture
            self?.recordBtn.isSelected = false
            self?.originTimeNumber()
        }
        timer.fireDate = Date.distantFuture
    }
    
   fileprivate func setUI() {
        setNabigation()
        view.backgroundColor = UIColor.white
        view.addSubview(backImageView)
        view.addSubview(backView)
        view.addSubview(topView)
        topView.addSubview(voiceImageView)
        topView.addSubview(recordBtn)
        backView.addSubview(deleteBtn)
        backView.addSubview(pauseBtn)
        backView.addSubview(bingoBtn)
    }
    
    fileprivate func setNabigation() {
        setNavigationBar()
        setNavigationLeftItem()
    }
    
    fileprivate func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
    }
    
    fileprivate func setNavigationLeftItem() {
        let btnleft  = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        btnleft.setImage(#imageLiteral(resourceName: "返回"), for: .normal)
        btnleft.addTarget(self, action: #selector(leftBtnclick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnleft)

    }
    
    fileprivate func originTimeNumber(){
         hour = 0
         miniter = 0
         second = 0
    }
}

extension WFVoiceViewController{
    fileprivate func setConstant(){
        
        backImageView.snp.makeConstraints { (maker) in
            maker.left.top.width.height.equalToSuperview()
        }
        
        backView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalToSuperview().offset(transHeight(-151.0))
            maker.height.equalTo(transHeight(208.0))
        }
        
        topView.snp.makeConstraints { (maker) in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().offset(transHeight(235.0))
            maker.height.width.equalTo(Screen_width * 433.0 / 750.0 )
        }
        
        voiceImageView.snp.makeConstraints { (maker) in
            maker.right.left.top.bottom.equalToSuperview()
        }
        
        recordBtn.snp.makeConstraints { (maker) in
            maker.right.left.top.bottom.equalToSuperview()
        }

        pauseBtn.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(backView.snp.centerX)
            maker.top.equalTo(backView)
            maker.width.equalTo(backView).multipliedBy(1.0/3.0)
            maker.height.equalTo(backView.snp.height)
        }
        
        deleteBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(pauseBtn)
            maker.width.height.equalTo(Screen_width / 4)
            maker.right.equalTo(pauseBtn.snp.left)
        }

        bingoBtn.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(pauseBtn)
            maker.width.height.equalTo(Screen_width / 4)
            maker.left.equalTo(pauseBtn.snp.right)
        }
    }
}


