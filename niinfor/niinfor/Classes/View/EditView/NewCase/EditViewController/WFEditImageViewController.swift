//
//  WFEditViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/22.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import TZImagePickerController

class WFEditImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUPUI()
    }

   fileprivate let buttomView : UIView  = {
        
        let bv = UIView.init()
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
   fileprivate let photoAbumBtn : UIButton = {
        
        let button = UIButton.init()
        button.setTitle("相册", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
    button.addTarget(self, action: #selector(albumBtnclick), for: .touchUpInside)
        return button
    }()
    
   fileprivate let transformBtn : UIButton = {
        //#imageLiteral(resourceName: "旋转")
        let button = UIButton.init()
        button.setImage(#imageLiteral(resourceName: "旋转"), for: .normal)
        button.addTarget(self, action: #selector(rotationBtnclick), for: .touchUpInside)
        return button
    }()
   fileprivate let editBtn : UIButton = {
        
        let button = UIButton.init()
        button.setImage(#imageLiteral(resourceName: "裁剪-1"), for: .normal)
        button.addTarget(self, action: #selector(cropBtnclick), for: .touchUpInside)
        return button
    }()
   fileprivate let deleteBtn : UIButton = {
        
        let button = UIButton.init()
        button.setTitle("删除", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(deleteBtnclick), for: .touchUpInside)
        return button
    }()
    
    let contentImageV : UIImageView = {
        let imageV = UIImageView.init()
        imageV.contentMode = .scaleAspectFit
        imageV.isHidden = true
        return imageV
    }()
    
    let cropView = PECropView.init(frame: CGRect.zero)
    
    var  btnright = UIButton.init()
    var blockCompliction : ((UIImage?)->Void)?
    var image : UIImage?{
        didSet{
            contentImageV.image = image
            cropView.image = image
            contentImageV.sizeToFit()
        }
    }
    
}

extension WFEditImageViewController{
    
    @objc func rightBtnclick(){
        dismiss(animated: true) {
            guard let complict = self.blockCompliction else {
                return
            }
            if  self.cropView.cropRectView.isHidden == false {
                self.cropBtnclick()
            }
            complict(self.image)
        }
    }
    @objc func leftBtnclick(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func albumBtnclick(){
          rechooseImage()
    }
    
    @objc func rotationBtnclick(){
          contentImageV.image = contentImageV.image?.rotate(.right)
          image = contentImageV.image
    }
    
    @objc func cropBtnclick(){
        
        if  cropView.cropRectView.isHidden == false {
            image = cropView.croppedImage
        }
        
        cropView.cropRectView.isHidden = !cropView.cropRectView.isHidden
        cropView.isUserInteractionEnabled = !cropView.isUserInteractionEnabled
    }
    
    @objc func deleteBtnclick(){
        dismiss(animated: true) {
            guard let complict = self.blockCompliction else {
                return
            }
            complict(nil)
        }

    }
}
/// MARK : 选择相册
extension WFEditImageViewController : TZImagePickerControllerDelegate{
    
    
    fileprivate func rechooseImage() {
        
        let vc = TZImagePickerController(maxImagesCount: 1 , delegate: self )
        
        vc?.didFinishPickingPhotosHandle = {[weak self](_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
             self?.image = phots?[0]
            }
     present(vc!, animated: true, completion: nil)

    }
    
}

extension WFEditImageViewController{
    
    fileprivate func setUPUI() {
        view.backgroundColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)
        title = "图片编辑"
        addSubView()
        setConstront()
        setNavigationBtn()
        cropView.cropRectView.isHidden = true
        cropView.isUserInteractionEnabled = false
    }
    
    fileprivate func setNavigationBtn() {
        
        btnright   = UIButton.cz_textButton("完成", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        btnright.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .normal)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        let btnleft  = UIButton.cz_textButton("取消", fontSize: 15, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: UIColor.white)
        btnleft?.addTarget(self, action: #selector(leftBtnclick), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btnleft!)
    }

    
    fileprivate func addSubView() {
        view.addSubview(contentImageV)
        view.addSubview(cropView)
        view.addSubview(buttomView)
        buttomView.addSubview(photoAbumBtn)
        buttomView.addSubview(transformBtn)
        buttomView.addSubview(editBtn)
        buttomView.addSubview(deleteBtn)
    }
    
    fileprivate func setConstront(){
        
        buttomView.snp.makeConstraints { (maker) in
            maker.bottom.left.right.equalToSuperview()
            maker.height.equalTo(50)
        }

        photoAbumBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(1.0/4.0)
            maker.left.equalToSuperview()
        }

        transformBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(1.0/4.0)
            maker.left.equalToSuperview().offset( CGFloat(1) * Screen_width / 4.0)
        }

        editBtn.snp.makeConstraints { (maker) in
            maker.top.height.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(1.0/4.0)
            maker.left.equalToSuperview().offset( CGFloat(2) * Screen_width / 4.0)
        }

        deleteBtn.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview()
            maker.width.equalToSuperview().multipliedBy(1.0/4.0)
            maker.height.equalTo(44)
            maker.left.equalToSuperview().offset( CGFloat(3) * Screen_width / 4.0)
        }
        
        contentImageV.snp.makeConstraints { (maker) in
            maker.right.left.width.equalToSuperview()
            maker.top.equalToSuperview().offset(100)
            maker.bottom.equalToSuperview().offset(-100)
        }
        
//        let size  = contentImageV.image?.size
        
        cropView.snp.makeConstraints { (maker) in
            maker.left.width.equalToSuperview()
            maker.top.equalTo(navigation_height)
            maker.height.equalToSuperview().offset(-navigation_height - 50)
//            maker.size.equalTo(size!)
//            maker.center.equalTo(contentImageV)
        }

    }
}

