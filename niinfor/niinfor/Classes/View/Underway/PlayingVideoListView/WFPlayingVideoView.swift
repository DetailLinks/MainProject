//
//  WFPlayingVideoView.swift
//  niinfor
//
//  Created by 王孝飞 on 2017/8/30.
//  Copyright © 2017年 孝飞. All rights reserved.
//

import UIKit

class WFPlayingVideoView: UITableView,UITableViewDelegate,UITableViewDataSource {

    
    var dataList  = [WFPlayModel](){
        didSet{
            
            var height : CGFloat  = 0
            
            for item  in dataList {
                
                height = height + item.cellHeight
            }
            
            playingViewHeightCons.constant = height
            
            self.reloadData()
        }
    }
    
    @IBOutlet weak var playingViewHeightCons: NSLayoutConstraint!
    
}


// MARK: - 设置视图
extension WFPlayingVideoView {

    override func awakeFromNib() {
        super.awakeFromNib()
        
        setUpTableView()
    }
    
    private func setUpTableView () {
        
        dataSource = self
        delegate = self
        tableFooterView = UIView()
        
        self.register(UINib.init(nibName: WFPlayingViewCell().identfy, bundle: nil), forCellReuseIdentifier: WFPlayingViewCell().identfy)
    }
    
}

extension WFPlayingVideoView{
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let  cell  = tableView.dequeueReusableCell(withIdentifier: WFPlayingViewCell().identfy, for: indexPath) as? WFPlayingViewCell
        
          cell?.model = dataList[indexPath.row]
    
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return  dataList[indexPath.row].cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc  = WFVideoDetailController()
        
        vc.title = "直录播"
        vc.htmlString = Photo_Path + (dataList[indexPath.row].meetingUrl ?? "")

        let mainContoller = UIApplication.shared.delegate?.window??.rootViewController as? MainViewController
        
        let controler = mainContoller?.viewControllers?[2] as? WFNavigationController
        controler?.pushViewController(vc , animated: true)
    }
}




