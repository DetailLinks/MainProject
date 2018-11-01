//
//  NetworkerManager + VideoUrlExtension.swift
//  niinfor
//
//  Created by 王孝飞 on 2018/9/20.
//  Copyright © 2018年 孝飞. All rights reserved.
//

import Foundation
extension NetworkerManager{

    ///获取广告列表信息
    func getVideoAdSolts(complict : @escaping ( _ isSuccess : Bool,_ code : [WFAdModel])->() ) {
        
        request(urlString: "v1/els/getVideoAdSolts", parameters: [:] as [String : AnyObject]) { (json , isSuccess) in
            
            
            let modelArray  = NSArray.yy_modelArray(with: WFAdModel.self , json: json?["list"]  ?? [] ) as? [WFAdModel]
            
            return complict(isSuccess,modelArray ?? [] )
            
        }
    }
    //免费课程 v1/oes/getFreeCourse
    func getFreeCourse(complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        request(urlString: "v1/oes/getFreeCourse", parameters: [:] as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                    else {
                   return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
            
        }
    }
    

    //亚专业 v1/oes/getSpeclities
    func getSpeclities(complict : @escaping ( _ isSuccess : Bool,_ code : [TagModel])->() ) {
        
        request(urlString: "v1/oes/getSpeclities", parameters: [:] as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: TagModel.self , json: jso ?? [] ) as? [TagModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
            
        }
    }

    //热门标签 v1/oes/getHotTags
    func getHotTags(complict : @escaping ( _ isSuccess : Bool,_ code : [TagModel])->() ) {
        
        request(urlString: "v1/oes/getHotTags", parameters: [:] as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: TagModel.self , json: jso ?? [] ) as? [TagModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }

    
    //根据筛选 推荐课程 v1/oes/getRecommendCoursePage
    func getRecommendCoursePage(_ specialityId : String ,_ tagId : String ,_ order : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["specialityId" : specialityId,
                      "tagId" : tagId,
                      "order" : order,
                      "pageNo" : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getRecommendCoursePage", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }
    
    //根据筛选 免费课程 v1/oes/getFreeCoursePage
    func getFreeCoursePage(_ specialityId : String ,_ tagId : String ,_ order : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["specialityId" : specialityId,
                      "tagId" : tagId,
                      "order" : order,
                      "pageNo" : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getFreeCoursePage", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }
    
    //根据课程ID获取课程信息
    func getDefauleVideo(_ id : String,complict : @escaping ( _ isSuccess : Bool,_ code : WFDetailVideoModel?)->() ) {
        
        let params = ["courseId" : id]
        
        request(urlString: "v1/oes/getDefauleVideo", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            let model = WFDetailVideoModel()
            guard let jso  = json?["data"]
                else {
                    return complict(false,nil )
            }
            let modelArray  =  model.yy_modelSet(with:jso as? [AnyHashable : Any] ??  [:])

            if modelArray {
               return complict(true,model)
            }else{
                return complict(false,nil)
            }
            
        }
    }
    
    //根据课程ID获取课程信息
    func getCourseVideo(_ id : String,complict : @escaping ( _ isSuccess : Bool,_ code : WFDetailVideoModel?)->() ) {
        
        let params = ["videoId" : id]
        
        request(urlString: "v1/oes/getCourseVideo", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            let model = WFDetailVideoModel()
            guard let jso  = json?["data"]
                else {
                    return complict(false,nil )
            }
            let modelArray  =  model.yy_modelSet(with:jso as? [AnyHashable : Any] ??  [:])
            
            if modelArray {
                return complict(true,model)
            }else{
                return complict(false,nil)
            }
            
        }
    }


    //获取视频集 v1/oes/getCourseVideos
    func getCourseVideos(_ id : String ,complict : @escaping ( _ isSuccess : Bool,_ code :WFVideoClassModel?)->() ) {
        
        request(urlString: "v1/oes/getCourseVideos", parameters: ["courseId":id] as [String : AnyObject]) { (json , isSuccess) in
            
            let model = WFVideoClassModel()
            guard let jso  = json?["data"]
                else {
                    return complict(false,nil )
            }
            let modelArray  =  model.yy_modelSet(with:jso as? [AnyHashable : Any] ??  [:])
            
            if modelArray {
                return complict(true,model)
            }else{
                return complict(false,nil)
            }
        }
    }
    
    //获取视频集信息 v1/oes/getCourseVideoInfos
    func getCourseVideoInfos(_ id : String , _ definition : String ,complict : @escaping ( _ isSuccess : Bool,_ code :[WFVideoListModel])->() ) {
        
        request(urlString: "v1/oes/getCourseVideoInfos", parameters: ["courseId":id ,"definition" : definition] as [String : AnyObject]) { (json , isSuccess) in
            
            
            guard let jso  = json?["list"],
                  let modelArray  = NSArray.yy_modelArray(with: WFVideoListModel.self , json: jso ?? [] ) as? [WFVideoListModel]
                else {
                    return complict(false,[] )
            }
                return complict(true,modelArray)
        }
    }

    //分页获取评论 v1/oes/getCourseCommentList
    func getCourseCommentList(_ courseId : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFCommentListModel])->() ) {
        
        let params = ["courseId" : courseId,
                      "pageNo" : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getCourseCommentList", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFCommentListModel.self , json: jso ?? [] ) as? [WFCommentListModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }
    
    //评论课程
    func courseComment( courseId : String , content : String , score : String ,parentId : String,complict : @escaping ( _ isSuccess : Bool,_ code : AnyObject)->() ) {
        
        let params = ["courseId" : courseId,
                      "parentId" : parentId,
                      "score"    : score ,
                      "content"  : content ,
                      "userId"   : NetworkerManager.shared.userCount.id ?? "" ]
        
        request(method: .POST,urlString: "v1/oes/courseComment", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            return complict(isSuccess,"" as AnyObject)
        }
    }
    
    //点赞接口
    func commentDigg( _ courseId : String ,complict : @escaping ( _ isSuccess : Bool,_ code : AnyObject)->() ) {
        
        let params = ["commentId" : courseId,
                      "userId" : NetworkerManager.shared.userCount.id ?? ""]
        
        request(method: .POST,urlString: "v1/oes/commentDigg", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            return complict(isSuccess,"" as AnyObject)
        }
    }
    
    //获取相关课程默认10条 v1/oes/getCurrentCourseLimit
    func getCurrentCourseLimit(_ courseId : String ,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["courseId" : courseId]
        
        request(urlString: "v1/oes/getCurrentCourseLimit", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }
    
    //获取相关课程 v1/oes/getCurrentCoursePage
    func getCurrentCoursePage(_ specialityId : String ,_ tagId : String ,_ order : String ,_ courseId : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["specialityId" : specialityId,
                      "tagId" : tagId,
                      "order" : order,
                      "courseId" : courseId ,
                      "pageNo"   : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getCurrentCoursePage", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }

    //搜索课程 v1/oes/getCoursePageByName
    func getCoursePageByName(_ keywords : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["keywords" : keywords ,
                      "pageNo"   : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getCoursePageByName", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }

    
    //根据课程id获取课程 v1/oes/getCourseListByTag
    func getCourseListByTag(_ tagId : String ,_ pageNo : String,complict : @escaping ( _ isSuccess : Bool,_ code : [WFFreeClassModel])->() ) {
        
        let params = ["tagId" : tagId ,
                      "pageNo"   : pageNo,
                      "pageSize" : "10" ]
        
        request(urlString: "v1/oes/getCourseListByTag", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let jso  = json?["list"],
                let modelArray  = NSArray.yy_modelArray(with: WFFreeClassModel.self , json: jso ?? [] ) as? [WFFreeClassModel]
                else {
                    return complict(false, [] )
            }
            return complict(isSuccess,modelArray)
        }
    }
    
    //根据课程id来判断是否评论了该课程 v1/oes/isUserComment
    func isUserComment(_ courseId : String ,complict : @escaping ( _ isSuccess : Bool,_ code : Bool)->() ) {
        
        let params = ["courseId" : courseId ,
                      "userId"   : NetworkerManager.shared.userCount.id ?? "" ]
        
        request(urlString: "v1/oes/isUserComment", parameters: params as [String : AnyObject]) { (json , isSuccess) in
            
            guard let js = json?["data"] as? [String : String],
                let str = js["isComment"] else{
                return complict(false,false)
            }
            return complict(true,str == "T")
        }
    }

}
