//
//  WFSuggestionViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/31.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit
import TZImagePickerController
import SVProgressHUD

class WFSuggestionViewController: BaseViewController,TZImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var contentImageViewHeightCons: NSLayoutConstraint!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    
    ///选择按钮
    var selectedNumber = 0
    
    @IBOutlet weak var collectionView: UICollectionView!

    ///提示label
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var navgationBarCosntant: NSLayoutConstraint!
    
    @IBOutlet weak var upLoadImageView: UIButton!
    @IBAction func upLoadImageViewClick(_ sender: Any) {
        
        let alertController  = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let action1  = UIAlertAction(title: "拍照" , style: .default) { (_) in
            
            print("拍照")
           
            self.uploadImageWithCameare()
            
        }
        
        alertController.addAction(action1)
        
        let action2  = UIAlertAction(title: "从相册选择" , style: .default) { (_) in
            print("从相册选择")
        
                self.uploadImageView()
            
        }
        alertController.addAction(action2)
        
        let action3  = UIAlertAction(title: "取消", style:  .cancel , handler: nil)
        alertController.addAction(action3)
        
        action3.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action2.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        action1.setValue(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), forKey: "titleTextColor")
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    ///从相册选择上传头像
    private func uploadImageView(){
        
        let vc = TZImagePickerController(maxImagesCount: 3 , delegate: self)
        
        vc?.didFinishPickingPhotosHandle = {(_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
            
               for item in phots!{
                  self.base_dataList.append(item)
              }
            
               self.imageCollectionView.reloadData()
            
        }
        
        present(vc!, animated: true, completion: nil)
        
    }
    
    ///通过拍照上传图片
    private func uploadImageWithCameare() {
        
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
        
        self.base_dataList.append(pickedImage)
        self.imageCollectionView.reloadData()
        
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
//    @IBOutlet weak var firstImageView: UIImageView!
//    @IBOutlet weak var secondImageView: UIImageView!
//    @IBOutlet weak var thirdImageView: UIImageView!
//    
//    @IBAction func firstImageClick(_ sender: Any) {
//    }
//    
//    @IBAction func secondImageClick(_ sender: Any) {
//    }
//    
//    @IBAction func thirdImageClick(_ sender: Any) {
//    }
    
    
    
    
    @IBOutlet weak var textField: UITextField!
   
    
    @IBOutlet weak var accomplishBtn: UIButton!
    @IBAction func accomplishBtnClick(_ sender: Any) {
        
         let index = collectionView.indexPathsForSelectedItems

        NetworkerManager.shared.submitSuggest(["suggetType": (index?.count == 0 ? 0 : index?.first?.row) as AnyObject,"link":(textField.text ?? "") as AnyObject,"content":(textView.text ?? "") as AnyObject]) { (isSuccess, returnID) in
            
            if isSuccess == true {
               
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1 , execute: { 
                   SVProgressHUD.showInfo(withStatus: "提交建议成功")
                    
                     self.navigationController?.popViewController(animated: true)
                })
              
               
                
                NetworkerManager.shared.request(method: .Construct, images: self.base_dataList as? [UIImage] ?? [], pictureName: "suggestImg", urlString: "uploadSuggestImg", parameters: ["id":returnID as AnyObject], completion: { (json, isSuccess) in
                    
                                     print(isSuccess)
                })
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationChangeed), name:NSNotification.Name.UITextViewTextDidChange , object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: nil)
    }
    
     @objc private func notificationChangeed()  {
        
        tipLabel.text = textView.hasText ? "" : "请描述您遇到的问题或者建议"
        accomplishBtn.backgroundColor = textView.hasText ? #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1)  : #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        accomplishBtn.isEnabled = textView.hasText ? true : false
        
    }
}


///设置界面
extension WFSuggestionViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    override func setUpUI() {
        super.setUpUI()
        
        navgationBarCosntant.constant = navigation_height
        removeTabelView()
        navItem.title = "意见反馈"
        
        
        setUpCollectionView()
        setUpImageViewCollectionView()
    }
    
    private func setUpCollectionView()  {
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout  = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: (Screen_width - 8) / 4 , height: 88)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView.collectionViewLayout = layout
        
        collectionView.register(UINib.init(nibName: WFSugestionCollectionViewCell().identfy, bundle: nil), forCellWithReuseIdentifier: WFSugestionCollectionViewCell().identfy)
        
    }
    
    private func setUpImageViewCollectionView()  {
        
        let layout  = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: 70 , height: 113)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        
        imageCollectionView.collectionViewLayout = layout
        
        imageCollectionView.register(UINib.init(nibName: WFImageCollectionViewCell().identfy, bundle: nil), forCellWithReuseIdentifier: WFImageCollectionViewCell().identfy)
        
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == imageCollectionView {
          
          let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFImageCollectionViewCell().identfy, for: indexPath) as? WFImageCollectionViewCell
            
            cell?.mainImageView.image = base_dataList[indexPath.row] as? UIImage
            
            cell?.deletImageData = {(cell ) in
            
                let index  = self.imageCollectionView.indexPath(for:cell)
                
                self.base_dataList.remove(at: index?.row ?? 0)
                
                self.imageCollectionView.reloadData()
                
            }
            
            return cell!
        }
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFSugestionCollectionViewCell().identfy, for: indexPath) as? WFSugestionCollectionViewCell
        
        cell?.suggestionBtn.layer.borderColor = #colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1).cgColor
        
        cell?.cellTitle = ["功能建议","内容建议","体验建议","其他建议"][indexPath.row]
        
        if indexPath.row == selectedNumber{
            cell?.cellSelected = true
        }
        
        return cell!
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == imageCollectionView {
            
            return
        }
        
        selectedNumber = indexPath.row
        collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == imageCollectionView {
            
            return base_dataList.count
        }
        
        return 4
    }
    
}











