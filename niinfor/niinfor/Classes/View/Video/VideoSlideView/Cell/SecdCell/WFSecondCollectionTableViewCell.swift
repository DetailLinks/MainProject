//
//  WFSecondCollectionTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

class WFSecondCollectionTableViewCell: WFBaseTableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var currentClass : [WFFreeClassModel]  = []{
        didSet{
            collectionView?.reloadData()
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var collectionView : UICollectionView?
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath)
        
        return cell
    }
}
extension WFSecondCollectionTableViewCell : UICollectionViewDelegate,UICollectionViewDataSource{
    fileprivate func setUI() {
        configCollectionView()
        contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints { (maker) in
            maker.left.top.right.bottom.equalToSuperview()
            maker.height.equalTo(125)
        }
    }
    
    fileprivate func configCollectionView() {
        let layout = UICollectionViewFlowLayout.init()
        
        layout.itemSize = CGSize.init(width:134, height:125)
        
        layout.minimumLineSpacing = transWidth(4)
        layout.minimumInteritemSpacing = transWidth(4)
        layout.scrollDirection = .horizontal
        
        collectionView  = UICollectionView.init(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.bounces = false
        
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.register(WFTableViewCollectionViewCell.self , forCellWithReuseIdentifier: WFTableViewCollectionViewCell().identfy)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.contentInset = UIEdgeInsetsMake(0, 13, 0,0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: notifi_current_class_notify),
                                        object: ["classId":"\(currentClass[indexPath.row].id)",
                                                 "classImage":"\(currentClass[indexPath.row].image)",
                                                 "className" :"\(currentClass[indexPath.row].name)"                                                   ])

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentClass.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WFTableViewCollectionViewCell().identfy, for: indexPath) as? WFTableViewCollectionViewCell
        cell?.model = currentClass[indexPath.row]
        return cell!
    }
}









