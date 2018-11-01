//
//  WFToolBarView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/29.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

enum EditBtnEnum {
    case font
    case bold
    case aligment
    case sequnce
    case link
    case color
}
var toolBarTextColor = UIColor.black

class WFToolBarView: UIView , RichEditorToolbarDelegate {
    
    let imageString : [[String]]  = [["font","bold","sequnce","aligmnet","link_select","color"]]
    
    let toolbar = RichEditorToolbar(frame: CGRect.zero)
    var lastClickBtn : UIButton?
    //    var subToolView : SuView?
    var fontView: SuView?
    var boldView: SuView?
    var alignView: SuView?
    var orderView: SuView?
    var colorView: SuView?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setBtn()
        setToolBar()
    }
    
    @objc private func setBtn() {
        for tag  in 0...5 {
            let btn = UIButton.init()
            btn.tag = tag
            btn.setImage(UIImage.init(named: imageString[0][tag]), for: .normal)
            btn.setImage(UIImage.init(named: imageString[0][tag] + "_select"), for: .selected)
            addSubview(btn)
            btn.addTarget(self, action: #selector(toolBarBtnClick(_:)), for: .touchUpInside)
            btn.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.width.equalToSuperview().multipliedBy(1.0/6.0)
                maker.height.equalTo(44)
                maker.left.equalToSuperview().offset( CGFloat(tag) * Screen_width / 6.0)
            }
        }
        
    }
    
    func setToolBarEdit(_ richView : RichEditorView) {
        toolbar.editor = richView
    }
    
    func freshState(_ states: [String]) {
        fontView?.freshState(states)
        boldView?.freshState(states)
        alignView?.freshState(states)
        orderView?.freshState(states)
        colorView?.freshState(states)
    }
    
    private func setToolBar() {
        
        //        toolbar.options = RichEditorDefaultOption.all
        //        addSubview(toolbar)
        toolbar.delegate = self
    }
    
    func richEditorToolbarChangeTextColor(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.setTextColor(toolBarTextColor)
    }
    //    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
    //        toolbar.editor?.insertLink(linkString, title: linkDesString)
    //    }
    
    func richEditorToolbarInsertLink(_ toolbar: RichEditorToolbar) {
        toolbar.editor?.insertLink("http://baidu.com", title: "百度")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSubToolBar() {
        
        fontView = initSubBtns(selectBtnEnum: .font)
        boldView = initSubBtns(selectBtnEnum: .bold)
        alignView = initSubBtns(selectBtnEnum: .aligment)
        orderView = initSubBtns(selectBtnEnum: .sequnce)
        colorView = initSubBtns(selectBtnEnum: .color)
    }
}

extension WFToolBarView{
    func initSubBtns(selectBtnEnum : EditBtnEnum) -> SuView {
        let subToolView = SuView.suToolView(CGRect.init(x: 0, y: frame.origin.y - 55, width: Screen_width, height: 44), selectBtnEnum)
        subToolView.toolbar = toolbar
        subToolView.isHidden = true
        subToolView.snp.removeConstraints()
        subToolView.removeFromSuperview()
        superview?.addSubview(subToolView)
//        addSubview(subToolView)
        subToolView.snp.makeConstraints({ (maker ) in
            maker.left.right.width.equalToSuperview()
            maker.height.equalTo(44)
            maker.bottom.equalTo(self.snp.top).offset(0)
        })
        return subToolView
    }
    @objc  func toolBarBtnClick(_ btn : UIButton) {
        var selectBtnEnum : EditBtnEnum = .font
        
        var subView:SuView?
        switch btn.tag {
        case 0: selectBtnEnum = .font ;subView = self.fontView; break
        case 1: selectBtnEnum = .bold ;subView = self.boldView; break
        case 2: selectBtnEnum = .aligment ;subView = self.alignView; break
        case 3: selectBtnEnum = .sequnce ;subView = self.orderView;break
        case 4: selectBtnEnum = .link ;break
        case 5: selectBtnEnum = .color ;subView = self.colorView;break
        default: break
        }
        
        let preSelected = btn.isSelected
        //按钮都变灰
        for item  in self.subviews {
            if let item = item as? UIButton{
                if item.tag == 4 {continue}
                item.isSelected = false
            }
        }
        
        if selectBtnEnum == .link {
            let controller = viewController(self)
            let vc  = WFAddLinkController()
            let navigationC  = UINavigationController.init(rootViewController: vc)
            vc.blockCompliction = { [weak self](linkString , desString ) in
                self?.toolbar.editor?.insertLink(linkString, title: desString)
            }
            controller?.present(navigationC, animated: true, completion: nil)
            return
        }
        if subView == nil {
            return
        }
        
        self.fontView?.isHidden = true
        self.boldView?.isHidden = true
        self.alignView?.isHidden = true
        self.orderView?.isHidden = true
        self.colorView?.isHidden = true
        if preSelected == true {
            btn.isSelected = false
            subView?.isHidden = true
            return
        }else{
            btn.isSelected = true
            subView?.isHidden = false
        }
        
    }
    
    func viewController(_ view : UIView) -> UIViewController? {
        let  view  = self
        if let view  = view.superview {
            let nextRespose = view.next
            if (nextRespose?.isKind(of: UIViewController.self))!{
                return nextRespose! as? UIViewController
            }
        }
        return nil
    }
}

class SuView : UIView {
    var toolbar : RichEditorToolbar?
    fileprivate let imageString : [[String]]  = [["small","medium","big"],
                                                 ["bfont","itly","ufont"],
                                                 ["left","mid","right"],
                                                 ["nu","se"],
                                                 ["big","medium","small"],
                                                 ["","","","","","","","","",""]]
    fileprivate let colorArr : [UIColor] = [#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1),#colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1),#colorLiteral(red: 0.9254901961, green: 0.137254902, blue: 0.02745098039, alpha: 1),#colorLiteral(red: 1, green: 0.5411764706, blue: 0, alpha: 1),#colorLiteral(red: 0.2509803922, green: 0.6117647059, blue: 0.7019607843, alpha: 1),#colorLiteral(red: 0, green: 0.6901960784, blue: 0.9411764706, alpha: 1)]
    fileprivate var selectEnum :EditBtnEnum  = .font
    fileprivate var btns : [UIButton] = []
    
    class  func suToolView(_ frame : CGRect , _ btnEnum : EditBtnEnum) -> SuView {
        let view  = SuView.init(frame: frame)
        
        view.setUI(btnEnum)
        
        return view
    }
    
    fileprivate func setUI(_ btnEnum : EditBtnEnum)  {
        
        selectEnum = btnEnum
        var  btnCount = 0
        var imageArr : [String] = []
        
        switch btnEnum {
        case .font:
            btnCount = 2
            imageArr = imageString[0]
            break
        case .bold:
            btnCount = 2
            imageArr = imageString[1]
            break
        case .aligment:
            btnCount = 2
            imageArr = imageString[2]
            break
        case .sequnce:
            btnCount = 1
            imageArr = imageString[3]
            break
        case .link: return;
        case .color: btnCount = 5 ;break
        }
        
        for tag  in 0...btnCount {
            let btn = UIButton.init()
            btn.tag = tag
            
            if btnEnum == .color{
                btn.setImage(UIImage.createThreeColorImag(with: colorArr[tag]) , for: .selected)
                btn.setImage(UIImage.createImag(with: colorArr[tag]) , for: .normal)
            }else{
                btn.setImage(UIImage.init(named: imageArr[tag]), for: .normal)
                btn.setImage(UIImage.init(named: imageArr[tag] + "_select"), for: .selected)
            }
            self.btns.append(btn)
//            btn.snp.removeConstraints()
//            btn.removeFromSuperview()
//            superview?.addSubview(btn)
            addSubview(btn)
            btn.addTarget(self, action: #selector(toobarViewClick(_:)), for: .touchUpInside)
            btn.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview()
                maker.width.equalToSuperview().multipliedBy(1.0/CGFloat(btnCount + 1))
                maker.height.equalTo(44)
                maker.left.equalToSuperview().offset( CGFloat(tag) * Screen_width / CGFloat(btnCount + 1))
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SuView{
    
    @objc fileprivate func toobarViewClick(_ btn : UIButton) {
        
//        if btn.isSelected == true {
//            btn.isSelected = !btn.isSelected
//            return
//        }else{
//            for item  in self.subviews {
//                if let item = item as? UIButton{
//                    item.isSelected = false
//                }
//            }
//            btn.isSelected = true
//        }
        
        switch selectEnum {
        case .font:
            selectFontWithTag(btn.tag)
            break
            
        case .bold:
            selectBoldWithTag(btn.tag)
            break
            
        case .aligment:
            selectAligmentWithTag(btn.tag)
            break
            
        case .sequnce:
            selectSequnceWithTag(btn.tag)
            break
            
        case .link:
            return;
        case .color:
            selectColorWithTag(btn.tag)
            break
        }
    }
    
    fileprivate func selectFontWithTag(_ tag : Int) {
        switch tag {
        case 0: toolbar?.editor?.header(5)
        case 1: toolbar?.editor?.header(3)//setFontSize(14)//header(12)
        case 2: toolbar?.editor?.header(1)//setFontSize(16)//header(12)
        default: break
        }
    }
    fileprivate func selectBoldWithTag(_ tag : Int) {
        switch tag {
        case 0: toolbar?.editor?.bold()
        case 1: toolbar?.editor?.italic()
        case 2: toolbar?.editor?.underline()
        default: break
        }
    }
    fileprivate func selectAligmentWithTag(_ tag : Int) {
        switch tag {
        case 0: toolbar?.editor?.alignLeft()
        case 1: toolbar?.editor?.alignCenter()
        case 2: toolbar?.editor?.alignRight()
        default: break
        }
    }
    
    fileprivate func selectSequnceWithTag(_ tag : Int) {
        switch tag {
        case 0: toolbar?.editor?.orderedList()
        case 1: toolbar?.editor?.unorderedList()
        default: break
        }
    }
    fileprivate func selectColorWithTag(_ tag : Int) {
        toolBarTextColor = colorArr[tag]
        toolbar?.delegate?.richEditorToolbarChangeTextColor?(toolbar!)
    }
    fileprivate func setState(_ item:UIButton, state: Bool) {
        if state {
            item.isSelected = true
        }
        else {
            item.isSelected = false
        }
    }
    func freshState(_ states: [String]) {
        if selectEnum == .bold {
            for item in btns {
                if item.tag == 0{
                    setState(item, state: states.contains("bold"))
                } else if item.tag == 1 {
                    setState(item, state: states.contains("italic"))
                } else if item.tag == 2 {
                    setState(item, state: states.contains("underline"))
                }
            }
        }
        else if selectEnum == .font {
            for item in btns {
                if item.tag == 0{
                    setState(item, state: states.contains("h5"))
                } else if item.tag == 1 {
                    setState(item, state: states.contains("h3"))
                } else if item.tag == 2 {
                    setState(item, state: states.contains("h1"))
                }
            }
        }
        else if selectEnum == .aligment {
            for item in btns {
                if item.tag == 0{
                    setState(item, state: states.contains("justifyleft"))
                } else if item.tag == 1 {
                    setState(item, state: states.contains("justifycenter"))
                } else if item.tag == 2 {
                    setState(item, state: states.contains("justifyright"))
                }
            }
        }
        else if selectEnum == .sequnce {
            for item in btns {
                if item.tag == 0{
                    setState(item, state: states.contains("insertorderedlist"))
                } else if item.tag == 1 {
                    setState(item, state: states.contains("insertunorderedlist"))
                }
            }
        }
        else if selectEnum == .color {
            var clr:String = "#"
            for state in states {
                if state.starts(with: "#") {
//                    let rgb = state.split(separator: ",")
//                    let r = Int(rgb[0].split(separator: "(")[1])
//                    let g = Int(rgb[1])
//                    let b = Int(rgb[2].split(separator: ")")[0])
//                    clr = String.init(format: "#%02lX%02lX%02lX", r!,g!,b!)
                    clr = state
                }
            }
            for item in btns {
                let cc = colorArr[item.tag];
                if cc.hex == clr {
                    item.isSelected = true
                }
                else {
                    item.isSelected = false
                }
            }
        }
    }
}


