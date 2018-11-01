//
//  WFSubspecialtyView.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/9.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFSubspecialtyView: UIView {

    var dataSource = [WFMPSubSpecialty](){
        didSet{
            
            let line  = dataSource.count % 3  == 0 ?  dataSource.count / 3 : dataSource.count / 3 + 1
            collectionView.snp.updateConstraints { (maker) in
                maker.height.equalTo(line * 50 + 40)
            }
            collectionView.reloadData()
        }
    }
    
    var selectArray = [Int]()
    var complict : (([WFMPSubSpecialty])->())?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    lazy var collectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize.init(width: transWidth(188.0), height: transWidth(58))
        
        layout.minimumLineSpacing = transWidth(23)
        layout.minimumInteritemSpacing = transWidth(23)
        
        let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.white
        
        collectionView.register(WFSubCollectionViewCell.self , forCellWithReuseIdentifier: WFSubCollectionViewCell().identfy)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsetsMake(16, 16, 16,16)
        
        return collectionView
    }()
}

///collectionDelegate
extension WFSubspecialtyView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : WFSubCollectionViewCell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFSubCollectionViewCell().identfy, for: indexPath) as! WFSubCollectionViewCell
        
        if selectArray.contains(indexPath.row) {
            cell.configModel(dataSource[indexPath.row], true)
        }
        else {
            cell.configModel(dataSource[indexPath.row])
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! WFSubCollectionViewCell
        cell.subBtn.isSelected = !cell.subBtn.isSelected
        
        if cell.subBtn.isSelected {
           selectArray.append(indexPath.row)
           cell.subBtn.layer.borderColor = #colorLiteral(red: 0.247707516, green: 0.6123195291, blue: 0.6999619603, alpha: 1)
        }else{
            cell.subBtn.layer.borderColor = #colorLiteral(red: 0.5921568627, green: 0.5921568627, blue: 0.5921568627, alpha: 1)
            if let index = selectArray.index(of: indexPath.row){
               selectArray.remove(at: index)
            }
        }
        }
}

//UI
extension WFSubspecialtyView{
    
    fileprivate func setUI() {
             addBottomView()
    }
    
    func addBottomView() {
        
        let bacView  = UIView.init()
        bacView.backgroundColor = UIColor.black
        bacView.alpha = 0.43
        addSubview(bacView)
        
        bacView.snp.makeConstraints { (maker ) in
            maker.left.right.bottom.top.equalToSuperview()
        }
        
        let btn  = UIButton.init(frame: CGRect.zero)
        btn.setAttributedTitle(NSMutableAttributedString(
            string: "确定",
            attributes: [NSFontAttributeName : UIFont(name: "PingFangSC-Regular", size: 14) ??
                UIFont.systemFont(ofSize: 14),NSForegroundColorAttributeName : #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)]),
                                           for: .normal)
 
        btn.backgroundColor = UIColor.white
        btn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        
        addSubview(btn)
        btn.snp.makeConstraints { (maker) in
            maker.left.right.bottom.equalToSuperview()
            maker.height.equalTo(50)
        }
        
        let lightView = UIView.init()
        lightView.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
        addSubview(lightView)
        lightView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(btn.snp.top)
            maker.height.equalTo(10)
        }

        addSubview(collectionView)
        collectionView.snp.makeConstraints { (maker) in
            maker.left.right.equalToSuperview()
            maker.bottom.equalTo(lightView.snp.top)
            maker.height.equalTo(0)
        }
        
    }
    
    @objc func cancelBtnClick(){
             isHidden = true
        if  let complict = complict {
            
            var array  = [WFMPSubSpecialty]()
            
            for item in selectArray{
                array.append(dataSource[item])
            }
            
            complict(array)
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            isHidden = true
    }
}












