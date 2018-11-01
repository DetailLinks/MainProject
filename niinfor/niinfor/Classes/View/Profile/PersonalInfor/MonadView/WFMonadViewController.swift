//
//  WFMonadViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/9/1.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SVProgressHUD

class WFMonadViewController: BaseViewController ,UITextFieldDelegate{
    
    @IBOutlet weak var ensureView: UIView!
    
    var isMonad  = true
    
    var dataList  = [WFEducationModel]()
    
    /// 回调返回当前的时间
    var selctMonad : ((_ monad:String, _ titleID : String)->())?

    @IBOutlet weak var navigationBarConstant: NSLayoutConstraint!
    @IBAction func searchBtnClick(_ sender: Any) {
        
        if textField.text == ""{
           textField.text = textField.placeholder
           searchBtn.isSelected = true
        }
        
        loadNetDate()
    }
    
    //确认按钮点击
    @IBAction func ensureBtnClick(_ sender: UIButton) {
    
        if textField.text == ""{
           
            SVProgressHUD.showInfo(withStatus: "请输入完整医院名称")
            return
        }

        if selctMonad != nil {
            
            let educatModel  =  WFEducationModel()
            
            educatModel.name = textField.text ?? ""
            
            selctMonad!(educatModel.name ?? "",educatModel.id ?? "")
            
            navigationController?.popViewController(animated: true)
        }

        
    }
    
    @IBOutlet weak var searchBtn: UIButton!
    
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeBtnStatus), name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    func changeBtnStatus() {
    
    searchBtn.isSelected = !(textField.text ?? ""  == "")
    searchBtn.isEnabled = !(textField.text ?? ""  == "")
    
    }

   deinit {
    NotificationCenter.default.removeObserver(self, name:  NSNotification.Name.UITextFieldTextDidChange, object: nil)
}


}

///设置界面
extension WFMonadViewController{
    
    override func setUpUI() {
        super.setUpUI()
    
        navigationBarConstant.constant = navigation_height
        view.bringSubview(toFront: ensureView)
        
        ensureView.isHidden = true
        
        navItem.title = isMonad ? "单位选择" : "科室选择"
        
        let leftImageView = UIImageView(frame: CGRect(x: 10,
                                                      y: 0,
                                                      width: 15,
                                                      height: 15))
        
        leftImageView.image = UIImage(named: "icon_searchhospital")
        
        
        let leV = UIView(frame:CGRect(x: 10,
            y: 0,
            width: 25,
            height: 15))
        
        leV.addSubview(leftImageView)
        textField.leftView = leV
        
        textField.leftViewMode = .always
        textField.delegate = self
  
        setUpTableView()
        
        loadNetDate()
        
    }
    //设置tableView
    private func setUpTableView() {
        
        regestNibCellString(WFMonadTableViewCell().identfy)
        
        let distance : CGFloat  = isMonad ? navigation_height + 50 : navigation_height
        
        baseTableView.bounces = false
        baseTableView.frame = CGRect(x: 0,
                                                              y:  distance,
                                                              width: Screen_width,
                                                              height: Screen_height - distance )
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if selctMonad != nil {
            
            let educatModel  = base_dataList[indexPath.row] as? WFEducationModel
            
            
            selctMonad!(educatModel?.name ?? "",educatModel?.id ?? "")
        }
        
        navigationController?.popViewController(animated: true)
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}



extension WFMonadViewController{
    
    func loadNetDate() {
        isMonad ? loadModaData(textField.text ?? "") : loadNoModaData()
    }
    
    ///加载单位数据
    private  func loadModaData(_ string : String) {
        
        if string == "" {return}
        
        
        NetworkerManager.shared.searchHospital(["keyword":string]) { (isSuccess, json) in
           
            if isSuccess == true{
                
                self.base_dataList = json
                self.ensureView.isHidden = self.base_dataList.count > 0
                self.baseTableView.reloadData()
            }

        }
    }
    
    ///加载科室数据
    private  func loadNoModaData() {
        
        NetworkerManager.shared.getHospdepts { (isSuccess, json) in
            
            if isSuccess == true{
                self.base_dataList = json
                self.baseTableView.reloadData()
            }
            
        }
        
    }
    
    
}













