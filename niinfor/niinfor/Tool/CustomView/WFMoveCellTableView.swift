//
//  WFMoveCellTableView.swift
//  MoveDemoTest
//
//  Created by 王孝飞 on 2018/8/24.
//  Copyright © 2018年 王孝飞. All rights reserved.
//

import UIKit

protocol MoveCellDelegate : UITableViewDelegate {
    func tableView(_ tableView : WFMoveCellTableView, customizeStartMovingAnimationWithimage image : UIImageView , fingerPoint point : CGPoint) -> ()
}

@objc protocol MoveCellDataSource : UITableViewDataSource {
    func dataSource(inTableView tableView : WFMoveCellTableView) -> [AnyObject]
    func returnDataSource(_ array : [AnyObject])
}

class WFMoveCellTableView: UITableView {

    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        addGesture()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        delegatet = nil
        dataSourcee = nil
    }
    
    var kMoveCellAnimationTime = 0.4
    var longGesture : UILongPressGestureRecognizer?
    var panGesture : UIPanGestureRecognizer?
    
    var minimumPressDuration = 0.3
    var selectIndexPath : IndexPath?
    var snapShot : UIImageView?
    var tempDataSource : [AnyObject]  = []
    var scrollDisplayLink : CADisplayLink?
    var currentScrollSpeed : CGFloat = 20
    
    var delegatet : MoveCellDelegate?
    var dataSourcee : MoveCellDataSource?
    var canEdgeScroll = true
    var edgeScrollTriggerRange : CGFloat = 150
    var maxScrollSpeedPerFrame : CGFloat = 20
    
}

extension WFMoveCellTableView{
    
    func addGesture() {
        
        longGesture = UILongPressGestureRecognizer.init(target: self, action: #selector(moveCellLongGesture(_:)))
        addGestureRecognizer(longGesture!)
    }
    
    @objc func pinGestureRecogniers(_ longG: UILongPressGestureRecognizer) {
               longGesture?.minimumPressDuration = 0.01
               moveCellLongGesture(longGesture!)
    }
    
    @objc func moveCellLongGesture(_ longG : UIGestureRecognizer) {
        
        switch longG.state {
        case .began:
            let point = longG.location(in: longG.view)
            let indexPath = self.indexPathForRow(at: point)
            guard let indexPaths = indexPath else {
                return
            }
            hideSubviews(true)
            gestureBegin(indexPaths,point)
            break
            
        case .changed:
            
            if !canEdgeScroll {
                longGestureChanged(longG)
            }
            break
        case .cancelled,.ended:
            gestureEndOrCancel(longG)
            if longGesture?.minimumPressDuration == 0.01 {
               longGesture?.minimumPressDuration = 0.5
            }
            break
        default: break
        }
        
    }
    
    ///长按改变状态
    func longGestureChanged(_ longG : UIGestureRecognizer) {
         var point = longG.location(in: longG.view)
         point = CGPoint.init(x: (snapShot?.center.x)!, y: limitedSnapOffsetY(point.y))
        
         let indexPath = self.indexPathForRow(at: point)
         guard let indexPaths = indexPath else {
            return
         }
         gestureChange(indexPaths,point)
    }
    
    func hideSubviews(_ isTrue : Bool) {
        for cell  in subviews {
            if let cell = cell as? WFCaseContentCell{
                cell.clickBtn.isHidden = isTrue
            }
            
            if let cell = cell as? WFCaseEditHeaderView{
                cell.clickBtn.isHidden = isTrue
            }

        }
    }
    
}

extension WFMoveCellTableView{
    
    func gestureBegin(_ indexPath : IndexPath , _ point : CGPoint) {
        
        let cell  = cellForRow(at: indexPath)
        selectIndexPath = indexPath
        if canEdgeScroll {
            ///Timer start
            setUpTimerScroll()
        }
        
        if dataSourcee != nil {
            tempDataSource = (dataSourcee?.dataSource(inTableView: self))!
        }

        snapShot = snapViewIn(cell!)
        
        snapShot?.layer.shadowColor = UIColor.gray.cgColor
        snapShot?.layer.masksToBounds = false
        snapShot?.layer.cornerRadius = 0
        snapShot?.layer.shadowOffset = CGSize.init(width: -5, height: 0)//CGSize.init(-5, 0)
        snapShot?.layer.shadowOpacity = 0.4
        snapShot?.layer.shadowRadius = 5
        
        snapShot?.frame = (cell?.frame)!
        
        for item  in self.subviews {
            if item.isMember(of: UIImageView.self){
               item.removeFromSuperview()
            }
        }
        addSubview(snapShot!)
        
        cell?.isHidden = true
        
        //当需要外部自己定义的时候就可以用代理让用户实现自定义
        UIView.animate(withDuration: kMoveCellAnimationTime) {
            self.snapShot?.center = CGPoint.init(x: (self.snapShot?.center.x)!, y: point.y)
        }
    }

    func gestureChange(_ indexPaths : IndexPath , _ point : CGPoint)  {
    
        //fwllow
        snapShot?.center = point

        let selectCell  = cellForRow(at: selectIndexPath!)
        selectCell?.isHidden = true
        
        if  selectIndexPath?.row != indexPaths.row {
            
            //更换数据
            updateDatasourceAndCells(selectIndexPath!, indexPaths)
            
//            if dataSourcee != nil{
//                dataSourcee?.tableView!(self, moveRowAt: selectIndexPath!, to: indexPaths)
//            }
            
            selectIndexPath = indexPaths
        }
        
        }
    
    func gestureEndOrCancel(_ longG : UIGestureRecognizer) {
        
        if canEdgeScroll {
           endDidScrollor()
        }
        
        guard let indexPath = selectIndexPath else {
            return
        }
        self.dataSourcee?.returnDataSource(tempDataSource)
        let cell  = cellForRow(at:indexPath )
        UIView.animate(withDuration: kMoveCellAnimationTime, animations: {
            self.snapShot?.transform = CGAffineTransform.identity
            self.snapShot?.frame = cell?.frame ?? CGRect.zero
        }) { (isTrue) in
            cell?.isHidden = false
            self.snapShot?.removeFromSuperview()
            self.snapShot = UIImageView.init()
            self.hideSubviews(false)
        }
        
    }

}

extension WFMoveCellTableView{
    
    func updateDatasourceAndCells(_ fromIndex : IndexPath , _ toIndex : IndexPath) {

        self.beginUpdates()
        (tempDataSource[fromIndex.row],tempDataSource[toIndex.row]) = (tempDataSource[toIndex.row],tempDataSource[fromIndex.row])
        moveRow(at: fromIndex, to: toIndex)
        self.endUpdates()
    }
    
}

///Timer
extension WFMoveCellTableView{
   
    func setUpTimerScroll() {
        scrollDisplayLink = CADisplayLink.init(target: self, selector: #selector(tableVeiwDidScroll))
        scrollDisplayLink?.add(to: RunLoop.current, forMode: .commonModes)
    }
    
    @objc func tableVeiwDidScroll() {
        let minY = self.contentOffset.y + edgeScrollTriggerRange
        let maxY = self.contentOffset.y + self.bounds.size.height - edgeScrollTriggerRange
        guard let touchPoint  = snapShot?.center else {
            return
        }
        
        if touchPoint.y < minY { //moving up
            
            let movingDistance = (minY - touchPoint.y)/edgeScrollTriggerRange * maxScrollSpeedPerFrame
            currentScrollSpeed = movingDistance
            self.contentOffset = CGPoint.init(x: contentOffset.x, y: limitedContentOffsetY(self.contentOffset.y - movingDistance))
            self.snapShot?.center = CGPoint.init(x: (self.snapShot?.center.x)!, y: limitedSnapOffsetY(touchPoint.y))
        }else if touchPoint.y > maxY{//moving down
            
            let moveDistance = (touchPoint.y - maxY) / edgeScrollTriggerRange * maxScrollSpeedPerFrame
            currentScrollSpeed = moveDistance
            
            self.contentOffset = CGPoint.init(x: contentOffset.x, y: limitedContentOffsetY(self.contentOffset.y + moveDistance))
            self.snapShot?.center = CGPoint.init(x: (self.snapShot?.center.x)!, y: limitedSnapOffsetY(touchPoint.y + moveDistance))
            
        }
        
            longGestureChanged(longGesture!)
    }
    
    func endDidScrollor() {
        
        currentScrollSpeed = 0
        if (scrollDisplayLink != nil) {
            scrollDisplayLink?.invalidate()
            scrollDisplayLink = nil
        }
    }
    
}

extension WFMoveCellTableView{
    
    func limitedSnapOffsetY(_ centy : CGFloat) -> CGFloat {
        let minValue = (self.snapShot?.bounds.size.height)! / 2.0  + self.contentOffset.y
        let maxValue = self.contentOffset.y + self.bounds.size.height - (self.snapShot?.bounds.size.height)! / 2.0
        
        return min(maxValue, max(minValue, centy))
    }
    
    func limitedContentOffsetY(_ centy : CGFloat) -> CGFloat {
        let minContentOffsetY : CGFloat  = 0//(self.snapShot?.bounds.size.height)! / 2.0  + self.contentOffset.y
        let maxContentOffsetY : CGFloat = self.contentSize.height - self.bounds.size.height
        
        return min(maxContentOffsetY, max(minContentOffsetY, centy))
    }

    
    func snapViewIn(_ view : UIView) -> UIImageView {
         UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, 0)
         view.layer.render(in: UIGraphicsGetCurrentContext()!)
         let image = UIGraphicsGetImageFromCurrentImageContext()
         UIGraphicsEndImageContext()
         return UIImageView.init(image: image)
    }
}
















