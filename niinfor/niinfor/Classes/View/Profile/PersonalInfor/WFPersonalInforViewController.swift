//
//  WFPersonalInforViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import SDWebImage
import TZImagePickerController
import SVProgressHUD

class WFPersonalInforViewController: BaseViewController,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var returnValue = -1
    
    var placeImage : UIImage?
    
    /// 是不是下一步界面
    var isNextStep  = false
    
    ///科室
    var domanString : String  = ""
    //科室id
    var titleID : String = ""
    ///用户信息model
    var personModel = WFUserAccount()
    
    @IBOutlet weak var changeBtn: UIButton!
    
    lazy var educateView : WFEducationView = {
    
        let v = WFEducationView.educateView(UIScreen.main.bounds)
        
        UIApplication.shared.delegate?.window??.addSubview(v)
        
        return v
    }()
    
    lazy var chooseView  : WFChooseDateView = {
        
        let v = WFChooseDateView.chooseView(UIScreen.main.bounds)
        
        UIApplication.shared.delegate?.window??.addSubview(v)
        
        return v
    }()
    
    /// 点击下一步的按钮
    @IBOutlet weak var nextStepBtn: UIButton!
    ///下一步点击
    @IBAction func nextStepClick(_ sender: Any) {
        
        let params  = judgeParams()
        
        if returnValue == 0 {
            return
        }
        
        NetworkerManager.shared.perfectInformation(params as [String : AnyObject] ) { (isSuccess) in
            
            if isSuccess == true {
                NetworkerManager.shared.userCount.realName = self.personModel.realName ?? ""
                NetworkerManager.shared.userCount.avatarAddress = self.personModel.avatarAddress ?? ""
                NetworkerManager.shared.userCount.gender = self.personModel.gender ?? ""
                self.approveId()
            }
        }
    }
    
    func judgeParams() -> [String : String] {
        
        //let array  = [0,1,2,3,4,5,6,7,8,9,10]
        
        //for item  in array {
            
//            let index  = IndexPath(row: item, section: 0)
//            let cell = baseTableView.cellForRow(at: index) as? WFPersonInforCell
//            
//            print(cell.mainLabel.text ?? "")
//            switch item {
//            case 0: break
//            case 1: self.personModel.realName = cell?.mainLabel.text ?? ""
//            case 2:
//            
//            if  cell?.mainLabel.text ?? "" == "" { break}
//            let string  = (cell?.mainLabel.text ?? "") == "男" ? "M" : "F"
//            self.personModel.gender = string
//                
//            case 3: self.personModel.mobile = cell?.mainLabel.text ?? ""
//            case 4: self.personModel.education = cell?.mainLabel.text ?? ""
//            case 5: self.personModel.email = cell?.mainLabel.text ?? ""
//            case 6: self.personModel.birthDate = cell?.mainLabel.text ?? ""
//            case 7: self.personModel.company = cell?.mainLabel.text ?? ""
//            case 8: self.personModel.department = cell?.mainLabel.text ?? ""
//            case 9: self.personModel.title = cell?.mainLabel.text ?? ""
////        case 10: self.personModel.speciality = cell?.mainLabel.text ?? ""
//                
//                
//            default:break
//            }
//            
//            if item == 0 || item == 5 || item == 6 ||  item == 10{
//                continue
//            }
//            
//            if cell?.mainLabel.text == "" || cell?.mainLabel.text == "请选择" {
//                SVProgressHUD.showInfo(withStatus: "请完善信息")
//                returnValue = 0
//                return [:]
//            }
//        }
    
    if  self.personModel.realName == "" ||
        self.personModel.gender == "" ||
        self.personModel.mobile == "" ||
        self.personModel.education == "" ||
        self.personModel.company  == "" ||
        self.personModel.department == "" ||
        self.personModel.title == ""{
            
         SVProgressHUD.showInfo(withStatus: "请完善信息")
         returnValue = 0
         return [:]
    }
    
        returnValue = -1
        
        var string = ""
        if (personModel.gender ?? "") == "男" || (personModel.gender ?? "") == "M"{
            string = "M"
        }else{
            string = "F"
        }
        
      let params  = ["userId" : NetworkerManager.shared.userCount.id ?? "",
                       "imgUrl":personModel.avatarAddress ?? "",
                       "gender": string ,
                       "realname":personModel.realName ?? "",
                       "education":personModel.education ?? "",
                       "email":personModel.email ?? "",
                       "birthDate":personModel.birthDate ?? "",
                       "company":personModel.company ?? "",
                       "department":personModel.department ?? "",
                       "title":personModel.title ?? "",
                       "speciality":personModel.speciality ?? ""
        ]

        return params
    }
    
    ///修改信息按钮
    @IBOutlet weak var changeBtnView: UIView!
    
    /// 修改信息点击
    @IBAction func changeBtnClick(_ sender: Any) {
        
        
        
        self.baseTableView.reloadData()
        
        
        
        
        if  changeBtn.isSelected == true {
            
            let params  = judgeParams()
            
            if returnValue == 0 {
                return
            }

            
            NetworkerManager.shared.updateUserInfo(params as [String : AnyObject] ) { (isSuccess,json) in
                
                if isSuccess == true {
                
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                    
                self.changeBtn.isSelected = !self.changeBtn.isSelected
                    
                self.personModel.yy_modelSet(with: json as? [AnyHashable : Any] ??  [:]  )
                
                
                NetworkerManager.shared.userCount.realName = self.personModel.realName ?? ""
                NetworkerManager.shared.userCount.avatarAddress = self.personModel.avatarAddress ?? ""
                NetworkerManager.shared.userCount.gender = self.personModel.gender ?? ""
                
                ///这个是提交修改的
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_login_success), object: nil)
                 //   self.navigationController.popToRootViewController(animated: true)
                }
            }
        }else{
            changeBtn.isSelected = !changeBtn.isSelected
            
            }

        }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

///设置界面
extension WFPersonalInforViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        navItem.title = isNextStep ? "完善信息" : "个人信息"
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePersonInformation), name: NSNotification.Name(rawValue: notifi_person_change_infomaton), object: nil)
        
        nextStepBtn.isHidden = !isNextStep
        changeBtnView.isHidden = !nextStepBtn.isHidden
        
        setupTableView()
        
        isNextStep ? () : setRightItem()
        
//        let v  = UIDatePicker(frame: CGRect(x: 0, y: 400, width: Screen_width, height: 300))
//        v.datePickerMode = .date
//        view.addSubview(v)
//        
//        let v2 = v.subviews[0].subviews[1] as UIView
//        v2.backgroundColor = UIColor.red
//        
//        let v3 = v.subviews[0].subviews[2] as UIView
//        v3.backgroundColor = UIColor.red
//        
//        
//        if let pick  = v.value(forKey: "pickerView") as? UIDatePicker {
//        print(pick)
//        }

    }
    
    func changePersonInformation(_ notifi : Notification) {
        
        guard  let selectNumber = notifi.userInfo as? [String : String] else {
           return
        }
        
        switch selectNumber["tag"] ?? "" {
            
        case "1" : self.personModel.realName = selectNumber["title"]
        case "3" : self.personModel.mobile = selectNumber["title"]
        case "5" : self.personModel.email = selectNumber["title"]
            
        default: break
        }

    }
    
    
    ///设置右边的按钮
    private func setRightItem() {
        
        let btn  = UIButton(type: .custom)
        
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        
        
        btn.addTarget(self, action: #selector(approveId), for: .touchUpInside)
        
        btn.setAttributedTitle(NSMutableAttributedString(
            string: "身份认证",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 15) ??
                UIFont.systemFont(ofSize: 15),NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                     for: .normal)

        navItem.rightBarButtonItem = UIBarButtonItem(customView: btn)
    }
    
    /// 设置tableView
    func setupTableView () {
       
      ///将视图移到底层
      view.insertSubview(baseTableView, belowSubview: changeBtnView)
      baseTableView.tableFooterView = UIView()
      baseTableView.bounces = false
      baseTableView.tableFooterView?.backgroundColor = UIColor.clear
      baseTableView.showsVerticalScrollIndicator = false
        
      let distance : CGFloat  = isNextStep ? 82 : 65
        
        
      baseTableView.frame = CGRect(x: 0,
                                                            y: navigation_height,
                                                            width: Screen_width,
                                                            height: Screen_height - distance - navigation_height)
        
     regestNibCellString(WFPersonInforCell().identfy)
    
    }
}


// MARK: - 代理事件
extension WFPersonalInforViewController:UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return changeBtn.isSelected
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: WFPersonInforCell().identfy, for: indexPath) as! WFPersonInforCell
        
        cell.model = nil
        
        cell.contentTF.isEnabled  = false
        
        cell.contentTF.tag = indexPath.row
        
        switch indexPath.row {
            
        case 0://头像
            cell.avatarImageView.isHidden = false
            cell.headTitle.text = "头像"
            
            cell.avatarImageView.sd_setImage(with:URL(string: personModel.avatarAddressString) , placeholderImage: personModel.gender == "F" ? #imageLiteral(resourceName: "profile_img_portrait_woman") : #imageLiteral(resourceName: "profile_img_portrait_man")  )
            cell.mainLabel.text = personModel.avatarAddress ?? "" == "" ? "未上传" : "已上传"
            
        case 1://姓名
            cell.starImageView.isHidden = false
            cell.verifyLabel.isHidden = false //还有一个右边的看数据隐藏显示
            
            switch NetworkerManager.shared.userCount.isAuth{
            case 0:cell.verifyLabel.text = "未认证"
            case 1:cell.verifyLabel.text = "已认证"
            case 2:cell.verifyLabel.text = "待认证"
            case 3:cell.verifyLabel.text = "认证未过"
            default:break
            }
            
            cell.rightImageView.isHidden = cell.verifyLabel.text == "已认证"
            
            ///在完善信息界面隐藏
            cell.verifyLabel.isHidden = isNextStep
            cell.contentTF.isEnabled  = isNextStep == true ? true : changeBtn.isSelected
            cell.headTitle.text = "姓名"
            cell.mainLabel.text = personModel.realName ?? ""
            
            
        case 2://性别
            cell.starImageView.isHidden = false
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "性别"
            cell.mainLabel.text = personModel.genderString
            
        case 3://手机
            cell.starImageView.isHidden = false
            cell.contentTF.isEnabled  = false //changeBtn.isSelected
            cell.headTitle.text = "手机"
            cell.mainLabel.text = personModel.mobile ?? ""
            
        case 4://学历
            cell.starImageView.isHidden = false
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "学历"
            cell.mainLabel.text = (personModel.education ?? "") == "" ? "请选择" : personModel.education
            
        case 5://邮箱
            cell.contentTF.isEnabled  = isNextStep == true ? true : changeBtn.isSelected
            cell.headTitle.text = "邮箱"
            cell.mainLabel.text = ( personModel.email ?? "" ) == "" ? "请输入电子邮箱" :  ( personModel.email ?? "" )
            
        case 6://生日
            cell.rightImageView.isHidden = false
            cell.buttomLabel.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            cell.headTitle.text = "生日"
            cell.mainLabel.text = (personModel.birthDate ?? "") == "" ? "请选择" : personModel.birthDate
            //personModel.birthDate ?? "请选择"
            
        case 7://单位
            cell.starImageView.isHidden = false
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "单位"
            cell.mainLabel.text =  (personModel.company ?? "") == "" ? "请选择" : personModel.company//personModel.hospital ?? "请选择"
            
        case 8://科室
            cell.starImageView.isHidden = false
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "科室"
            domanString = cell.mainLabel.text ?? ""
            cell.mainLabel.text =  (personModel.department ?? "") == "" ? "请选择" : personModel.department//personModel.department ?? "请选择"
            
        case 9://职称
            cell.starImageView.isHidden = false
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "职称"
            cell.mainLabel.text =  (personModel.title ?? "") == "" ? "请选择" : personModel.title//personModel.title ?? "请选择"
            
        case 10://亚专业
            cell.rightImageView.isHidden = false
            cell.headTitle.text = "亚专业"
            cell.mainLabel.text =  (personModel.speciality ?? "") == "" ? "请选择" : personModel.speciality//personModel.speciality ?? "请选择"
            
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if changeBtn.isSelected ==  false && isNextStep == false {return}
        
        guard let cell  = tableView.cellForRow(at: indexPath) as? WFPersonInforCell else{
            return
        }
        
        switch  cell.headTitle.text ?? ""{
            case "头像":  avatarImageClick("头像", cell: cell)
//            case "姓名":  approveId()
            case "性别":  avatarImageClick("", cell: cell)
            case "手机":break
            case "学历":  setUpEducateView(cell)
            case "邮箱":break
            case "生日":  timeView(cell)
            case "单位":  domanView(cell,isdoman: true)
            case "科室":  domanView(cell,isdoman: false)
            case "职称":  rankView(cell)
            case "亚专业": subSpecial(cell)
            
           default: break
            
        }
        
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 6 {  return 58 }
        return 48
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }

// MARK: - 在选中各个cell的事件
    /// 头像点击事件
    private func avatarImageClick(_ title : String ,cell : WFPersonInforCell ){
        
        let alertController  = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1  = UIAlertAction(title: title == "头像" ? "拍照" : "男", style: .default) { (_) in
            
            print("拍照")
            if title == ""{ cell.mainLabel.text = "男" ; self.personModel.gender = "男" }
            else{
                self.uploadImageWithCameare(cell)
            }
        }
        
        alertController.addAction(action1)
        
        let action2  = UIAlertAction(title: title == "头像" ? "从相册选择" : "女", style: .default) { (_) in
            print("从相册选择")
            
            if title == ""{ cell.mainLabel.text = "女" ; self.personModel.gender = "女"}else{
                
              self.uploadImageView(cell)
            }
        }
        alertController.addAction(action2)

        let action3  = UIAlertAction(title: "取消", style: title == "头像" ? .cancel : .default, handler: nil)
        alertController.addAction(action3)

        action3.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action2.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action1.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
    
        present(alertController, animated: true, completion: nil)
        
    }
    
    ///从相册选择上传头像
    private func uploadImageView(_ cell : WFPersonInforCell){
        
        let vc = TZImagePickerController(maxImagesCount: 1 , delegate: self)
        
        vc?.didFinishPickingPhotosHandle = {(_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
            
            NetworkerManager.shared.uploadAvatar(phots!, complict: { (isSuccess, json) in
                
                if isSuccess == true {
                
                    cell.avatarImageView.image = phots?[0]
                    self.placeImage = phots?[0]
                    self.personModel.avatarAddress = json["avatarAddress"] as? String ?? ""
                    cell.avatarImageView.sd_setImage(with: URL.init(string: json["avatarAddress"]! as? String ?? ""), placeholderImage: phots?[0])                }
            })
        }
        
        present(vc!, animated: true, completion: nil)
        
    }
    
    ///通过拍照上传图片
    private func uploadImageWithCameare(_ cell : WFPersonInforCell) {
        
        let vc  = UIImagePickerController()
        vc.sourceType = .camera
        vc.cameraCaptureMode = .photo
        
        vc.allowsEditing = true
        vc.delegate = self
        
        present(vc, animated: true , completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //储存照片到本地相册
        UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        
        NetworkerManager.shared.uploadAvatar([pickedImage], complict: { (isSuccess, json) in
            
            if isSuccess == true {
                
//                cell.avatarImageView.image = puts?[0]
                self.personModel.avatarAddress = json["avatarAddress"] as? String ?? ""
                self.placeImage = pickedImage
                UIImageView().sd_setImage(with:URL.init(string: json["avatarAddress"]! as? String ?? ""))

//                cell.avatarImageView.image = phots?[0]
//                self.personModel.avatarAddress = json["avatarAddress"]
                //重新加载一次数据
                self.loadData()
            }
        })
        picker.dismiss(animated: true, completion: nil)
    }

    ///学历视图
    private func setUpEducateView(_ cell : WFPersonInforCell) {
        
        educateView.isHidden = false
        educateView.ensureEducation = {(education) in
        
        cell.mainLabel.text = education
        self.personModel.education = education
    }
    }
    
    /// 生日视图
   private func timeView (_ cell : WFPersonInforCell){
        
        chooseView.isHidden = false
        chooseView.currentTimer = {(title)->() in
            cell.mainLabel.text = title
            self.personModel.birthDate = title
        }
    }
    
    ///单位选择
   private func domanView(_ cell : WFPersonInforCell , isdoman : Bool) {
        let vc = WFMonadViewController()
        vc.isMonad = isdoman
        vc.selctMonad = {(monad,titleId)->() in
          cell.mainLabel.text = monad
          self.domanString = isdoman ? self.domanString : monad
          self.titleID = isdoman ? self.titleID : titleId
            isdoman ? (self.personModel.company = monad) : (self.personModel.department = monad)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///职称选择
   private func rankView (_ cell : WFPersonInforCell) {
    
        let vc  = WFRankViewController()
    
        vc.complict = {(string) in
            cell.mainLabel.text = string
            self.personModel.title  = string
        }
    
        navigationController?.pushViewController(vc, animated: true)
    }
    
    ///亚专业选择
    private func subSpecial(_ cell : WFPersonInforCell) {
    
//    if domanString == "" {
//        let alertController  = UIAlertController(title: "提示",
//                                                                         message: "请先选择科室再选择亚专业",
//                                                                         preferredStyle: .alert)
//        
//        let action  = UIAlertAction(title: "确定", style: .cancel, handler: nil)
//        
//        alertController.addAction(action)
//        
//        present(alertController, animated: true, completion: nil)
//        
//        return
//    }
    
    let vc  = WFSubspecialController()
    
    vc.titleID = self.titleID
    vc.complict = {(string )in
       cell.mainLabel.text = string
        self.personModel.speciality = string
    }
    
    navigationController?.pushViewController(vc, animated: true)
    }
    
    ///身份认证
     func approveId() {
        
        let vc = WFApproveidController()
             vc.empcard = personModel.empcard
             vc.isRegest = self.isNextStep
        vc.upLoadImageSuccessComletion = {
            self.baseTableView.reloadRows(at: [IndexPath.init(row: 1, section: 0)], with:.none)
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension WFPersonalInforViewController{
    
    ///加载网络数据
    override func loadData() {
        
        NetworkerManager.shared.getUser() { (isSuccess, userAccount) in
            
            if isSuccess == true {
                self.personModel = userAccount
                self.baseTableView.reloadData()
            }
        }
    }
}
