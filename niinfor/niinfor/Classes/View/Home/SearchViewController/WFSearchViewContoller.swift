//
//  WFSearchViewContoller.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/10/11.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFSearchViewContoller: BaseViewController {

    var lastSearchString = ""
    
    @IBOutlet weak var navigaitonBarConstant: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

///设置界面
extension WFSearchViewContoller : UISearchBarDelegate {
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "资讯搜索"

        navigaitonBarConstant.constant = navigation_height
        baseTableView.frame = CGRect(x: 0, y: 108 + 12, width: Screen_width, height: Screen_height - 108 - 12)
        
        regestNibCellString(WFInforTableViewCell().identfy)
        setSearchBar()
        
        searchBar.delegate  = self
        searchBar.becomeFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.page = 1
        self.base_dataList.removeAll()
        loadData()
        searchBar.resignFirstResponder()
    }
    
        /// 设置searchBar属性
        private func setSearchBar() {
        
         searchBar.backgroundImage = UIImage()
        
        ///设置searchBar为圆角
        if  let tf : UITextField = searchBar.value(forKey: "searchField") as? UITextField{
            
            tf.backgroundColor = UIColor.white
            tf.layer.cornerRadius = 14
            tf.layer.masksToBounds = true
            
        }
    }

}

///数据源方法
extension WFSearchViewContoller{
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc  = WFVideoDetailController()
        
        vc.htmlString = Photo_Path + (base_dataList[indexPath.row].url ?? "")
        
        navigationController?.pushViewController(vc , animated: true )
    }
    
}

///加载数据
extension WFSearchViewContoller
{
    
    override func loadData() {
        
        if searchBar.text == "" { return }
        
        if searchBar.text != lastSearchString{
            page = 1
            lastSearchString = searchBar.text ?? ""
        }
        
        NetworkerManager.shared.searchInfo(searchBar.text ?? "", page) { (isSuccess, json) in
            
            if isSuccess == true {
                self.base_dataList = self.base_dataList + json
                
                if self.page == 1 && json.count == 0{
                    SVProgressHUD.showInfo(withStatus: "暂无搜索的信息")
                }
            }
        }
    }
}

