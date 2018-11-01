//
//  WFBookFileCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/5.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFBookFileCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
    }
    
    var model : ChooseImageModel?{
        didSet{
            if let model = model  {
               contenImageView.image = model.image ?? nil
               selectImageView.isHidden = !model.isSelect
               selectTipImageView.isHidden = selectImageView.isHidden
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   fileprivate var contenImageView : UIImageView = UIImageView.init()
   fileprivate var  selectTipImageView : UIImageView = UIImageView.init()
    fileprivate var  selectImageView : UIImageView = {
        let contentImage =   UIImageView.init()
         contentImage.backgroundColor = UIColor.black
         contentImage.alpha = 0.35
        return contentImage
    }()
    
}


extension WFBookFileCell {
    
   fileprivate func setUI() {
        addSubView()
        setConstant()
    }
    
   fileprivate func addSubView() {
        contentView.addSubview(contenImageView)
        contentView.addSubview(selectImageView)
        contentView.addSubview(selectTipImageView)
        selectTipImageView.image = #imageLiteral(resourceName: "selectImage")
        contenImageView.contentMode = .scaleAspectFill
        contentView.clipsToBounds = true
    }
    
    fileprivate func setConstant() {
        contenImageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
//            maker.center.equalToSuperview()
        }
        selectImageView.snp.makeConstraints { (maker) in
            maker.left.right.top.bottom.equalToSuperview()
        }
        selectTipImageView.snp.makeConstraints { (maker) in
            maker.right.top.equalToSuperview()
        }
    }
}



class ChooseImageModel : NSObject{
    
    var image : UIImage?
    var isSelect : Bool = false
    var isEditImage : Bool = false
    var indexRow : Int = -1
    init(_ image : UIImage , _ isSelect : Bool) {
        super.init()
        self.image = image
        self.isSelect = isSelect
    }
}












