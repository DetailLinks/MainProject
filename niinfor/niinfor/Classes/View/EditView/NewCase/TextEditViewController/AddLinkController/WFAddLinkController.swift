//
//  WFAddLinkController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/30.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class WFAddLinkController: UIViewController {

    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "插入链接"
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        setUI()
        setContant()
     }
 
  var blockCompliction : ((String,String)->Void)?
    
  fileprivate  let firstView  =  UIView.init(frame: CGRect.zero)
  fileprivate  let secondView  =  UIView.init(frame: CGRect.zero)
    fileprivate  let linkAddressTF : UITextField = {
        let text =  UITextField.init()
        text.placeholder = "链接地址"
        text.text = "http://"
        return text
    }()
    fileprivate  let linkDesTF : UITextField = {
        let text =  UITextField.init()
        text.placeholder = "链接描述"
        return text
    }()
    var  btnright = UIButton.init()
  fileprivate  let linkbtn = UIButton.init()
}

extension WFAddLinkController{

    @objc func rightBtnclick(){
        dismiss(animated: true) {
            guard let complict = self.blockCompliction else {
                return
            }
            complict(self.linkAddressTF.text!,self.linkDesTF.text!)
        }
    }
    @objc func leftBtnclick(){
          dismiss(animated: true, completion: nil)
    }

}

extension WFAddLinkController{
    
    fileprivate func setUI() {
        
        view.addSubview(firstView)
        view.addSubview(secondView)
        firstView.addSubview(linkAddressTF)
        firstView.addSubview(linkbtn)
        secondView.addSubview(linkDesTF)
        firstView.backgroundColor = UIColor.white
        secondView.backgroundColor = UIColor.white
        linkbtn.setImage(#imageLiteral(resourceName: "link_select"), for: .normal)
        
        setNavigationBtn()
        
        let linkValid = linkAddressTF.rx.text.orEmpty.map {$0.count > 0}.share(replay: 1, scope: .forever)
        let linkDesValid = linkDesTF.rx.text.orEmpty.map {$0.count > 0}.share(replay: 1, scope: .forever)

        let bothLinkValid = Observable.combineLatest(linkValid,linkDesValid) { $0 && $1}.share(replay: 1, scope: .forever)
        
        bothLinkValid.bind(to:btnright.rx.isEnabled).disposed(by: disposeBag)
        bothLinkValid.bind(to:btnright.rx.isSelected).disposed(by: disposeBag)
    }
    
    fileprivate func setNavigationBtn() {
        
        btnright   = UIButton.cz_textButton("完成", fontSize: 15, normalColor: .gray, highlightedColor: UIColor.white)
        btnright.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .selected)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        let btnleft  = UIButton.cz_textButton("取消", fontSize: 15, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: UIColor.white)
        btnleft?.addTarget(self, action: #selector(leftBtnclick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnleft!)
    }
    
    fileprivate func setContant() {
        
        firstView.snp.makeConstraints({ (maker) in
          maker.left.right.width.equalToSuperview()
          maker.height.equalTo(50)
          maker.top.equalToSuperview().offset(80)
        })
        
        secondView.snp.makeConstraints { (maker) in
            maker.left.right.height.width.equalTo(firstView)
            maker.top.equalTo(firstView.snp.bottom).offset(1)
        }
        
        linkbtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(4)
            maker.bottom.equalToSuperview().offset(4)
            maker.top.equalToSuperview().offset(10)
            maker.width.equalTo(50)
            maker.height.equalTo(20)
        }
        
        linkAddressTF.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalTo(linkbtn.snp.left).offset(10)
            maker.bottom.equalToSuperview().offset(-6)
            maker.height.equalTo(24)
        }
        
        linkDesTF.snp.makeConstraints { (maker) in
            maker.left.equalToSuperview().offset(16)
            maker.right.equalToSuperview().offset(10)
            maker.bottom.equalToSuperview().offset(-6)
            maker.height.equalTo(24)
        }

    }
}



















