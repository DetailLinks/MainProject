
//
//  WFTagView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/21.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFTagView: UIView {

    init() {
        super.init(frame: CGRect())
    }
    
    var btnWitdh : CGFloat = 0
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var titleArray = [TagModel]()
}

extension WFTagView{
    func configView(title : [TagModel]) {
        if title.isEmpty == true{return}
        
        for item  in title {
            createTagView(item)
        }
        layoutIfNeeded()
    }
    
    func clearView() {
        btnWitdh = 0
        for view   in self.subviews {
            if view.isMember(of: UIButton.self){
                view.removeFromSuperview()
            }
        }
    }
    
    func createTagView(_ title : TagModel ){
        
        let button  = UIButton.init()
        addSubview(button)

        button.tag = title.id
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        button.layer.borderWidth  = 1
        button.layer.borderColor  = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        button.setAttributedTitle(NSAttributedString.init(string: title.name, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10),NSForegroundColorAttributeName : #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)]), for: .normal)
        
        button.snp.makeConstraints { (maker) in
            maker.top.height.bottom.equalToSuperview()
            maker.width.equalTo(titleWidth(title: title.name) + 10)
            maker.left.equalToSuperview().offset(btnWitdh)
        }
        
        button.updateConstraints()
        button.layer.cornerRadius  = constraints[0].constant / 2
        button.clipsToBounds       = true
        btnWitdh += (titleWidth(title: title.name) + 18)
    }
    
    func titleWidth(title : String) -> CGFloat {
        return (title as NSString).boundingRect(with: CGSize.init(width: 1000, height: 1000), options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 10)], context: nil).size.width
    }
    
    @objc func btnClick(_ btn : UIButton){
        var nextView = self.superview
        while nextView != nil  {
            let nextResponder = nextView?.next
            if (nextResponder?.isKind(of: UIViewController.self))!{
                let vs = nextResponder as! BaseViewController
                
                if  vs.isMember(of: WFMoreClassConttoller.self){
                    let vs = nextResponder as! WFMoreClassConttoller
                    vs.title = btn.titleLabel?.text ?? ""
                    vs.tagId = "\(btn.tag)"
                    return
                }
                let vc = WFMoreClassConttoller()
                    vc.isFreeClass = false
                    vc.title = btn.titleLabel?.text ?? ""
                    vc.tagId = "\(btn.tag)"
                    vc.isShowBack = true
                if vs.navigationController != nil {
                    vs.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let nav = WFNavigationController.init(rootViewController: vc)
                    vc.isShowBack = true
                    vs.present(nav , animated: true, completion: nil)
                }
                return
            }else {
                nextView = nextView?.superview
            }
        }

    }
    
}








