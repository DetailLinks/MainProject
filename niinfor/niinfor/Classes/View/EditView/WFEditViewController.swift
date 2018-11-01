//
//  WFEditViewController.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/8/13.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit
import SnapKit

class WFEditViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(iconCollectionView)
        view.addSubview(buttomBtn)
        let appdelegate  = UIApplication.shared.delegate as? AppDelegate
//        appdelegate?.isRotation = false
        
        UIScreen.rotationScreen()

        ///添加约束
        setConstrite()

    }

    ///底部 button
    lazy var buttomBtn : UIButton = {
        
        let btn = UIButton.init()
        btn.setImage(#imageLiteral(resourceName: "删除"), for: .normal)
        btn.addTarget(self, action: #selector(buttomBtnClick), for: .touchUpInside)
        btn.layer.borderWidth =  1
        btn.layer.borderColor =  #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1).cgColor
        
        return btn
    }()
    
    ///中间视图
    lazy var iconCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout.init()
        
            layout.itemSize = CGSize.init(width: transWidth(191.0), height: transWidth(191.0) * 205 / 191 )
        
            layout.minimumLineSpacing = transWidth(78.0)
            layout.minimumInteritemSpacing = transWidth(40.0 + 60)
        
        let collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
            collectionView.backgroundColor = UIColor.white
        
            collectionView.register(WFEditeIconCell.self , forCellWithReuseIdentifier: WFEditeIconCell().identfy)
            collectionView.delegate = self
            collectionView.dataSource = self
        
            collectionView.contentInset = UIEdgeInsetsMake(0, transWidth(36 + 80 ), 0, transWidth(36 + 80))
        
        return collectionView
    }()
    
    ///数据源
    lazy var dataSouce : [CollectionModel] = {
        return [
            CollectionModel.init("Group 5", "病例"),
            CollectionModel.init("Group 6", "随笔"),
            //CollectionModel.init("Group 8", "直播"),
            CollectionModel.init("Group 9", "草稿箱"),
            CollectionModel.init("Group 10", "已发布"),
            //CollectionModel.init("Group 11", "文章投稿"),
            ]
    }()

}

extension WFEditViewController {
    
    func buttomBtnClick() {
         dismiss(animated: true, completion: nil)
    }
    
}

extension WFEditViewController : UICollectionViewDataSource,UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSouce.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : WFEditeIconCell  = collectionView.dequeueReusableCell(withReuseIdentifier: WFEditeIconCell().identfy, for: indexPath) as! WFEditeIconCell
        
        cell.configModel(dataSouce[indexPath.row])
        cell.origenRect = cell.frame
        cell.titleLabel.isHidden = true
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        
        var cellframe = cell.frame
        cellframe.origin.y = Screen_height
        cell.frame = cellframe
        
//        UIView.animate(withDuration: 1.5, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.0, options: [], animations: {
//            () -> Void in
//            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
//            cell.frame = cell.origenRect
//        }, completion: nil)
//        UIView.animate(withDuration: 0.33, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: [], animations: {
//            () -> Void in
//
//
//        }, completion: nil)
        
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {

            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            cell.frame = cell.origenRect

        }) { (isSuccess) in

            cell.titleLabel.isHidden = false

        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if NetworkerManager.shared.userCount.id == nil || NetworkerManager.shared.userCount.id ?? "" == ""   {
           
            let loginView  = WFLoginViewController()
            navigationController?.pushViewController(loginView, animated: true)
            return
        }
        
        switch indexPath.row {
        case 0:
            mainDataSouce = []
            let vc  = WFNewCaseViewController()
            vc.caseType = .new
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            mainDataSouce = []
            let vc  = WFNewCaseViewController()
            //vc.caseType = .old("10000")
            vc.articleType = "1"
            vc.caseType = .new
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            mainDataSouce = []
            let vc  = WFRealDraftViewController()
            self.navigationController?.pushViewController(vc, animated: true)

        case 3:
            let vc  = WFDraftViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        default:
            break
        }
    }
}


// MARK: 添加约束
extension WFEditViewController{
    
    func setConstrite() {
        
        //添加iconview约束
        iconCollectionView.snp.makeConstraints { (maker ) in
            maker.width.left.right.equalToSuperview()
            maker.top.equalToSuperview().offset(Screen_height * 170 / Screen_height)
            maker.height.equalToSuperview().offset(Screen_height - Screen_width).multipliedBy(400/375)//200
        }
        
        //添加按钮约束
        buttomBtn.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(2)
            maker.left.right.equalToSuperview().offset(-1)
            maker.bottom.equalToSuperview().offset(1)
            maker.height.equalToSuperview().multipliedBy(0.1)
        }
        
        
    }
    
}

