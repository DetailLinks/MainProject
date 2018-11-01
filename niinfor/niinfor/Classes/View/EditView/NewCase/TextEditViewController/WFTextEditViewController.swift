//
//  WFTextEditViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/29.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import IQKeyboardManager
var toolViewHeight : CGFloat = 44
class WFTextEditViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        removeTabelView()
        IQKeyboardManager.shared().isEnabled = false
        title = "编辑文字"
        setUpUi()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHidde(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }

    lazy var toolBar = WFToolBarView.init(frame: CGRect(x: 0,
                                                        y: Screen_height - toolViewHeight,
                                                        width: Screen_width,
                                                        height: toolViewHeight))
    
    var editView  = RichEditorView.init(frame: CGRect.zero)
    
    var btnright = UIButton.init()
    
    var complictBlock : ((String,String )->())?
    
    var htmlString = "<h1>My Awesome Editor</h1><h3>Now I am editing in <em>style.</em></h3>"
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension WFTextEditViewController : RichEditorDelegate{
    func richEditor(_ editor: RichEditorView, contentDidChange content: String) {
        btnright.isSelected = !content.isEmpty &&  content != "<br>"
        btnright.isEnabled  = !content.isEmpty &&  content != "<br>"
        print(content)
        
    }
}

extension WFTextEditViewController{
    
    func removeHTML(htmlString : String)->String{
        return htmlString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    @objc func rightBtnclick(){
        
         if let comlickt =  complictBlock {
//            print(toolBar.toolbar.editor?.html)
//            print(toolBar.toolbar.editor?.contentHTML)
//            print(toolBar.toolbar.editor?.text)
            
            let text = removeHTML(htmlString: (toolBar.toolbar.editor?.html)!)
            comlickt(text, (toolBar.toolbar.editor?.html)!)
            self.navigationController?.popViewController(animated: true)
        }
       
    }
    @objc func leftBtnclick(){
        dismiss(animated: true, completion: nil)
    }
    
}

extension WFTextEditViewController {
    
  @objc  func keyboardWillShow(_ notification : Notification) {
    let duration  = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
    let transformY  = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
    
    UIView.animate(withDuration: TimeInterval(duration)) {

        self.toolBar.frame = CGRect(x: 0, y: Screen_height - transformY.size.height - toolViewHeight, width: Screen_width, height: toolViewHeight)
    }
    }
    
  @objc  func keyboardWillHidde(_ notification : Notification) {
    
    let duration  = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! CGFloat
    UIView.animate(withDuration: TimeInterval(duration)) {
        
        self.toolBar.frame = CGRect(x: 0, y: Screen_height -  toolViewHeight, width: Screen_width, height: toolViewHeight)
    }
    }

}

extension WFTextEditViewController {
    
    fileprivate func setUpUi() {
        
        view.insertSubview(editView, belowSubview: self.navBar)
        view.addSubview(toolBar)
        toolBar.setSubToolBar()
        editView.delegate = self
        toolBar.setToolBarEdit(editView)
        
        btnright   = UIButton.cz_textButton("完成",
                                            fontSize: 15,
                                            normalColor: .gray,
                                            highlightedColor: UIColor.white)
        
        btnright.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .selected)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        editView.html = htmlString
        editView.snp.makeConstraints { (maker ) in
            maker.bottom.right.left.equalTo(view)
            maker.top.equalToSuperview().offset(64)
        }
    }
    
    func richEditorStateChange(_ editor: RichEditorView, currentStates states: [String]) {
        toolBar.freshState(states)
    }
    
}
