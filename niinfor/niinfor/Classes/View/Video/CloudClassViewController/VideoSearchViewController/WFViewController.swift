//
//  WFViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/10/17.
//  Copyright © 2018 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD
class WFViewController: BaseViewController {
    
    @IBOutlet weak var searchView: UIView!
    var lastSearchString = ""
    fileprivate let no_contet_imageV = UIImageView()
    
    @IBOutlet weak var navBarCons: NSLayoutConstraint!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var navbarConstant: NSLayoutConstraint!
}

///设置界面
extension WFViewController : UISearchBarDelegate {
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = "课程搜索"
        
        navbarConstant.constant = 0
        navBarCons.constant = navigation_height
        baseTableView.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.top.equalTo(searchView.snp.bottom)
        }
        
        baseTableView.addSubview(no_contet_imageV)
        no_contet_imageV.image = #imageLiteral(resourceName: "no_content")
        no_contet_imageV.isHidden = true
        no_contet_imageV.contentMode = .scaleAspectFit
        no_contet_imageV.snp.makeConstraints { (maker ) in
            maker.center.equalToSuperview()
        }
        
        regestNibCellString(WFInforTableViewCell().identfy)
        setSearchBar()
        
        searchBar.delegate  = self
        searchBar.becomeFirstResponder()
        baseTableView.register(WFRecommandTableViewCell.self, forCellReuseIdentifier: WFRecommandTableViewCell().identfy)
        
//        baseTableView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(tapGestrue)))
    }
    
    @objc func tapGestrue(){
        searchBar.resignFirstResponder()
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
extension WFViewController{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         searchBar.resignFirstResponder()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WFRecommandTableViewCell().identfy, for: indexPath) as? WFRecommandTableViewCell
        if let model = base_dataList[indexPath.row] as? WFFreeClassModel {
            cell?.configModel(model)
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let  vc  = WFNewVideoViewController()
        let model  = base_dataList[indexPath.row] as! WFFreeClassModel
        vc.classId = "\(model.id)"
        vc.classImage = model.image
        vc.className = model.name
        switch model.condition {
        case "N" :
            self.present(vc, animated: true, completion: nil)
            
        case "L" :
            if NetworkerManager.shared.userCount.isLogon {
                self.present(vc, animated: true, completion: nil)
            }else{
                navigationController?.pushViewController(WFLoginViewController(), animated: true)
            }
        case "V" :
            if NetworkerManager.shared.userCount.isAuth == 1 || NetworkerManager.shared.userCount.isAuth == 2 {
                self.present(vc, animated: true, completion: nil)
            }else{
                navigationController?.pushViewController(WFApproveidController(), animated: true)
            }
        case "" : break
        default : break
        }
    }
    
}

///加载数据
extension WFViewController
{
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        searchBar.resignFirstResponder()
//    }
    
    override func loadData() {
        
        if searchBar.text == "" { return }
        
        if searchBar.text != lastSearchString{
            page = 1
            lastSearchString = searchBar.text ?? ""
        }
        
        NetworkerManager.shared.getCoursePageByName(searchBar.text ?? "", "\(page)") { (isSuccess, json) in
            
            if isSuccess == true {
                self.base_dataList = self.base_dataList + json
                self.no_contet_imageV.isHidden = !self.base_dataList.isEmpty
                if self.page == 1 && json.count == 0{
//                    SVProgressHUD.showInfo(withStatus: "暂无搜索的信息")
                }
            }
        }
    }
}
