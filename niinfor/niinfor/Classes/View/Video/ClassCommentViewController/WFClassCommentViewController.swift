//
//  WFClassCommentViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/10/13.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFClassCommentViewController: BaseViewController {

    var classID  = ""
    var parentId = ""
    
    var isShowStar : Bool = true
    
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
    
    
    @IBOutlet weak var StarHeightCons: NSLayoutConstraint!
    fileprivate var starScore  : CGFloat = -1
    @IBOutlet weak var starView: UIImageView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var naviBarCons: NSLayoutConstraint!
    @IBOutlet weak var startWidthCons: NSLayoutConstraint!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBAction func commentBtnClick(_ sender: UIButton) {
        
        if textView.text.isEmpty {
            SVProgressHUD.showInfo(withStatus: "评价内容不能为空")
            return
        }
        
        if parentId == ""  && starScore == -1 {
            SVProgressHUD.showInfo(withStatus: "请给课程评分")
            return
        }
        
        NetworkerManager.shared.courseComment(courseId: classID, content: textView.text, score: String.init(format: "%.1f", starScore  == -1 ? 0 : starScore), parentId: parentId) { (isSuccess, json) in
            if isSuccess {
                self.dismiss(animated: true, completion: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_comment_success_notify), object: nil)
            }
        }
        
    }
    
}

extension WFClassCommentViewController {
    override func setUpUI() {
        super.setUpUI()
        removeTabelView()
        setTapView()
        
        title = "课程评价"
        
        view.backgroundColor = UIColor.white
        
        //setNavgationBar()
        StarHeightCons.constant = isShowStar ? 128 : 0
        view.layoutIfNeeded()

        naviBarCons.constant = navigation_height
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChangeed), name:NSNotification.Name.UITextViewTextDidChange , object: nil)
    }
    
    fileprivate func setNavgationBar(){
        
        let item  = UIBarButtonItem(imageString: "nav_icon_back", target: self, action: #selector(popViewController), isBack: true , fixSpace : 12 )
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -10
        navItem.leftBarButtonItems = [spaceItem,item]
    }
    
    @objc func popViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func setTapView() {
        
        let tap  = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureRecognezer(_:)))
        tapView.addGestureRecognizer(tap)
        
    }
    
    @objc func tapGestureRecognezer(_ tap : UITapGestureRecognizer){
        
        let tapPoint = tap.location(in: tapView)
        let offset   = tapPoint.x

        
        let startWidth  = starView.frame.size.width
        let point =  (offset).truncatingRemainder(dividingBy:startWidth + 10)
        
        if point < startWidth {
           
            let estimateScore : CGFloat = ( point / startWidth ) >= 0.5 ? 1 : 0
            
           starScore =  estimateScore +  (offset - point) / (startWidth + 10)
        }else{
           starScore = 1 +  (offset - point) / (startWidth + 10)
        }
        
        startWidthCons.constant = starScore * (startWidth + 10)
        view.layoutIfNeeded()
        }
    
    @objc private func notificationChangeed()  {
        
        tipLabel.isHidden = textView.hasText
        if textView.text.count > 300 {
            textView.text = textView.text.substring(to: String.Index.init(encodedOffset: 300))
            SVProgressHUD.showInfo(withStatus: "最多输入三百字")
        }
    }
}
