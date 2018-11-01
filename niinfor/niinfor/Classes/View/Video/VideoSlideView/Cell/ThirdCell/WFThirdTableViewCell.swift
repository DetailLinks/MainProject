//
//  WFThirdTableViewCell.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import UIKit

protocol CommentCellFoldProtocol {
    func foldBtnClick(_ btn : UIButton , _ cell : WFThirdTableViewCell)
    func commentBtnClick(_ btn : UIButton , _ cell : WFThirdTableViewCell)
    func priseBtnClick(_ btn : UIButton , _ cell : WFThirdTableViewCell)
    func clickPeopleNameReply(_ parentString  : String , _ cell : WFThirdTableViewCell)
}

class WFThirdTableViewCell: WFBaseTableViewCell {

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var delegate : CommentCellFoldProtocol?
    
    
    fileprivate let headImageView   = UIImageView.init()
    fileprivate let starImageView   = UIImageView.init()
    fileprivate let titleLabel      = UILabel.init()
    fileprivate let contentLabel    = UILabel.init()
    fileprivate let timeLabel       = UILabel.init()
    fileprivate let priseBtn        = UIButton.init()
    fileprivate let commentBtn      = UIButton.init()
    fileprivate let messageContView = UIView.init()
    fileprivate let grayStarView    = UIView.init()
    fileprivate let highligthStarView = UIView.init()
    
    
    fileprivate var replayArray : [UILabel]  = []
    
    fileprivate let subreplayView   = UIView.init()
    fileprivate var model   = WFCommentListModel()
    
    override class func dequneceTableView(_ tableView: UITableView, _ cellString: String, _ indexPath: IndexPath, _ model: AnyObject) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellString, for: indexPath) as? WFThirdTableViewCell
        
        if let model = model as? [WFCommentListModel]{
            cell?.configCell(model[indexPath.row])
        }
        
        return cell!
    }
    
    func configCell(_ model : WFCommentListModel) {
        
         self.model = model
         titleLabel.text = model.commentator.realName
         timeLabel.text  = (model.commentTime as NSString).substring(to: 10)
         contentLabel.text = model.content
        
         priseBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.diggs)", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
         priseBtn.isSelected = model.isDigg == "T"
        
         commentBtn.setAttributedTitle(NSAttributedString.init(string: " \(model.replys)", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)

         if let url  = URL.init(string: model.commentator.avatarAddress ){
            headImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "avatar"), options: [], completed: nil)
         }else{
            headImageView.image = #imageLiteral(resourceName: "avatar")
         }
        
        highligthStarView.snp.updateConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(4)
            maker.left.equalTo(titleLabel)
            maker.height.equalTo(12)
            maker.width.equalTo(Float(model.score)!  * 12.7)
        }
        
        replayArray.removeAll()
        for item in  subreplayView.subviews {
            item.removeFromSuperview()
        }
        
        for (index , item) in model.childComments.enumerated() {
            
            if model.isFoldComment == true && model.childComments.count > 3{
             if index > 2 {return}
            }
            
            let  label  = UILabel.init()
            label.textColor = #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1)
            label.font = UIFont.systemFont(ofSize: 12)
            label.attributedText = setAttribute(item.parent, item.child, item.text)
            label.numberOfLines = 0
            label.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
            label.isUserInteractionEnabled = true
            label.tag = index
            
            let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(labelTapGestrue(_:)))
            label.addGestureRecognizer(tapGes)
            
            subreplayView.addSubview(label)
            replayArray.append(label)
            
            if index == 0{
                label.snp.makeConstraints { (maker) in
                     maker.left.right.top.equalToSuperview()
                     maker.height.greaterThanOrEqualTo(20)
                    
                    if model.childComments.count == 1{
                       maker.bottom.equalToSuperview()
                    }
                }
            }else if index == model.childComments.count - 1{
                label.snp.makeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(replayArray[index-1].snp.bottom)
                    maker.height.greaterThanOrEqualTo(20)
                    if model.childComments.count < 4{
                        maker.bottom.equalToSuperview()
                    }
                }
            }else{
                label.snp.makeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(replayArray[index-1].snp.bottom)
                    maker.height.greaterThanOrEqualTo(20)
                }
            }
            
            //model.childComments.count - 1
            
            let indexNumber = model.isFoldComment ?  2 : model.childComments.count - 1
            
            if model.childComments.count > 3 && index == indexNumber{
              
                let clickBtn = UIButton.init()
                clickBtn.titleLabel?.textAlignment = .left
                clickBtn.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
                clickBtn.setAttributedTitle(NSAttributedString.init(string: " 查看全部\(model.replys)条回复", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
                clickBtn.setAttributedTitle(NSAttributedString.init(string: " 收起评论", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .selected)

                clickBtn.contentHorizontalAlignment = .left
                clickBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0)
                clickBtn.isSelected = !model.isFoldComment
                clickBtn.addTarget(self, action: #selector(commentBtnClick(_:)), for: .touchUpInside)
                
                subreplayView.addSubview(clickBtn)
                
                clickBtn.snp.removeConstraints()
                clickBtn.snp.makeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(replayArray[replayArray.count - 1].snp.bottom)
                    maker.height.equalTo(20)
                    maker.bottom.equalToSuperview()
                }
            }
        }
        
    }
    
    @objc func commentBtnClick(_ btn : UIButton){
          btn.isSelected = !btn.isSelected
        
        if delegate != nil {
           delegate?.foldBtnClick(btn, self)
        }
        return
        for (index, label)  in replayArray.enumerated() {
            
            if index <= 2 {return}
            if btn.isSelected == true{
            if index == 0{
                label.snp.makeConstraints { (maker) in
                    maker.left.right.top.equalToSuperview()
                    maker.height.greaterThanOrEqualTo(20)
                }
            }else if index == model.childComments.count - 1{
                label.snp.makeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(replayArray[index-1].snp.bottom)
                    maker.height.greaterThanOrEqualTo(20)
                    if model.childComments.count <= 4{
                        maker.bottom.equalToSuperview()
                    }
                }
            }else{
                label.snp.makeConstraints { (maker) in
                    maker.left.right.equalToSuperview()
                    maker.top.equalTo(replayArray[index-1].snp.bottom)
                    maker.height.greaterThanOrEqualTo(20)
                }
            }
            }else{
                label.snp.removeConstraints()
            }
        }
        
        if btn.isSelected == false {
            btn.snp.remakeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalTo(replayArray[2].snp.bottom)
                maker.height.equalTo(20)
                maker.bottom.equalToSuperview()
            }
        }else{
            btn.snp.remakeConstraints { (maker) in
                maker.left.right.equalToSuperview()
                maker.top.equalTo(replayArray[replayArray.count - 1].snp.bottom)
                maker.height.equalTo(20)
                maker.bottom.equalToSuperview()
            }
        }
        
    }
    
    fileprivate func setAttribute(_ parentString : String , _ childString : String , _ text : String  ) -> NSAttributedString {
        
        let attributedStrM : NSMutableAttributedString = NSMutableAttributedString()
        let pString : NSAttributedString = NSAttributedString(string: parentString != "" ? "\(parentString)：" : parentString,
                                                              attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        
        
        
        let cSring : NSAttributedString = NSAttributedString(string: parentString == "" ? "  \(childString)：" : "  \(childString)",
                                                             attributes:[NSForegroundColorAttributeName : #colorLiteral(red: 0.2470588235, green: 0.6117647059, blue: 0.7019607843, alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        
        let replyString : NSAttributedString = NSAttributedString(string:parentString == "" ? "" : " 回复 ",
                                                                  attributes:[NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        
        let textString = text
        let tString : NSAttributedString = NSAttributedString(string:textString ,
                                                             attributes:[NSForegroundColorAttributeName : #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1),NSFontAttributeName : UIFont.systemFont(ofSize: 12)])
        attributedStrM.append(cSring)
        attributedStrM.append(replyString)
        attributedStrM.append(pString)
        attributedStrM.append(tString)
        return attributedStrM
    }
    
}

extension WFThirdTableViewCell{
    fileprivate func setUI() {
        addViews()
        setConstraint()
    }
    fileprivate func  addViews() {
        
        titleLabel.text   = "老胡"
        timeLabel.text    = "2018-9-07"
        contentLabel.text = "课程真是太好了 "
        
        contentLabel.numberOfLines = 0
        
        setLabelConfige(titleLabel, 13, #colorLiteral(red: 0.2745098039, green: 0.2745098039, blue: 0.2745098039, alpha: 1))
        setLabelConfige(contentLabel, 13, #colorLiteral(red: 0.1960784314, green: 0.1960784314, blue: 0.1960784314, alpha: 1))
        setLabelConfige(timeLabel, 13, #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1))
        headImageView.image = #imageLiteral(resourceName: "avatar")
        headImageView.layer.cornerRadius = 22
        headImageView.layer.masksToBounds = true
        
        priseBtn.setImage(#imageLiteral(resourceName: "prise"), for: .normal)
        priseBtn.setImage(#imageLiteral(resourceName: "release_zan_on"), for: .selected)
        commentBtn.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        
        priseBtn.setAttributedTitle(NSAttributedString.init(string: " 0", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)
        commentBtn.setAttributedTitle(NSAttributedString.init(string: " 0", attributes: [NSForegroundColorAttributeName : #colorLiteral(red: 0.5882352941, green: 0.5882352941, blue: 0.5882352941, alpha: 1) , NSFontAttributeName : UIFont.systemFont(ofSize: 12)]), for: .normal)

        commentBtn.addTarget(self, action: #selector(commenttBtnClick(_:)), for: .touchUpInside)
        priseBtn.addTarget(self, action: #selector(priseBtnClick(_:)), for: .touchUpInside)
        
        subreplayView.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
        subreplayView.layer.cornerRadius = 4
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(headImageView)
        contentView.addSubview(starImageView)
        contentView.addSubview(grayStarView)
        contentView.addSubview(highligthStarView)
        contentView.addSubview(subreplayView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(priseBtn)
        contentView.addSubview(commentBtn)
        contentView.addSubview(messageContView)
        
        highligthStarView.clipsToBounds = true
        for item  in 0...4 {
            let startImageView : UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(item) * 12.7, y: 0.0, width: 12.7, height: 12) )
            startImageView.image = #imageLiteral(resourceName: "icon_star")
            grayStarView.addSubview(startImageView)
        }
        
        for item  in 0...4 {
            let startImageView : UIImageView = UIImageView.init(frame: CGRect.init(x: CGFloat(item) * 12.7, y: 0.0, width: 12.7, height: 12) )
            startImageView.image = #imageLiteral(resourceName: "icon_star_pressed")
            highligthStarView.addSubview(startImageView)
        }
        
    }
    
    fileprivate func setConstraint() {
        headImageView.snp.makeConstraints { (maker) in
            maker.width.height.equalTo(44)
            maker.top.equalToSuperview().offset(10)
            maker.left.equalToSuperview().offset(13)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(headImageView).offset(8)
            maker.left.equalTo(headImageView.snp.right).offset(15)
        }
        starImageView.snp.makeConstraints { (maker) in
            maker.left.equalTo(titleLabel.snp.right).offset(15)
            maker.top.equalTo(titleLabel.snp.bottom).offset(5)
//            maker.height.equalTo(20)
//            maker.width.equalTo(60)
        }
        grayStarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(4)
            maker.left.equalTo(titleLabel)
        }
        highligthStarView.snp.makeConstraints { (maker) in
            maker.top.equalTo(titleLabel.snp.bottom).offset(4)
            maker.left.equalTo(titleLabel)
            maker.height.equalTo(12)
            maker.width.equalTo(0)
        }
        titleLabel.snp.makeConstraints { (maker) in
            maker.top.equalTo(headImageView).offset(8)
            maker.left.equalTo(headImageView.snp.right).offset(15)
        }
        contentLabel.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(-26)
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(headImageView.snp.bottom).offset(12)
        }
        subreplayView.snp.makeConstraints { (maker) in
            maker.width.equalToSuperview().offset(-26)
            maker.left.equalToSuperview().offset(13)
            maker.top.equalTo(contentLabel.snp.bottom).offset(12)
        }
        timeLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(headImageView)
            maker.bottom.equalToSuperview().offset(-13)
            maker.top.equalTo(subreplayView.snp.bottom).offset(10)
            maker.height.equalTo(15)
        }

        commentBtn.snp.makeConstraints { (maker) in
            maker.right.equalToSuperview().offset(-16)
            maker.bottom.equalToSuperview().offset(-10)
        }
        priseBtn.snp.makeConstraints { (maker) in
            maker.right.equalTo(commentBtn.snp.left).offset(-10)
            maker.bottom.equalToSuperview().offset(-10)
        }

    }
    
    @objc fileprivate func commenttBtnClick(_ btn : UIButton) {
        if delegate != nil  {
           delegate?.commentBtnClick(btn , self)
        }
    }
    
    @objc fileprivate func priseBtnClick(_ btn : UIButton) {
        if delegate != nil  {
            delegate?.priseBtnClick(btn , self)
        }
    }
    
    @objc fileprivate func labelTapGestrue(_ tap : UITapGestureRecognizer){
        
        guard let label  = tap.view as? UILabel else { return }
        
        let models = self.model.childComments[label.tag]
        if self.delegate != nil  {
            delegate?.clickPeopleNameReply("\(models.id)", self)
        }

        return
        
        let point  = tap.location(in: label)
        let model = self.model.childComments[label.tag]
        
        var replayString  = ""
        if point.y > 20 { return }
        
        if model.parent == "" {
           replayString = model.child
        }
        
        let childRange = getStringWidth(model.child)
        let parentRange = getStringWidth(model.parent)
        
        if point.x < childRange + 30 {
           replayString = model.child
        }else if childRange + 30 < point.x && point.x < parentRange + childRange + 30{
           replayString = model.parent
        }else{
            return
        }
        
            }
    
    
    fileprivate func getStringWidth(_ str : String)->CGFloat{
        return (str as NSString).boundingRect(with: CGSize.init(width: Screen_width - 20, height: 20), options: [], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 12)], context: nil).size.width
    }
    
    func setLabelConfige(_ label : UILabel , _ size : CGFloat , _ color  : UIColor) {
        label.textColor = color
        label.font = UIFont.systemFont(ofSize: size)//UIFont(name: fontNameString, size: size)
        //UIFont.init(name: fontNameString , size: size)
    }
}
