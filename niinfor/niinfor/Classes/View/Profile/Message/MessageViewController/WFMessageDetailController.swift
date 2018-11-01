//
//  WFMessageDetailController.swift
//  神经介入资讯
//
//  Created by 王孝飞 on 2017/10/25.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import YYText

class WFMessageDetailController: BaseViewController {

    var contentString  = ""
    
    lazy var  textLabel  = YYLabel()
    
    var titleLabelHeight : CGFloat {
        return (contentString as NSString).boundingRect(with:CGSize(width: Screen_width - 20, height: CGFloat(MAXFLOAT))
            , options: .usesLineFragmentOrigin,
              attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 16)], context: nil).size.height + 50

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "信息详情"
        
        contentString =  contentString.replacingOccurrences(of: "\n", with: "")
        
        textLabel.frame = CGRect(x: 10, y: 84, width: Screen_width - 20, height:  titleLabelHeight )
            
        view.addSubview(textLabel)
        
        textLabel.numberOfLines = 0
        textLabel.font = UIFont.systemFont(ofSize: 16)
        
        textLabel.textAlignment = .natural
        
        let textF = NSMutableAttributedString(string: contentString)
        
        textF.yy_font = UIFont.systemFont(ofSize: 16)
        
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.phoneNumber.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector.matches(in: contentString,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, contentString.characters.count))
            // 取出结果
            for match  in res {
                
                textF.yy_setTextHighlight(match.range, color: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), backgroundColor: UIColor.white, userInfo: [:], tapAction: { (kView, Astring, range, Cframe ) in
                    
                    let string =  (self.contentString as NSString).substring(with: match.range)
                    
                    //                        let alert  = UIAlertController(title: "提示", message: "确定要拨打电话", preferredStyle: .alert)
                    //
                    //                        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: nil))
                    //
                    //                        UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
                    
                    let url  = URL(string:"tel://" + string)
                    
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
                    } else {
                        //UIApplication.shared.canOpenURL(url!)
                        UIApplication.shared.openURL(url!)
                    }
                    
                }, longPressAction: nil)
            }
        }
        catch {
            print(error)
        }

        
        // 创建一个正则表达式对象
        do {
            let dataDetector = try NSDataDetector(types:
                NSTextCheckingTypes(NSTextCheckingResult.CheckingType.link.rawValue))
            // 匹配字符串，返回结果集
            let res = dataDetector.matches(in: contentString,
                                           options: NSRegularExpression.MatchingOptions(rawValue: 0),
                                           range: NSMakeRange(0, contentString.characters.count))
            // 取出结果
            for match  in res {
            
                textF.yy_setTextHighlight(match.range, color: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), backgroundColor: UIColor.white, userInfo: [:], tapAction: { (kView, Astring, range, Cframe ) in
                    
                let vc = WFVideoDetailController()
                vc.htmlString = (self.contentString as NSString).substring(with: match.range)
                 self.navigationController?.pushViewController(vc, animated: false)
                }, longPressAction: nil)
            }
        }
        catch {
            print(error)
        }
        
             textLabel.attributedText = textF
    }
}

///设置界面
extension WFMessageDetailController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        //        title = ""
    }
}

