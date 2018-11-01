//
//  WFEditTitleViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/7.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
class WFEditTitleViewController: BaseViewController {
    
    fileprivate var textView : UITextView = UITextView.init(frame: CGRect.zero)
    fileprivate var btnright : UIButton = UIButton.init()
    fileprivate var tipLabel : UILabel = UILabel.init()
    fileprivate var rightTipLabel : UILabel = UILabel.init()
    var titleString  = ""
    
    var complict : ((String)->())?

    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }

}

///响应事件
extension WFEditTitleViewController{
    
    @objc func rightBtnclick(){
        
        if textView.text == "" {
            SVProgressHUD.showError(withStatus: "标题不能为空")
            return
        }
        if complict != nil  {
           let text = textView.text.replacingOccurrences(of: "\n", with: "")
           complict!(text)
           navigationController?.popViewController(animated: true)
        }
    }
    
    @objc  func notificationChangeed()  {
        
        tipLabel.text = textView.hasText ? "" : "输入文章标题"
        if textView.text.count > 50 {
           textView.text = textView.text.substring(to: String.Index.init(encodedOffset: 50))
        }
    }
        
}

extension WFEditTitleViewController{
    override func setUpUI() {
        super.setUpUI()
        title = "修改标题"
        removeTabelView()
        addSubView()
        addConstant()
        setNavigationBtn()
        
        textView.text = titleString
        tipLabel.text = textView.hasText ? "" : "输入文章标题"
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChangeed), name:NSNotification.Name.UITextViewTextDidChange , object: nil)
        
    }
   
    fileprivate func setNavigationBtn() {
        
        btnright   = UIButton.cz_textButton("完成", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
    }

    
   fileprivate func addSubView() {
        view.addSubview(textView)
        textView.addSubview(tipLabel)
        view.addSubview(rightTipLabel)
        textView.font = UIFont.systemFont(ofSize: 16)
        tipLabel.font = UIFont.systemFont(ofSize: 16)
        rightTipLabel.font = UIFont.systemFont(ofSize: 12)
        rightTipLabel.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        tipLabel.textColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        rightTipLabel.text = "标题不能多于50个字"
        tipLabel.text = "输入文章标题"
        rightTipLabel.textAlignment = .right
    
    }
    
   fileprivate func addConstant() {
    textView.snp.makeConstraints { (maker) in
        
        maker.left.equalToSuperview().offset(20)
        maker.right.equalToSuperview().offset(-20)
        maker.top.equalToSuperview().offset(navigation_height + 10)
        maker.height.equalTo(150)
        
    }
    
    tipLabel.snp.makeConstraints { (maker) in
        maker.left.right.equalToSuperview().offset(8)
        maker.top.equalToSuperview().offset(2)
        maker.height.equalTo(30)
    }
    
    rightTipLabel.snp.makeConstraints { (maker) in
        maker.bottom.right.left.equalTo(textView).offset(-6)
        maker.height.equalTo(20)
    }
    }
}
