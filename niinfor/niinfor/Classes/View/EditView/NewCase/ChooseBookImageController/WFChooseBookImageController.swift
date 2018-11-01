//
//  WFChooseBookImageController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/4.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import TZImagePickerController
import SVProgressHUD


class WFChooseBookImageController: BaseViewController {
 
   fileprivate var contentView : UIView = {
        let contentV = UIView.init()
        return contentV
    }()
    
   fileprivate var contentImageView : UIImageView = {
        let contentV = UIImageView.init()
        contentV.isHidden = true
        return contentV
    }()
    
   fileprivate var contentClipImageView : UIImageView = {
        let contentV = UIImageView.init(image: #imageLiteral(resourceName: "裁剪框 copy"))
        contentV.isUserInteractionEnabled = true
        return contentV
    }()
    
   fileprivate var collectionView : UICollectionView = {
    let layout = UICollectionViewFlowLayout.init()
    
    let itemWidth = (Screen_width - 32 - 18)/4.0
    layout.itemSize = CGSize.init(width: itemWidth , height: itemWidth )
    
    layout.minimumLineSpacing = transWidth(10)
    layout.minimumInteritemSpacing = transWidth(6)
    
    let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
    collectionView.backgroundColor = UIColor.white
    
    collectionView.register(WFBookFileCell.self , forCellWithReuseIdentifier: WFBookFileCell().identfy)

    
    collectionView.contentInset = UIEdgeInsetsMake(0, 16, 10, 16)
    
    return collectionView
    }()
    
    var dataSource : [ChooseImageModel] = [ChooseImageModel.init(#imageLiteral(resourceName: "Rectangle 24"), false),
                                                       ]

    fileprivate let cropView = PECropView.init(frame: CGRect.zero)
    
    var image : UIImage = UIImage(){
        didSet{
            cropView.image = image
            contentImageView.image = image
        }
    }
    
    var complict : ((ChooseImageModel)->())?
    
    var selectIndex : IndexPath = IndexPath(item: 1, section: 0)
    
    
    fileprivate var leftView : UIView = {
        let contentV = UIView.init()
        contentV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentV.alpha = 0.6
        return contentV
    }()

    fileprivate var topView : UIView = {
        let contentV = UIView.init()
        contentV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentV.alpha = 0.6
        return contentV
    }()

    fileprivate var rightView : UIView = {
        let contentV = UIView.init()
        contentV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentV.alpha = 0.6
        return contentV
    }()

    fileprivate var bottomView : UIView = {
        let contentV = UIView.init()
        contentV.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        contentV.alpha = 0.6
        return contentV
    }()

    fileprivate var btnright = UIButton.init()
    
}

extension WFChooseBookImageController{

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFBookFileCell().identfy, for: indexPath) as? WFBookFileCell
        cell?.model = dataSource[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
           chooseImageView()
        }else{
           for  item in dataSource{
                item.isSelect = false
            }
           dataSource[indexPath.row].isSelect = true
            image = dataSource[indexPath.row].image!
           collectionView.reloadData()
        }
    }
    
}

extension WFChooseBookImageController : TZImagePickerControllerDelegate {
    
    ///从相册选择上传头像
    fileprivate func chooseImageView(){
        
        let vc = TZImagePickerController(maxImagesCount: 1 , delegate: self )
        
        vc?.allowPickingVideo = false
        
        vc?.didFinishPickingPhotosHandle = {[weak self](_ phots : [UIImage]?, _ array : [Any]?,  isSecled :Bool)in
            
            if phots?.count == 0{return}
            
            self?.image = (phots?[0])!
            
            for item in (self?.dataSource)! {
                item.isSelect = false
            }
            
            let model  = ChooseImageModel.init((phots?[0])!, true)
            
            if self?.dataSource.count == 1 {
               self?.dataSource.insert(model, at: 1)
            }else{
               
                if self?.dataSource[1].indexRow == -1 {
                   self?.dataSource[1] = model
                }else{
                  self?.dataSource.insert(model, at: 1)
                }
            }
            
            self?.collectionView.reloadData()
            }
        
        present(vc!, animated: true, completion: nil)
        
    }
}

extension WFChooseBookImageController{
    func clipImageView() ->UIImage {
        
        let rect = CGRect.init(x: transWidth(50), y: transHeight(40), width: cropView.bounds.width - transWidth(54) * 2, height: cropView.bounds.height - transHeight(40) * 2)
        print(rect)
        print("rect")
        let images = UIImage.init(view: cropView, frame:rect )
        
        return images!
    }
}

extension WFChooseBookImageController{
    
    @objc func rightBtnclick(){
        
           if cropView.image == nil  {
              SVProgressHUD.showError(withStatus: "请选择封面图片再点击完成按钮")
              return
           }
        
            guard let complict = self.complict else {
                return
            }
        
           for item  in dataSource {
            
            if item.isSelect == true {
               item.image = clipImageView()
               complict(item)
               self.dismiss(animated: true, completion: nil)
            }
           }
    }
    
    @objc func leftBtnclick(){
        dismiss(animated: true, completion: nil)
    }

}


///setUI
extension WFChooseBookImageController : UICollectionViewDelegate , UICollectionViewDataSource {
    override func setUpUI() {
        super.setUpUI()
        title = "更换封面"
        
        removeTabelView()
        addSubView()
        setConstant()
        setNavigationBtn()
        
        view.backgroundColor = UIColor.white
        collectionView.delegate = self
        collectionView.dataSource = self
        
        cropView.cropRectView.isHidden = true
        cropView.topOverlayView.isHidden = true
        cropView.leftOverlayView.isHidden = true
        cropView.rightOverlayView.isHidden = true
        cropView.bottomOverlayView.isHidden = true
        cropView.clipsToBounds = true

}
    
    fileprivate func setNavigationBtn() {
        
        btnright   = UIButton.cz_textButton("完成", fontSize: 15, normalColor: #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), highlightedColor: UIColor.white)
        //btnright.setTitleColor(#colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1), for: .selected)
        btnright.addTarget(self, action: #selector(rightBtnclick), for: .touchUpInside)
        self.navItem.rightBarButtonItem = UIBarButtonItem(customView: btnright)
        
        let btnleft  = UIButton.cz_textButton("取消", fontSize: 15, normalColor: #colorLiteral(red: 0.2, green: 0.2, blue: 0.2, alpha: 1), highlightedColor: UIColor.white)
        btnleft?.addTarget(self, action: #selector(leftBtnclick), for: .touchUpInside)
        navItem.leftBarButtonItem = UIBarButtonItem(customView: btnleft!)

    }

    
    fileprivate func addSubView(){
        view.addSubview(contentView)
        view.addSubview(collectionView)
        contentView.addSubview(contentImageView)
        contentView.addSubview(contentClipImageView)
        contentView.addSubview(cropView)
        cropView.addSubview(leftView)
        cropView.addSubview(topView)
        cropView.addSubview(rightView)
        cropView.addSubview(bottomView)
        cropView.addSubview(contentClipImageView)
    }
    
    fileprivate func setConstant(){
        contentView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalToSuperview()
            maker.height.equalTo(Screen_width / 750.0 * 380.0)
            maker.top.equalToSuperview().offset(navigation_height)
        }
        contentImageView.snp.makeConstraints { (maker) in
            maker.left.top.right.width.height.equalTo(contentView)
        }
        cropView.snp.makeConstraints { (maker) in
            maker.left.top.right.width.height.equalTo(contentView)
        }
        contentClipImageView.snp.makeConstraints { (maker) in
            maker.edges.equalToSuperview().inset(UIEdgeInsetsMake(16, 20, 16, 20))
        }
        leftView.snp.makeConstraints { (maker) in
            maker.left.top.height.equalTo(contentView)
            maker.width.equalTo(22)
        }
        topView.snp.makeConstraints { (maker) in
            maker.top.equalTo(contentView)
            maker.height.equalTo(19)
            maker.left.equalToSuperview().offset(22)
            maker.right.equalToSuperview().offset(-22)
        }
        rightView.snp.makeConstraints { (maker) in
            maker.right.top.height.equalTo(contentView)
            maker.width.equalTo(22)
        }
        bottomView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(contentView)
            maker.height.equalTo(19)
            maker.left.equalToSuperview().offset(22)
            maker.right.equalToSuperview().offset(-22)
        }

        collectionView.snp.makeConstraints { (maker) in
            maker.left.right.width.equalToSuperview()
            maker.top.equalTo(contentView.snp.bottom).offset(20)
            maker.bottom.equalToSuperview().offset(-20)
        }
    }
}
extension UIImage{
    convenience init?(view:UIView,frame:CGRect = CGRect(x:0, y:0, width:0 , height:0)) {
        
        let scale = UIScreen.main.scale
        let newFrame = frame.scale(Int(scale))
        UIGraphicsBeginImageContextWithOptions(newFrame.size, true, scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        //  这里是重点, 意思是取范围内的cgimage
        let cgImage = (image?.cgImage)!.cropping(to: newFrame)
        self.init(cgImage:cgImage!)
    }
}
extension CGRect{
    
    public func scale(_ scale:Int) -> CGRect{
        var rect = self
        rect.size.width = self.width * CGFloat(scale)
        rect.size.height = self.height * CGFloat(scale)
        rect.origin.x = self.origin.x * CGFloat(scale)
        rect.origin.y = self.origin.y * CGFloat(scale)
        return rect
    }
}
