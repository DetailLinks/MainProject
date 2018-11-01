//
//  WFVideoCollectionViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFVideoCollectionViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    
}

extension WFVideoCollectionViewController{
    
    override func setUpUI() {
        super.setUpUI()
        
        removeTabelView()
        title =  "视频收藏"

        setUpcollectionView()
        
        loadNetData()
    }
    
   private func loadNetData() {
        
        NetworkerManager.shared.collectListInfor( 0 , "\(page)") { (isSuccess, json) in
            
            if isSuccess == true  {
                
                self.base_dataList = self.base_dataList + json
                self.collectionView.reloadData()
                
            }
        }
        
    }

    /// 设置collocationView
   private  func setUpcollectionView() {
        
        let  layout  = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(width: (Screen_width - 30) / 2, height: (Screen_width - 30) / 2 * 0.664 + 47)
        
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsetsMake(12, 10, 10, 10)
        
        collectionView.collectionViewLayout = layout
        collectionView.register(UINib.init(nibName: WFVideoCollectionCell().identfy, bundle: nil),
                                                                forCellWithReuseIdentifier: WFVideoCollectionCell().identfy)
    }
    
}


extension WFVideoCollectionViewController: UICollectionViewDelegate,UICollectionViewDataSource{
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return base_dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFVideoCollectionCell().identfy, for: indexPath) as? WFVideoCollectionCell
        
        cell?.model = base_dataList[indexPath.row] as? WFCollectionModel
        
        return cell!
    }
    
}
