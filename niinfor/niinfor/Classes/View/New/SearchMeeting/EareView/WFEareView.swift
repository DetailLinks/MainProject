//
//  WFEareView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/28.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFEareView: UICollectionView ,UICollectionViewDataSource,UICollectionViewDelegate {

    var  array  = [WFEducationModel]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        backgroundColor = UIColor.white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        bounces = false
        
        delegate = self
        dataSource = self
        
        register(UINib.init(nibName: WFEareCollectionViewCell().identfy,
                                       bundle: nil),
                                       forCellWithReuseIdentifier: WFEareCollectionViewCell().identfy)
        
        reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let layout  = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: Screen_width / 2, height: 60)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        self.collectionViewLayout = layout
        
        delegate = self
        dataSource = self
        
        register(UINib.init(nibName: WFEareCollectionViewCell().identfy,
                            bundle: nil),
                 forCellWithReuseIdentifier: WFEareCollectionViewCell().identfy)
        
        reloadData()

    }
    
    ///初始化方法
    convenience init(_ frame : CGRect) {
        
        /// 设置layout
        let layout  = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: Screen_width / 2, height: 60)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        self.init(frame: frame, collectionViewLayout: layout)
        
    }
    
}


// MARK: - 代理方法
extension WFEareView{
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFEareCollectionViewCell().identfy, for: indexPath) as? WFEareCollectionViewCell
        
        cell?.model = array[indexPath.row]
        
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count 
    }
}

